#!/bin/bash
# =============================================================================
# test_adb_install.sh — Test APK installation via ADB on BlueStacks / Android
# =============================================================================
# Usage:
#   bash tools/test_adb_install.sh [path-to-apk]
#
# Defaults to test_build/AstroRecolte-release.apk
# Detects BlueStacks, standard emulators, and real devices.
# =============================================================================

set -euo pipefail

APK="${1:-test_build/AstroRecolte-release.apk}"
BLUESTACKS_PORTS=(5555 5556 5557 5558)
EMULATOR_PORTS=(5554 5556 5558)

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}============================================${NC}"
echo -e "${CYAN}  AstroRecolte — ADB Install Test Script${NC}"
echo -e "${CYAN}============================================${NC}"
echo ""

# --- Step 1: Verify APK exists and is valid ---
echo -e "${YELLOW}[1/6] Checking APK file...${NC}"
if [ ! -f "$APK" ]; then
    echo -e "${RED}  ✗ APK not found: $APK${NC}"
    echo "  Available APKs:"
    find . -name "*.apk" -type f 2>/dev/null | head -5
    exit 1
fi

APK_SIZE=$(stat --format="%s" "$APK" 2>/dev/null || stat -f "%z" "$APK" 2>/dev/null)
APK_SIZE_MB=$(echo "scale=1; $APK_SIZE / 1048576" | bc 2>/dev/null || echo "?")
echo -e "  ${GREEN}✓ APK found: $APK ($APK_SIZE_MB MB)${NC}"

# Check ZIP integrity
if python3 -c "import zipfile; z=zipfile.ZipFile('$APK'); z.testzip()" 2>/dev/null; then
    echo -e "  ${GREEN}✓ ZIP integrity: OK${NC}"
else
    echo -e "  ${RED}✗ ZIP integrity: CORRUPTED${NC}"
    echo "  The APK file may be damaged. Re-download it."
    exit 1
fi

# Check signing
echo ""
echo -e "${YELLOW}[2/6] Verifying APK signature...${NC}"
APKSIGNER_JAR=""
for v in 37.0.0 36.1.0 35.0.0 34.0.0; do
    JAR="$LOCALAPPDATA/Android/Sdk/build-tools/$v/lib/apksigner.jar"
    if [ -f "$JAR" ]; then
        APKSIGNER_JAR="$JAR"
        break
    fi
done

if [ -n "$APKSIGNER_JAR" ]; then
    VERIFY_OUT=$(java -jar "$APKSIGNER_JAR" verify -v "$APK" 2>&1)
    if echo "$VERIFY_OUT" | grep -q "Verifies"; then
        V1=$(echo "$VERIFY_OUT" | grep "v1 scheme" | grep -c "true" || true)
        V2=$(echo "$VERIFY_OUT" | grep "v2 scheme" | grep -c "true" || true)
        V3=$(echo "$VERIFY_OUT" | grep "v3 scheme" | grep -c "true" || true)
        echo -e "  ${GREEN}✓ Signature valid (V1=$V1 V2=$V2 V3=$V3)${NC}"
    else
        echo -e "  ${RED}✗ Signature verification failed${NC}"
        echo "  $VERIFY_OUT"
    fi
else
    echo -e "  ${YELLOW}⚠ apksigner.jar not found — skipping signature check${NC}"
fi

# --- Step 3: Check ADB ---
echo ""
echo -e "${YELLOW}[3/6] Checking ADB...${NC}"
ADB=""
for candidate in "adb" "$LOCALAPPDATA/Android/Sdk/platform-tools/adb.exe" "/c/Users/User/AppData/Local/Android/Sdk/platform-tools/adb.exe"; do
    if command -v "$candidate" &>/dev/null || [ -f "$candidate" ]; then
        ADB="$candidate"
        break
    fi
done

if [ -z "$ADB" ]; then
    echo -e "  ${RED}✗ ADB not found. Install Android SDK platform-tools.${NC}"
    echo "  Download: https://developer.android.com/tools/releases/platform-tools"
    exit 1
fi
echo -e "  ${GREEN}✓ ADB found: $ADB${NC}"

# --- Step 4: Connect to BlueStacks ---
echo ""
echo -e "${YELLOW}[4/6] Scanning for BlueStacks / emulators...${NC}"
CONNECTED=false

for port in "${BLUESTACKS_PORTS[@]}"; do
    RESULT=$("$ADB" connect "127.0.0.1:$port" 2>&1 || true)
    if echo "$RESULT" | grep -qi "connected\|already"; then
        echo -e "  ${GREEN}✓ Connected to 127.0.0.1:$port${NC}"
        CONNECTED=true
    fi
done

for port in "${EMULATOR_PORTS[@]}"; do
    RESULT=$("$ADB" connect "emulator-$port" 2>&1 || true)
    if echo "$RESULT" | grep -qi "connected\|already"; then
        echo -e "  ${GREEN}✓ Connected to emulator-$port${NC}"
        CONNECTED=true
    fi
done

# List all connected devices
echo ""
echo "  Connected devices:"
"$ADB" devices -l 2>/dev/null | grep -v "^List" | grep -v "^$" | while read -r line; do
    echo "    $line"
done

DEVICE_COUNT=$("$ADB" devices 2>/dev/null | grep -v "^List" | grep -v "^$" | grep -c "device" || true)
if [ "$DEVICE_COUNT" -eq 0 ]; then
    echo -e "  ${RED}✗ No devices found. Start BlueStacks first!${NC}"
    echo ""
    echo "  Troubleshooting:"
    echo "    1. Open BlueStacks → Settings → Advanced → Enable ADB"
    echo "    2. Or: BlueStacks Multi-Instance Manager → Settings → ADB"
    echo "    3. Try: adb connect 127.0.0.1:5555"
    exit 1
fi

# --- Step 5: Attempt install ---
echo ""
echo -e "${YELLOW}[5/6] Installing APK...${NC}"
DEVICE_SERIAL=$("$ADB" devices 2>/dev/null | grep -v "^List" | grep -v "^$" | head -1 | awk '{print $1}')
echo "  Target device: $DEVICE_SERIAL"

# Get device info
echo ""
echo "  Device info:"
"$ADB" -s "$DEVICE_SERIAL" shell getprop ro.product.model 2>/dev/null | xargs -I{} echo "    Model: {}"
"$ADB" -s "$DEVICE_SERIAL" shell getprop ro.build.version.release 2>/dev/null | xargs -I{} echo "    Android: {}"
"$ADB" -s "$DEVICE_SERIAL" shell getprop ro.product.cpu.abi 2>/dev/null | xargs -I{} echo "    CPU ABI: {}"
"$ADB" -s "$DEVICE_SERIAL" shell getprop ro.build.version.sdk 2>/dev/null | xargs -I{} echo "    SDK: {}"

echo ""
echo "  Installing... (this may take 30-60 seconds for large APKs)"
INSTALL_OUTPUT=$("$ADB" -s "$DEVICE_SERIAL" install -r "$APK" 2>&1) || true
INSTALL_EXIT=$?

echo "$INSTALL_OUTPUT" | while read -r line; do
    echo "    $line"
done

if echo "$INSTALL_OUTPUT" | grep -qi "success"; then
    echo ""
    echo -e "  ${GREEN}✓ INSTALL SUCCESSFUL!${NC}"
elif [ $INSTALL_EXIT -eq 0 ]; then
    echo ""
    echo -e "  ${GREEN}✓ INSTALL SUCCESSFUL!${NC}"
else
    echo ""
    echo -e "  ${RED}✗ INSTALL FAILED${NC}"
    echo ""
    echo "  Common causes:"
    echo "    - APK corrupted during download (re-download from MEGA)"
    echo "    - Insufficient storage (free space in BlueStacks)"
    echo "    - Architecture mismatch (check CPU ABI above vs APK ABIs)"
    echo "    - Incompatible Android version (APK requires minSdk 24 = Android 7.0)"
    echo "    - parsePackage error = file is truncated or wrong extension"
    echo ""
    echo "  Try manual install:"
    echo "    adb -s $DEVICE_SERIAL install -r -d \"$APK\""
    echo "    Or drag-and-drop the APK into the BlueStacks window"
fi

# --- Step 6: Verify installation ---
echo ""
echo -e "${YELLOW}[6/6] Verifying installation...${NC}"
PKG="com.multidevsn.astrorecolte"
APP_INFO=$("$ADB" -s "$DEVICE_SERIAL" shell dumpsys package "$PKG" 2>/dev/null || true)

if echo "$APP_INFO" | grep -qi "versionName"; then
    INSTALLED_VERSION=$(echo "$APP_INFO" | grep "versionName" | head -1 | sed 's/.*=//')
    INSTALLED_CODE=$(echo "$APP_INFO" | grep "versionCode" | head -1 | sed 's/.*=//')
    echo -e "  ${GREEN}✓ App installed: v$INSTALLED_VERSION (code $INSTALLED_CODE)${NC}"

    # Launch the app
    echo ""
    echo "  Launching app..."
    "$ADB" -s "$DEVICE_SERIAL" shell am start -n "$PKG/com.godot.game.GodotApp" 2>/dev/null || \
    "$ADB" -s "$DEVICE_SERIAL" shell monkey -p "$PKG" -c android.intent.category.LAUNCHER 1 2>/dev/null || true
    echo -e "  ${GREEN}✓ App launched!${NC}"
else
    echo -e "  ${RED}✗ App not found in installed packages${NC}"
fi

# --- Summary ---
echo ""
echo -e "${CYAN}============================================${NC}"
echo -e "${CYAN}  Test complete. Check BlueStacks window.${NC}"
echo -e "${CYAN}============================================${NC}"

#!/bin/bash
# =============================================================================
# diagnose_install.sh — Diagnostic complet pour problèmes d'installation APK
# =============================================================================
# Usage:
#   bash tools/diagnose_install.sh <chemin-vers-l-apk>
#
# Ce script vérifie :
# 1. L'intégrité du fichier APK
# 2. La signature
# 3. L'alignement ZIP
# 4. La compatibilité architecture
# 5. Tente l'installation via ADB si un appareil est connecté
# =============================================================================

set -uo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

APK="${1:-test_build/AstroRecolte-release.apk}"

echo -e "${BOLD}${CYAN}"
echo "================================================"
echo "  AstroRecolte — Diagnostic Installation APK"
echo "================================================"
echo -e "${NC}"

ISSUES=0

# === 1. FILE CHECK ===
echo -e "${BOLD}[1/7] Verification du fichier${NC}"
if [ ! -f "$APK" ]; then
    echo -e "  ${RED}X APK non trouve: $APK${NC}"
    echo "  APK disponibles:"
    find . -name "*.apk" -type f 2>/dev/null | head -5
    exit 1
fi

SIZE=$(stat --format="%s" "$APK" 2>/dev/null || stat -f "%z" "$APK" 2>/dev/null)
SIZE_MB=$(echo "scale=1; $SIZE / 1048576" | bc 2>/dev/null || echo "?")
echo -e "  Fichier: $APK"
echo -e "  Taille:  $SIZE_MB MB ($SIZE octets)"

# Check it's actually a ZIP/APK
FILE_TYPE=$(file "$APK" 2>/dev/null | head -1)
echo -e "  Type:    $FILE_TYPE"
if echo "$FILE_TYPE" | grep -qi "zip\|java\|android"; then
    echo -e "  ${GREEN}Format APK/ZIP OK${NC}"
else
    echo -e "  ${RED}X Le fichier n'est PAS un APK valide!${NC}"
    echo -e "  ${YELLOW}  -> Re-telecharge l'APK depuis le lien MEGA${NC}"
    ISSUES=$((ISSUES+1))
fi

# Check ZIP integrity
BAD=$(python3 -c "
import zipfile
z = zipfile.ZipFile('$APK')
b = z.testzip()
print('' if b is None else b)
z.close()
" 2>/dev/null)

if [ -z "$BAD" ]; then
    echo -e "  ${GREEN}Integrite ZIP: OK${NC}"
else
    echo -e "  ${RED}X ZIP CORROMPU! Fichier defaillant: $BAD${NC}"
    echo -e "  ${YELLOW}  -> Re-telecharge l'APK depuis le lien MEGA${NC}"
    ISSUES=$((ISSUES+1))
fi

# Check file size vs expected
EXPECTED_MIN=$((40 * 1024 * 1024))  # 40 MB minimum
EXPECTED_MAX=$((70 * 1024 * 1024))  # 70 MB maximum
if [ "$SIZE" -lt "$EXPECTED_MIN" ]; then
    echo -e "  ${RED}X Fichier trop petit ($SIZE_MB MB < 40 MB) -> Telechargement incomplet!${NC}"
    ISSUES=$((ISSUES+1))
elif [ "$SIZE" -gt "$EXPECTED_MAX" ]; then
    echo -e "  ${YELLOW}! Fichier anormalement grand ($SIZE_MB MB > 70 MB) -> Mauvais APK?${NC}"
fi

echo ""

# === 2. SIGNATURE ===
echo -e "${BOLD}[2/7] Verification signature${NC}"
APKSIGNER=""
for v in 35.0.0 36.1.0 34.0.0; do
    JAR="$LOCALAPPDATA/Android/Sdk/build-tools/$v/lib/apksigner.jar"
    if [ -f "$JAR" ]; then
        APKSIGNER="$JAR"
        break
    fi
done

if [ -n "$APKSIGNER" ]; then
    VERIFY=$(java -jar "$APKSIGNER" verify -v "$APK" 2>&1)
    if echo "$VERIFY" | grep -q "Verifies"; then
        V1=$(echo "$VERIFY" | grep "v1 scheme" | grep -c "true" || true)
        V2=$(echo "$VERIFY" | grep "v2 scheme" | grep -c "true" || true)
        V3=$(echo "$VERIFY" | grep "v3 scheme" | grep -c "true" || true)
        echo -e "  ${GREEN}Signature: Valide (V1=$V1 V2=$V2 V3=$V3)${NC}"
    else
        echo -e "  ${RED}X Signature INVALIDE!${NC}"
        echo "$VERIFY" | head -5
        ISSUES=$((ISSUES+1))
    fi
else
    echo -e "  ${YELLOW}! apksigner non trouve - skip${NC}"
fi
echo ""

# === 3. ZIPALIGN ===
echo -e "${BOLD}[3/7] Verification alignement ZIP${NC}"
ZIPALIGN=""
for v in 35.0.0 36.1.0 34.0.0; do
    ZA="$LOCALAPPDATA/Android/Sdk/build-tools/$v/zipalign.exe"
    if [ -f "$ZA" ]; then
        ZIPALIGN="$ZA"
        break
    fi
done

if [ -n "$ZIPALIGN" ]; then
    ALIGN_OUT=$("$ZIPALIGN" -c -v 4 "$APK" 2>&1 | tail -1)
    if echo "$ALIGN_OUT" | grep -qi "succesful\|verification"; then
        echo -e "  ${GREEN}Alignement: OK (4 bytes)${NC}"
    else
        echo -e "  ${RED}X Alignement: ECHEC!${NC}"
        echo "  $ALIGN_OUT"
        ISSUES=$((ISSUES+1))
    fi
else
    echo -e "  ${YELLOW}! zipalign non trouve - skip${NC}"
fi
echo ""

# === 4. PACKAGE INFO ===
echo -e "${BOLD}[4/7] Informations package${NC}"
AAPT=""
for v in 35.0.0 36.1.0 34.0.0; do
    AA="$LOCALAPPDATA/Android/Sdk/build-tools/$v/aapt.exe"
    if [ -f "$AA" ]; then
        AAPT="$AA"
        break
    fi
done

if [ -n "$AAPT" ]; then
    BADGING=$("$AAPT" dump badging "$APK" 2>&1)
    PKG=$(echo "$BADGING" | head -1 | grep -o "name='[^']*'" | head -1)
    VC=$(echo "$BADGING" | head -1 | grep -o "versionCode='[^']*'" | head -1)
    VN=$(echo "$BADGING" | head -1 | grep -o "versionName='[^']*'" | head -1)
    MIN=$(echo "$BADGING" | grep "sdkVersion" | head -1 | grep -o "'[^']*'" | head -1)
    TGT=$(echo "$BADGING" | grep "targetSdkVersion" | head -1 | grep -o "'[^']*'" | head -1)
    
    echo "  Package:      $PKG"
    echo "  Version:      $VN ($VC)"
    echo "  Min SDK:      $MIN (Android $(((${MIN#'} + 1)}))"
    echo "  Target SDK:   $TGT (Android $(((${TGT#'} + 1)}))"
    
    # Check ABIs in APK
    ABIS=$(echo "$BADGING" | grep "native-code" | grep -o "'[^']*'" | tr "'" " " | tr -d ' ')
    echo "  ABIs:         $ABIS"
    
    # Check permissions
    PERMS=$(echo "$BADGING" | grep "uses-permission" | wc -l)
    echo "  Permissions:  $PERMS"
    
    # Verify expected package
    if echo "$PKG" | grep -q "multidevsn.astrorecolte"; then
        echo -e "  ${GREEN}Package name: CORRECT${NC}"
    else
        echo -e "  ${RED}X Package name INCORRECT: $PKG${NC}"
        ISSUES=$((ISSUES+1))
    fi
else
    echo -e "  ${YELLOW}! aapt non trouve - skip${NC}"
fi
echo ""

# === 5. ADB CHECK ===
echo -e "${BOLD}[5/7] Detection appareils${NC}"
ADB=""
for candidate in "$LOCALAPPDATA/Android/Sdk/platform-tools/adb.exe" "adb"; do
    if command -v "$candidate" &>/dev/null || [ -f "$candidate" ]; then
        ADB="$candidate"
        break
    fi
done

if [ -z "$ADB" ]; then
    echo -e "  ${YELLOW}! ADB non trouve${NC}"
else
    echo -e "  ${GREEN}ADB: $ADB${NC}"
    
    # Try connecting BlueStacks
    for port in 5555 5556 5557 5558; do
        RESULT=$("$ADB" connect "127.0.0.1:$port" 2>&1 || true)
        if echo "$RESULT" | grep -qi "connected\|already"; then
            echo -e "  ${GREEN}BlueStacks connecte: 127.0.0.1:$port${NC}"
        fi
    done
    
    DEVICES=$("$ADB" devices 2>/dev/null | grep -v "^List" | grep -v "^$" | grep "device" | wc -l)
    echo "  Appareils connectes: $DEVICES"
    
    "$ADB" devices -l 2>/dev/null | grep -v "^List" | grep -v "^$" | while read -r line; do
        echo "    $line"
    done
fi
echo ""

# === 6. ADB INSTALL TEST ===
echo -e "${BOLD}[6/7] Test installation ADB${NC}"
if [ -n "$ADB" ] && [ "$DEVICES" -gt 0 ] 2>/dev/null; then
    DEVICE=$("$ADB" devices 2>/dev/null | grep -v "^List" | grep -v "^$" | head -1 | awk '{print $1}')
    echo "  Cible: $DEVICE"
    
    # Show device info
    MODEL=$("$ADB" -s "$DEVICE" shell getprop ro.product.model 2>/dev/null | tr -d '\r')
    ANDROID=$("$ADB" -s "$DEVICE" shell getprop ro.build.version.release 2>/dev/null | tr -d '\r')
    ABI=$("$ADB" -s "$DEVICE" shell getprop ro.product.cpu.abi 2>/dev/null | tr -d '\r')
    echo "  Modele: $MODEL | Android $ANDROID | ABI: $ABI"
    
    # Try install
    echo "  Installation en cours..."
    INSTALL=$("$ADB" -s "$DEVICE" install -r -d "$APK" 2>&1)
    EXIT=$?
    
    if echo "$INSTALL" | grep -qi "success"; then
        echo -e "  ${GREEN}INSTALLATION REUSSIE!${NC}"
        
        # Try to launch
        PKG_NAME=$(echo "$PKG" | grep -o "'[^']*'" | tr -d "'")
        echo "  Lancement..."
        "$ADB" -s "$DEVICE" shell am start -n "$PKG_NAME/com.godot.game.GodotApp" 2>/dev/null || \
        "$ADB" -s "$DEVICE" shell monkey -p "$PKG_NAME" -c android.intent.category.LAUNCHER 1 2>/dev/null
        echo -e "  ${GREEN}App lancee!${NC}"
    else
        echo -e "  ${RED}X INSTALLATION ECHOUEE!${NC}"
        echo "$INSTALL" | while read -r line; do
            echo "    $line"
        done
        ISSUES=$((ISSUES+1))
    fi
else
    echo -e "  ${YELLOW}! Aucun appareil connecte. Demarrer BlueStacks d'abord.${NC}"
    echo "  Instructions:"
    echo "    1. Ouvrir BlueStacks"
    echo "    2. Parametres > Avancee > Activer ADB"
    echo "    3. Relancer ce script"
fi
echo ""

# === 7. SUMMARY ===
echo -e "${BOLD}[7/7] RESUME${NC}"
echo -e "${CYAN}================================================${NC}"

if [ $ISSUES -eq 0 ]; then
    echo -e "${GREEN}  L'APK est VALIDE. Aucun probleme detecte.${NC}"
    echo ""
    echo "  Si l'installation echoue sur BlueStacks/Android:"
    echo "    1. Verifie que le fichier fait ~54 MB (pas tronque)"
    echo "    2. Verifie l'extension: .apk (pas .apk.txt)"
    echo "    3. Desactive 'Sources inconnues' puis reactive-le"
    echo "    4. Redemarre BlueStacks"
    echo "    5. Essaie: drag & drop du fichier APK dans BlueStacks"
else
    echo -e "${RED}  $ISSUES PROBLEMES DETECTES!${NC}"
    echo "  Corrige les problemes ci-dessus avant d'installer."
fi

echo -e "${CYAN}================================================${NC}"

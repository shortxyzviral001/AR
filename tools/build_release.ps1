# build_release.ps1 — Build AstroRecolte APK with correct signing
# Usage: powershell -File tools/build_release.ps1

$ErrorActionPreference = "Stop"
$ProjectRoot = Split-Path -Parent $PSCommandPath | Split-Path -Parent
$Godot = "C:\Program Files\Godot\Godot_v4.7-stable_win64.exe"
$Apksigner = "$env:LOCALAPPDATA\Android\Sdk\build-tools\34.0.0\lib\apksigner.jar"
$Zipalign = "$env:LOCALAPPDATA\Android\Sdk\build-tools\34.0.0\zipalign.exe"
$GodotKeystore = "$env:APPDATA\Godot\keystores\debug.keystore"
$OutputDir = "$ProjectRoot\test_build"

Write-Host "=== AstroRecolte Build ===" -ForegroundColor Cyan

# 1. Force recompile scripts
Write-Host "[1/5] Recompiling scripts..." -ForegroundColor Yellow
Get-ChildItem "$ProjectRoot\scripts\*.gd" | ForEach-Object { $_.LastWriteTime = Get-Date }

# 2. Export release APK (Godot signs with AstroRecolte key)
Write-Host "[2/5] Exporting release APK..." -ForegroundColor Yellow
$RawApk = "$OutputDir\AstroRecolte-raw.apk"
Remove-Item $RawApk -ErrorAction SilentlyContinue
& "$Godot" --headless --path $ProjectRoot --export-release "Android" $RawApk
if ($LASTEXITCODE -ne 0) { throw "Godot export failed" }

# 3. Zipalign
Write-Host "[3/5] Zipaligning..." -ForegroundColor Yellow
$AlignedApk = "$OutputDir\AstroRecolte-aligned.apk"
& $Zipalign -f 4 $RawApk $AlignedApk
if ($LASTEXITCODE -ne 0) { throw "Zipalign failed" }

# 4. Re-sign with Godot debug keystore (matches old installs)
Write-Host "[4/5] Re-signing with Godot keystore..." -ForegroundColor Yellow
$FinalApk = "$OutputDir\AstroRecolte-final.apk"
Remove-Item $FinalApk -ErrorAction SilentlyContinue
java -jar $Apksigner sign --ks $GodotKeystore --ks-pass pass:android --ks-key-alias androiddebugkey --v2-signing-enabled true --out $FinalApk $AlignedApk
if ($LASTEXITCODE -ne 0) { throw "Signing failed" }

# 5. Verify
Write-Host "[5/5] Verifying..." -ForegroundColor Yellow
java -jar $Apksigner verify --print-certs $FinalApk | Select-Object -First 4
java -jar $Apksigner verify -v $FinalApk | Select-String -Pattern "v1|v2|v3|verified"

$Size = [math]::Round((Get-Item $FinalApk).Length / 1MB, 1)
Write-Host "`n=== DONE: $FinalApk ($Size MB) ===" -ForegroundColor Green

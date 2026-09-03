#!/usr/bin/env pwsh
# ============================================================
# install_apk.ps1 — Diagnostic + Uninstall + Install APK
# Usage: .\tools\install_apk.ps1 [path-to.apk]
# ============================================================
param(
    [string]$ApkPath = "test_build\AstroRecolte-release.apk"
)

$ADB = "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe"
$PKG = "com.multidevsn.astrorecolte"
$BS_PORTS = @(5555, 5556, 5557, 5558)

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  AstroRecolte APK Installer & Diagnostic" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# --- Step 1: Verify APK exists and is valid ---
Write-Host "[1/6] Verification de l'APK..." -ForegroundColor Yellow
if (-not (Test-Path $ApkPath)) {
    Write-Host "  ERREUR: Fichier non trouvé: $ApkPath" -ForegroundColor Red
    exit 1
}
$fileSize = (Get-Item $ApkPath).Length
$fileSizeMB = [math]::Round($fileSize / 1MB, 1)
Write-Host "  Fichier: $ApkPath ($fileSizeMB MB)"

if ($fileSize -lt 1MB) {
    Write-Host "  ERREUR: Fichier trop petit ($fileSizeMB MB) - probablement corrompu" -ForegroundColor Red
    exit 1
}

# Check ZIP integrity
try {
    $zip = [System.IO.Compression.ZipFile]::OpenRead((Resolve-Path $ApkPath))
    $entryCount = $zip.Entries.Count
    $zip.Dispose()
    Write-Host "  ZIP integrity: OK ($entryCount entrées)" -ForegroundColor Green
} catch {
    Write-Host "  ERREUR: Fichier ZIP corrompu!" -ForegroundColor Red
    exit 1
}

# --- Step 2: Check ADB ---
Write-Host ""
Write-Host "[2/6] Vérification d'ADB..." -ForegroundColor Yellow
if (-not (Test-Path $ADB)) {
    Write-Host "  ERREUR: ADB non trouvé à $ADB" -ForegroundColor Red
    Write-Host "  Installe Android SDK Platform Tools" -ForegroundColor Gray
    exit 1
}
$adbVersion = & $ADB version 2>&1 | Select-Object -First 1
Write-Host "  ADB: $adbVersion" -ForegroundColor Green

# --- Step 3: Find connected devices ---
Write-Host ""
Write-Host "[3/6] Recherche d'appareils..." -ForegroundColor Yellow

# Try BlueStacks
$bsRunning = Get-Process -Name "HD-Player" -ErrorAction SilentlyContinue
if ($bsRunning) {
    Write-Host "  BlueStacks détecté! Tentative de connexion..." -ForegroundColor Cyan
    foreach ($port in $BS_PORTS) {
        & $ADB connect "127.0.0.1:$port" 2>&1 | Out-Null
    }
}

# List devices
$devices = & $ADB devices 2>&1
$deviceLines = $devices | Where-Object { $_ -match "^\S+\s+(device|emulator)" }
$deviceCount = ($deviceLines | Measure-Object).Count

if ($deviceCount -eq 0) {
    Write-Host "  Aucun appareil détecté!" -ForegroundColor Red
    Write-Host ""
    Write-Host "  Solutions:" -ForegroundColor Yellow
    Write-Host "  - BlueStacks: Ouvre BlueStacks, puis réessaie" -ForegroundColor Gray
    Write-Host "  - Téléphone: Active Mode Développeur + USB Debugging" -ForegroundColor Gray
    Write-Host "  - Puis branche le câble USB" -ForegroundColor Gray
    exit 1
}

Write-Host "  Appareils trouvés:" -ForegroundColor Green
$devices | Where-Object { $_ -notmatch "^List" -and $_ -ne "" } | ForEach-Object {
    Write-Host "    $_"
}

# Get first device serial
$firstDevice = ($deviceLines -split "`t")[0]
Write-Host "  Utilisation: $firstDevice" -ForegroundColor Cyan

# --- Step 4: Check existing installation ---
Write-Host ""
Write-Host "[4/6] Vérification de l'installation existante..." -ForegroundColor Yellow
$existing = & $ADB -s $firstDevice shell "pm path $PKG" 2>&1
if ($existing -match "package:") {
    Write-Host "  Une ancienne version est installée!" -ForegroundColor Yellow
    Write-Host "  $existing"
    
    # Get installed version info
    $versionInfo = & $ADB -s $firstDevice shell "dumpsys package $PKG" 2>&1 | Select-String "versionCode|versionName|signatures|Signature"
    if ($versionInfo) {
        Write-Host "  Infos version installée:" -ForegroundColor Gray
        $versionInfo | Select-Object -First 5 | ForEach-Object {
            Write-Host "    $_" -ForegroundColor Gray
        }
    }
    
    # Check if signature mismatch
    Write-Host ""
    Write-Host "  Tentative de désinstallation..." -ForegroundColor Yellow
    & $ADB -s $firstDevice uninstall $PKG 2>&1
    $uninstallResult = $LASTEXITCODE
    
    if ($uninstallResult -ne 0) {
        Write-Host "  Désinstallation échouée (code: $uninstallResult)" -ForegroundColor Red
        Write-Host "  Essai avec --user 0..." -ForegroundColor Yellow
        & $ADB -s $firstDevice shell "pm uninstall --user 0 $PKG" 2>&1
    }
    
    # Verify uninstalled
    Start-Sleep -Seconds 2
    $checkUninstall = & $ADB -s $firstDevice shell "pm path $PKG" 2>&1
    if ($checkUninstall -match "package:") {
        Write-Host "  AVERTISSEMENT: L'app est toujours installée!" -ForegroundColor Red
        Write-Host "  Désinstalle MANUELLEMENT l'app sur l'appareil, puis réessaie." -ForegroundColor Red
        exit 1
    } else {
        Write-Host "  Ancienne version désinstallée!" -ForegroundColor Green
    }
} else {
    Write-Host "  Aucune version existante (installation propre)" -ForegroundColor Green
}

# --- Step 5: Install ---
Write-Host ""
Write-Host "[5/6] Installation de l'APK..." -ForegroundColor Yellow
Write-Host "  Fichier: $ApkPath ($fileSizeMB MB)"
Write-Host "  Cela peut prendre 1-2 minutes..."

$installStart = Get-Date
& $ADB -s $firstDevice install -r $ApkPath 2>&1
$installExit = $LASTEXITCODE
$installDuration = (Get-Date) - $installStart

if ($installExit -eq 0) {
    Write-Host ""
    Write-Host "  Installation RÉUSSIE en $($installDuration.TotalSeconds.ToString('F1'))s!" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "  Installation ÉCHOUÉE (code: $installExit)" -ForegroundColor Red
    Write-Host ""
    Write-Host "  Causes possibles:" -ForegroundColor Yellow
    Write-Host "  1. Le fichier APK est corrompu (re-télécharge depuis MEGA)" -ForegroundColor Gray
    Write-Host "  2. Espace disque insuffisant sur l'appareil" -ForegroundColor Gray
    Write-Host "  3. Conflit de signature (désinstalle l'ancienne app d'abord)" -ForegroundColor Gray
    Write-Host "  4. Version Android trop ancienne (minimum: Android 7.0)" -ForegroundColor Gray
    exit 1
}

# --- Step 6: Launch ---
Write-Host ""
Write-Host "[6/6] Lancement de l'app..." -ForegroundColor Yellow
& $ADB -s $firstDevice shell "am start -n $PKG/com.godot.game.GodotApp" 2>&1 | Out-Null

Start-Sleep -Seconds 3
$running = & $ADB -s $firstDevice shell "pidof $PKG" 2>&1
if ($running -match "\d+") {
    Write-Host "  App lancée! PID: $running" -ForegroundColor Green
} else {
    Write-Host "  L'app a démarré mais le PID n'est pas encore visible" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host "  TERMINÉ! L'APK a été installé avec succès" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green

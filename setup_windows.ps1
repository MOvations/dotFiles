#!/usr/bin/env pwsh
#Requires -Version 7.0

<#
.SYNOPSIS
    Windows development environment setup script for dotfiles.
.DESCRIPTION
    Sets up PowerShell profile, Miniconda, Starship prompt, and aliases.
    Works on both Windows ARM64 and x86_64 architectures.
.NOTES
    Run this script in PowerShell 7+ with: ./setup_windows.ps1
#>

param(
    [switch]$SkipMiniconda,
    [switch]$SkipStarship,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

# Colors for output
function Write-Step { param($msg) Write-Host "`n>>> $msg" -ForegroundColor Cyan }
function Write-Success { param($msg) Write-Host "[OK] $msg" -ForegroundColor Green }
function Write-Warning { param($msg) Write-Host "[WARN] $msg" -ForegroundColor Yellow }
function Write-Info { param($msg) Write-Host "[INFO] $msg" -ForegroundColor Gray }

Write-Host @"

===============================================
   Windows Development Environment Setup
   From: github.com/MOvations/dotfiles
===============================================

"@ -ForegroundColor Magenta

##### Detect Architecture #####
Write-Step "Detecting system architecture"
$arch = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture
Write-Info "Architecture: $arch"

switch ($arch) {
    "Arm64" {
        # Note: Miniconda doesn't have native ARM64 Windows builds yet
        # Using x64 version which runs via Windows x64 emulation
        $minicondaUrl = "https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe"
        $archName = "ARM64 (using x64 emulation)"
    }
    "X64" {
        $minicondaUrl = "https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe"
        $archName = "x86_64"
    }
    "X86" {
        $minicondaUrl = "https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86.exe"
        $archName = "x86"
    }
    default {
        Write-Error "Unsupported architecture: $arch"
        exit 1
    }
}
Write-Success "Detected $archName architecture"

##### Get script directory (dotfiles root) #####
$dotfilesRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
Write-Info "Dotfiles root: $dotfilesRoot"

##### Install Starship #####
if (-not $SkipStarship) {
    Write-Step "Installing Starship prompt"

    $starshipInstalled = Get-Command starship -ErrorAction SilentlyContinue
    if ($starshipInstalled -and -not $Force) {
        Write-Warning "Starship already installed, skipping (use -Force to reinstall)"
    } else {
        try {
            winget install --id Starship.Starship --accept-package-agreements --accept-source-agreements
            Write-Success "Starship installed"
        } catch {
            Write-Warning "winget install failed, trying direct download..."
            Invoke-WebRequest -Uri "https://starship.rs/install.ps1" -OutFile "$env:TEMP\install-starship.ps1"
            & "$env:TEMP\install-starship.ps1" -Force
        }
    }

    # Copy starship config
    $starshipConfigDir = "$env:USERPROFILE\.config"
    if (-not (Test-Path $starshipConfigDir)) {
        New-Item -ItemType Directory -Path $starshipConfigDir -Force | Out-Null
    }

    $starshipConfigSrc = Join-Path $dotfilesRoot "files\starship.toml"
    if (Test-Path $starshipConfigSrc) {
        Copy-Item $starshipConfigSrc "$starshipConfigDir\starship.toml" -Force
        Write-Success "Starship config copied to $starshipConfigDir\starship.toml"
    } else {
        Write-Warning "starship.toml not found in dotfiles/files/, skipping config copy"
    }
}

##### Install Miniconda #####
$condaPath = "$env:USERPROFILE\miniconda3"
$condaExe = "$condaPath\Scripts\conda.exe"

if (-not $SkipMiniconda) {
    Write-Step "Installing Miniconda ($archName)"

    if ((Test-Path $condaExe) -and -not $Force) {
        Write-Warning "Miniconda already installed at $condaPath, skipping (use -Force to reinstall)"
    } else {
        $installerPath = "$env:TEMP\Miniconda3-latest.exe"

        Write-Info "Downloading Miniconda from $minicondaUrl"
        Invoke-WebRequest -Uri $minicondaUrl -OutFile $installerPath -UseBasicParsing

        Write-Info "Installing Miniconda to $condaPath (this may take a few minutes)..."
        Start-Process -FilePath $installerPath -ArgumentList @(
            "/InstallationType=JustMe",
            "/RegisterPython=0",
            "/AddToPath=0",
            "/S",
            "/D=$condaPath"
        ) -Wait -NoNewWindow

        Remove-Item $installerPath -Force -ErrorAction SilentlyContinue
        Write-Success "Miniconda installed to $condaPath"
    }

    # Initialize conda
    if (Test-Path $condaExe) {
        Write-Info "Initializing conda for PowerShell..."
        & $condaExe init powershell | Out-Null
        Write-Success "Conda initialized"
    }
}

##### Setup PowerShell Profile #####
Write-Step "Setting up PowerShell profile"

$profileDir = Split-Path -Parent $PROFILE
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
    Write-Info "Created profile directory: $profileDir"
}

# Copy the profile template
$profileSrc = Join-Path $dotfilesRoot "files\Microsoft.PowerShell_profile.ps1"
if (Test-Path $profileSrc) {
    Copy-Item $profileSrc $PROFILE -Force
    Write-Success "PowerShell profile installed to $PROFILE"
} else {
    Write-Warning "Profile template not found at $profileSrc"
}

##### Create scripts directory #####
Write-Step "Setting up scripts directory"
$scriptsDir = "$env:USERPROFILE\.scripts"
if (-not (Test-Path $scriptsDir)) {
    New-Item -ItemType Directory -Path $scriptsDir -Force | Out-Null
}

# Copy Windows-compatible scripts
$scriptsToCopy = @("myAliases.ps1")
foreach ($script in $scriptsToCopy) {
    $scriptSrc = Join-Path $dotfilesRoot "scripts\$script"
    if (Test-Path $scriptSrc) {
        Copy-Item $scriptSrc $scriptsDir -Force
        Write-Info "Copied $script to $scriptsDir"
    }
}
Write-Success "Scripts directory configured"

##### Summary #####
Write-Host @"

===============================================
   Setup Complete!
===============================================

"@ -ForegroundColor Green

Write-Host "Installed components:" -ForegroundColor Cyan
if (-not $SkipStarship) { Write-Host "  - Starship prompt" }
if (-not $SkipMiniconda) { Write-Host "  - Miniconda ($archName)" }
Write-Host "  - PowerShell profile with aliases"
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Restart your terminal or run: . `$PROFILE"
Write-Host "  2. (Optional) Create conda environment: conda env create -f conda_envs/py39.yml"
Write-Host ""
Write-Host "Your aliases are ready: gs, gc, gp, gl, ll, mk, wttr, etc."
Write-Host ""

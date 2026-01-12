#!/usr/bin/env pwsh
#Requires -Version 7.0

<#
.SYNOPSIS
    Windows development environment setup script for dotfiles.
.DESCRIPTION
    Sets up PowerShell profile, uv (Python manager), Starship prompt, and aliases.
    Works on both Windows ARM64 and x86_64 architectures.
.NOTES
    Run this script in PowerShell 7+ with: ./setup_windows.ps1
#>

param(
    [switch]$SkipUv,
    [switch]$SkipPython,
    [switch]$SkipStarship,
    [string]$PythonVersion = "3.12",
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
# uv handles architecture automatically - no special handling needed
Write-Success "Detected $arch architecture"

##### Get script directory (dotfiles root) #####
$dotfilesRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
Write-Info "Dotfiles root: $dotfilesRoot"

##### Install Fastfetch #####
Write-Step "Installing Fastfetch"
$fastfetchInstalled = Get-Command fastfetch -ErrorAction SilentlyContinue
if ($fastfetchInstalled -and -not $Force) {
    Write-Warning "Fastfetch already installed, skipping (use -Force to reinstall)"
} else {
    winget install --id Fastfetch-cli.Fastfetch --accept-package-agreements --accept-source-agreements
    Write-Success "Fastfetch installed"
}

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

##### Install uv (Python package manager) #####
if (-not $SkipUv) {
    Write-Step "Installing uv (fast Python package manager)"

    $uvInstalled = Get-Command uv -ErrorAction SilentlyContinue
    if ($uvInstalled -and -not $Force) {
        Write-Warning "uv already installed, skipping (use -Force to reinstall)"
    } else {
        try {
            winget install --id astral-sh.uv --accept-package-agreements --accept-source-agreements
            Write-Success "uv installed"
        } catch {
            Write-Warning "winget install failed, trying direct download..."
            Invoke-RestMethod https://astral.sh/uv/install.ps1 | Invoke-Expression
        }
    }

    # Refresh PATH to pick up uv
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

##### Install Python via uv #####
if (-not $SkipUv -and -not $SkipPython) {
    Write-Step "Installing Python $PythonVersion via uv"

    # Check if uv is available now
    $uvCmd = Get-Command uv -ErrorAction SilentlyContinue
    if ($uvCmd) {
        Write-Info "Installing Python $PythonVersion..."
        uv python install $PythonVersion
        Write-Success "Python $PythonVersion installed"

        # Show installed Python
        $pythonPath = uv python find $PythonVersion 2>$null
        if ($pythonPath) {
            Write-Info "Python location: $pythonPath"
        }
    } else {
        Write-Warning "uv not found in PATH. Restart terminal and run: uv python install $PythonVersion"
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
Write-Host "  - Fastfetch (system info on startup)"
if (-not $SkipStarship) { Write-Host "  - Starship prompt" }
if (-not $SkipUv) { Write-Host "  - uv (fast Python manager)" }
if (-not $SkipUv -and -not $SkipPython) { Write-Host "  - Python $PythonVersion" }
Write-Host "  - PowerShell profile with aliases"
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Restart your terminal or run: . `$PROFILE"
Write-Host "  2. Create a project with virtual env: uv init myproject && cd myproject && uv venv"
Write-Host "  3. Or add packages directly: uv pip install requests"
Write-Host ""
Write-Host "Quick commands:" -ForegroundColor Cyan
Write-Host "  uv venv          - Create .venv in current directory"
Write-Host "  act              - Activate .venv (alias)"
Write-Host "  uv pip install X - Install package (fast!)"
Write-Host "  uv python list   - Show available Python versions"
Write-Host ""
Write-Host "Your aliases are ready: gs, gc, gp, gl, ll, mk, wttr, etc."
Write-Host ""

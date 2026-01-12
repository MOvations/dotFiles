# PowerShell 7 Profile
# github.com/MOvations/dotfiles
# Ported from scripts/myAliases.sh

#region Conda Initialize
# !! Contents within this block are managed by 'conda init' !!
$condaPath = "$env:USERPROFILE\miniconda3"
if (Test-Path "$condaPath\Scripts\conda.exe") {
    (& "$condaPath\Scripts\conda.exe" "shell.powershell" "hook") | Out-String | ?{$_} | Invoke-Expression
}
#endregion

#region Starship Prompt
$starshipCmd = Get-Command starship -ErrorAction SilentlyContinue
if ($starshipCmd) {
    Invoke-Expression (&starship init powershell)
}
#endregion

#region Navigation Shortcuts
function .. { Set-Location .. }
function ... { Set-Location ../../../ }
function .... { Set-Location ../../../../ }
function .4 { Set-Location ../../../../ }
function .5 { Set-Location ../../../../.. }
#endregion

#region Directory Listing
function ll { Get-ChildItem -Force @args | Format-Table Mode, LastWriteTime, Length, Name -AutoSize }
function l. { Get-ChildItem -Force -Hidden @args }
function la { Get-ChildItem -Force @args }
#endregion

#region History
function hg {
    param([string]$Pattern)
    Get-History | Where-Object CommandLine -like "*$Pattern*"
}
#endregion

#region Git Aliases
function gs { git status }
function gc {
    param([Parameter(ValueFromRemainingArguments=$true)][string[]]$Message)
    git commit -am ($Message -join " ")
}
function gp { git pull --rebase }
function gps { git push }
function gl {
    git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit
}
function gd { git diff @args }
function gco { git checkout @args }
function gb { git branch @args }
#endregion

#region Utility Functions
# mkdir and cd into it
function mk {
    param([string]$Path)
    New-Item -ItemType Directory -Path $Path -Force | Out-Null
    Set-Location $Path
}

# which command
function which ($command) {
    Get-Command -Name $command -ErrorAction SilentlyContinue |
        Select-Object -ExpandProperty Source -ErrorAction SilentlyContinue
}

# touch - create or update file timestamp
function touch {
    param([string]$Path)
    if (Test-Path $Path) {
        (Get-Item $Path).LastWriteTime = Get-Date
    } else {
        New-Item -ItemType File -Path $Path | Out-Null
    }
}

# Launch HTTP server
function servr {
    param([int]$Port = 7200)
    python -m http.server --bind localhost $Port
}

# Weather
function wttr {
    param([string]$Location = "")
    (Invoke-WebRequest -Uri "https://wttr.in/$Location" -UserAgent "curl").Content
}

# Open explorer in current directory
function e. { explorer.exe . }

# Open VS Code in current directory
function c. { code . }

# Reload profile
function reload { . $PROFILE }

# Get public IP
function myip { (Invoke-WebRequest -Uri "https://ifconfig.me/ip").Content.Trim() }

# Quick edit profile
function editprofile { code $PROFILE }
#endregion

#region Conda Auto-Env (optional)
# Automatically activate conda environment when entering folder with environment.yml
function Invoke-CondaAutoEnv {
    if (Test-Path "environment.yml") {
        $envName = (Get-Content "environment.yml" -First 1) -replace "name:\s*", ""
        $currentEnv = $env:CONDA_DEFAULT_ENV
        if ($currentEnv -ne $envName) {
            conda activate $envName 2>$null
        }
    }
}

# Uncomment to enable conda auto-env on directory change:
# $ExecutionContext.SessionState.InvokeCommand.PreCommandAction = { Invoke-CondaAutoEnv }
#endregion

#region PSReadLine Configuration
if (Get-Module -ListAvailable -Name PSReadLine) {
    try {
        Set-PSReadLineOption -PredictionSource History
        Set-PSReadLineOption -PredictionViewStyle ListView
    } catch {
        # Prediction features require virtual terminal support
    }
    Set-PSReadLineOption -EditMode Windows
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
}
#endregion

#region Aliases
Set-Alias -Name g -Value git
Set-Alias -Name py -Value python
Set-Alias -Name open -Value explorer.exe
#endregion

# Welcome message (optional - uncomment to enable)
# Write-Host "PowerShell $($PSVersionTable.PSVersion) | $(Get-Date -Format 'yyyy-MM-dd HH:mm')" -ForegroundColor DarkGray

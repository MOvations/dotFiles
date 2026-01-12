# Dotfiles

Cross-platform development environment setup for **Linux**, **WSL2**, **macOS**, and **Windows**.

## Supported Platforms

| Platform | Script | Shell |
|----------|--------|-------|
| Ubuntu / WSL2 | `setup_terminal.sh` | Zsh + Oh My Zsh + Powerlevel10k |
| macOS | `setup_iterm.sh` | Zsh + Oh My Zsh + Powerlevel10k |
| Windows | `setup_windows.ps1` | PowerShell 7 + Starship |

## Contents

- [Windows Setup](#windows-setup)
- [Linux/WSL2 Setup](#linuxwsl2-setup)
- [macOS Setup](#macos-setup)
- [Docker Compose Templates](#docker-compose-templates)
- [What Gets Installed](#what-gets-installed)
- [Thanks To](#thanks-to)

---

## Windows Setup

### Prerequisites
- Windows 10/11 (ARM64 or x86_64)
- PowerShell 7+ installed (`winget install Microsoft.PowerShell`)
- Windows Terminal (recommended)

### Quick Start

```powershell
# Clone the repo
git clone https://github.com/MOvations/dotfiles.git
cd dotfiles

# Run the setup script
./setup_windows.ps1
```

### What It Does
- Detects architecture (ARM64/x86_64) automatically
- Installs **Fastfetch** (system info on startup)
- Installs **Starship** prompt via winget
- Installs **uv** (fast Python package manager) and Python
- Sets up PowerShell profile with aliases
- Configures Starship with a clean, informative prompt

### Options

```powershell
# Skip uv/Python installation
./setup_windows.ps1 -SkipUv

# Skip only Python (keep uv)
./setup_windows.ps1 -SkipPython

# Use a different Python version (default: 3.12)
./setup_windows.ps1 -PythonVersion 3.11

# Skip Starship installation
./setup_windows.ps1 -SkipStarship

# Force reinstall everything
./setup_windows.ps1 -Force
```

### uv Quick Reference

```powershell
uv python install 3.12    # Install Python version
uv python list            # Show available versions
uv venv                   # Create .venv in current directory
uv pip install requests   # Install packages (very fast!)
uv pip freeze             # Show installed packages
uv init myproject         # Initialize new project with pyproject.toml
```

### Included Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `act` | Activate .venv | Activate virtual environment |
| `deact` | Deactivate | Deactivate virtual environment |
| `mkenv` | `uv venv` + activate | Create and activate venv |
| `pi` | `uv pip install` | Quick package install |
| `..` | `cd ..` | Go up one directory |
| `...` | `cd ../../..` | Go up three directories |
| `ll` | `ls -la` | Long listing with details |
| `gs` | `git status` | Git status |
| `gc "msg"` | `git commit -am` | Git commit all with message |
| `gp` | `git pull --rebase` | Git pull with rebase |
| `gl` | `git log --graph` | Pretty git log |
| `mk dir` | `mkdir + cd` | Create and enter directory |
| `wttr` | `curl wttr.in` | Weather in terminal |
| `servr` | `python -m http.server` | Local HTTP server on :7200 |
| `which` | `Get-Command` | Find command location |
| `touch` | Create/update file | Unix-style touch |

---

## Linux/WSL2 Setup

### Quick Start

```bash
git clone https://github.com/MOvations/dotfiles.git
cd dotfiles
bash setup_terminal.sh
```

### What It Does
- Installs tmux, neofetch, pydf
- Sets up **Oh My Zsh** with **Powerlevel10k** theme
- Installs Miniconda (x86 only, ARM uses virtualenvs)
- Configures shell aliases and functions
- Sets up Jupyter Lab with browser support for WSL

---

## macOS Setup

### Quick Start

```bash
git clone https://github.com/MOvations/dotfiles.git
cd dotfiles
bash setup_iterm.sh
```

### What It Does
- Installs Homebrew
- Installs iTerm2, VS Code, Docker, and other apps via brew cask
- Sets up Oh My Zsh with Powerlevel10k
- Installs Miniconda with conda-zsh-completion
- Configures Dock auto-hide

---

## Docker Compose Templates

Located in `docker_templates/`:

| Service | Description |
|---------|-------------|
| Grafana | Visualization and dashboards |
| Homer | Home server dashboard |
| InfluxDB | Time-series database |
| MSSQL | Microsoft SQL Server |
| Plex | Media server |
| Portainer | Docker GUI management |
| PostgreSQL | Relational database |
| Prometheus | Metrics collection + Node Exporter + cAdvisor |

Merge templates into a single `docker-compose.yml` for networking, then manage via Portainer.

---

## What Gets Installed

### Conda Environments (Linux/macOS)

Two pre-configured environments in `conda_envs/`:

**py39.yml** - General data science:
- Python 3.9, JupyterLab, pandas, seaborn, black, nodejs

**ts4.yml** - Time-series & ML:
- Python 3.8, Prophet, scikit-learn, PyTorch, LightGBM, XGBoost, Dask

Create with: `conda env create -f conda_envs/py39.yml`

> **Note:** Windows uses **uv** instead of Conda for faster, lighter Python environment management. Use `uv pip install` to install packages from requirements.txt or pyproject.toml.

---

## File Structure

```
dotfiles/
├── setup_terminal.sh          # Linux/WSL2 setup
├── setup_iterm.sh             # macOS setup
├── setup_windows.ps1          # Windows setup
├── files/
│   ├── starship.toml          # Starship prompt config
│   ├── Microsoft.PowerShell_profile.ps1  # PowerShell profile
│   ├── config                 # SSH client config
│   └── vscode_settings_snippet.txt
├── scripts/
│   ├── myAliases.sh           # Shell aliases (bash/zsh)
│   ├── myFuncs.sh             # Shell functions
│   ├── updater.sh             # System updater
│   └── ...
├── conda_envs/
│   ├── py39.yml
│   └── ts4.yml
└── docker_templates/
    └── ...
```

---

## Thanks To

- [Scott Hanselman](https://www.hanselman.com/blog/ItsTimeForYouToInstallWindowsTerminal.aspx)
- [Fireship.io](https://fireship.io/lessons/windows-10-for-web-dev/)
- [Starship](https://starship.rs/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [uv](https://docs.astral.sh/uv/) - Fast Python package manager by Astral

---

## License

MIT - Do whatever you want with it.

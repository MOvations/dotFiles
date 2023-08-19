# New Mac Installs 

# Install Brew

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/markoliver/.zprofile

eval "$(/opt/homebrew/bin/brew shellenv)"

brew install --cask brewlet

# Installs
brew install --cask iterm2 
brew install --cask microsoft-edge 
brew install --cask azure-data-studio 
brew install --cask visual-studio-code 
brew install --cask docker 
brew install --cask docker-compose 
brew install --cask rectangle 
brew install --cask dropbox 
brew install --cask coteditor 
brew install --cask google-chrome 
brew install --cask Firefox 
brew install --cask evernote
brew install --cask karabiner-elements

##### Make sure some common programs are installed are installed #####
brew install wget git tmux neofetch zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" 
sudo apt install -y fonts-powerline

##### Use the power10k theme #####
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
sed -i 's|ZSH_THEME="robbyrussell"|ZSH_THEME="powerlevel10k/powerlevel10k"|' ~/.zshrc




# miniconda -- https://docs.conda.io/en/latest/miniconda.html
 
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh -O ~/miniconda.sh
bash ~/miniconda.sh -b -p $HOME/miniconda
rm -rf ~/miniconda

brew install conda-zsh-completion
brew install zsh-autocomplete
Brew install btop



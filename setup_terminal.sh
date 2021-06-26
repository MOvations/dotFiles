
#! /bin/bash

##### Make sure some common programs are installed are installed #####
sudo apt install -y tmux neofetch pydf ffmpeg

##### install Oh My Zosh #####
sudo apt install -y zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" 
sudo apt-get install -y fonts-powerline
echo "Oh My Zosh install, use source ~/.zshrc or logout then login to activate"

##### Use the power10k theme #####
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
sed -i 's|ZSH_THEME="robbyrussell"|ZSH_THEME="powerlevel10k/powerlevel10k"|' ~/.zshrc

. ~/.profile

mkdir ~/.scripts
cp updater.sh ~/.scripts/

echo "Adding myAliases"
zsh myAliases.sh

echo "neofetch" >> ~/.zshrc

#########################################################################
##### Find System Architecture and install appropriate stack ##### 
#########################################################################
arch=$(uname -m)
echo $arch

if [[ $arch == armv* ]]; then
echo "Arm architecture - Save yourself the trouble, use Python virtualenvs"
echo $mini_vers
echo "##### Adding IOTstack #####"
git clone https://github.com/SensorsIot/IOTstack.git ~/IOTstack

mkdir ~/.ssh/
sudo chmod 700 ~/.ssh/
touch ~/.ssh/authorized_keys
sudo chmod 644 ~/.ssh/authorized_keys
sudo chown pi:pi ~/.ssh/authorized_keys
fi
#########################################################################



#########################################################################
# Miniconda install for x86 based systems
#########################################################################
if [[ $arch == x86* ]]; then
bash create_py39_miniconda.sh
fi
#########################################################################

echo
echo "##### You're done!!! #####"
echo "use source ~/.zshrc to launch the powerline10k setup"
echo




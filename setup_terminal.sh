
#!/bin/bash

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
cp myAliases.sh ~/.scripts/
cp conda_auto_env.sh ~/.scripts/

echo "Adding conda_auto_env, myAliases, and updater to scripts and zshrc"
echo "##### Activate Conda Envs When Entering Folder #####" >> ~/.zshrc
echo "source $HOME/.scripts/conda_auto_env.sh" >> ~/.zshrc

echo "##### Activate Conda Envs When Entering Folder #####"
echo "source $HOME/.scripts/myAliases.sh" >> ~/.zshrc

echo "#### Launch NeoFetch at session start #####" >> ~/.zshrc
echo "neofetch" >> ~/.zshrc


#########################################################################
##### Find System Architecture and install appropriate stack        ##### 
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
# x86_64 installs
#########################################################################
if [[ $arch == x86* ]]; then
# install build-essential
sudo apt update && sudo apt install -y build-essential
# install miniconda from accompanying script
bash create_py39_miniconda.sh
fi
#########################################################################

echo
echo "##### You're done!!! #####"
echo "use source ~/.zshrc to launch the powerline10k setup"
echo





#!/bin/bash

##### Make sure some common programs are installed are installed #####
sudo apt update && sudo apt install -y tmux neofetch pydf 

##### install Oh My Zosh #####
echo "Type 'exit' when first presented with zsh prompt to continue installation"
sudo apt install -y zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" 
sudo apt install -y fonts-powerline

##### Use the power10k theme #####
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
sed -i 's|ZSH_THEME="robbyrussell"|ZSH_THEME="powerlevel10k/powerlevel10k"|' ~/.zshrc

##### Make Scripts directory and source files in ZSRC #####
mkdir ~/.scripts
cp scripts/updater.sh ~/.scripts/
cp scripts/myAliases.sh ~/.scripts/
cp scripts/conda_auto_env.sh ~/.scripts/
cp scripts/my_funcs.sh ~/.scripts/

echo "Adding conda_auto_env, myAliases, and updater to scripts and zshrc"
echo "##### Activate Conda Envs When Entering Folder #####" >> ~/.zshrc
echo "source $HOME/.scripts/myFuncs.sh" >> ~/.zshrc

echo "##### Activate Conda Envs When Entering Folder #####"
echo "source $HOME/.scripts/myAliases.sh" >> ~/.zshrc

echo "#### Launch NeoFetch at session start #####" >> ~/.zshrc
echo "neofetch" >> ~/.zshrc

##### Add Color to tmux #####
echo 'set -g default-terminal "screen-256color"' >> ~/.tmux.conf

#########################################################################
##### Find System Architecture and install appropriate stack        ##### 
#########################################################################
arch=$(uname -m)
echo $arch

if [[ $arch == armv* ]]; then
echo "Arm architecture - Save yourself the trouble, use Python virtualenvs"
echo $mini_vers


# doing this another way now
echo "##### DEPRICATED: Not using IOTstack anymore examine this script to install #####"
# git clone https://github.com/SensorsIot/IOTstack.git ~/IOTstack 

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
bash scripts/create_py39_miniconda.sh
fi
#########################################################################

echo
echo "##### You're done!!! #####"
echo "use source ~/.zshrc to launch the powerline10k setup"
echo




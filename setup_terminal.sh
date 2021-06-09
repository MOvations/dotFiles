
#! /bin/bash

##### Make sure git and tmux are installed #####
sudo apt install -y git tmux

##### Add Color to tmux #####
echo 'set -g default-terminal "screen-256color"' >> ~/.tmux.conf

##### install Oh My Zosh #####
sudo apt install -y zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" 
sudo apt-get install -y fonts-powerline
echo "Oh My Zosh install, use source ~/.zshrc or logout then login to activate"
# source ~/.zshrc

##### Use the power10k theme #####
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
sed -i 's|ZSH_THEME="robbyrussell"|ZSH_THEME="powerlevel10k/powerlevel10k"|' ~/.zshrc


##### Find System Architecture and install the MiniConda and extras ##### 
arch=$(uname -m)
echo $arch

if [[ $arch == x86_64 ]]; then
echo "X64 Architecture"
###### Install Anaconda (miniconda), follow the prompts #####
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
rm Miniconda3-latest-Linux-x86_64.sh
fi

if [[ $arch == x86_32 ]]; then
echo "X32 Architecture"
###### Install Anaconda (miniconda), follow the prompts #####
mini_vers=$"Miniconda3-latest-Linux-x86.sh"
echo $mini_vers
# wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86.sh
# bash Miniconda3-latest-Linux-x86.sh
# rm Miniconda3-latest-Linux-x86.sh
fi

if [[ $arch == armv* ]]; then
echo "Arm architecture"
###### Install Anaconda (miniconda), follow the prompts #####
# wget http://repo.continuum.io/miniconda/Miniconda3-latest-Linux-armv7l.sh
mini_vers=$"Miniconda3-py39_4.10.1-Linux-aarch64.sh"
echo $mini_vers
fi

wget http://repo.continuum.io/miniconda/$mini_vers
# bash Miniconda3-latest-Linux-armv7l.sh
bash $mini_vers -b -p $HOME/miniconda3
rm $mini_vers
eval "$(/home/$USER/miniconda3/conda shell.zsh hook)"


conda init

##### set PATH so it includes miniconda's bin #####
cat <<EOF >> ~/.zshrc
if [ -d "\$HOME/miniconda3/bin" ]; then
    PATH="\$HOME/miniconda3/bin:\$PATH"
fi
EOF

sudo chown -R $USER /home/$USER/miniconda3

##### Maybe do some updates #####
sudo apt update
sudo apt upgrade -y

# Add Raspberry Pi channel for conda installations
conda config --add channels rpi

###### install jupyter-lab and set the browser(Firefox in my case) to open #####
echo
echo "##### Creating Conda Environment 'py39' #####"
echo
conda update -y conda
conda update -y conda
conda create -n py39 -y python=3.9
conda init zsh
conda activate py39
conda install -y -c conda-forge jupyterlab
conda install -y -c conda-forge nodejs
conda install -y -c pyviz holoviz
jupyter labextension install @pyviz/jupyterlab_pyviz

echo
echo "##### Generating Jupyter Lab config file at ~/.jupyter/jupyter_notebook_config.py #####"
echo
jupyter lab --generate-config

arch_vers=$(uname -r)
echo "The kernal revision is" $arch_vers
if [[ $arch_vers == *"WSL"* ]]; then
  echo "This install appears to be on WSL, installing connections to windows FireFox browser"
  echo
  ##### Use Firefox Browswer #####
  echo "export BROWSER='/mnt/c/Program Files/Mozilla Firefox/firefox.exe'" >> ~/.zshrc
fi

##### Uncomment the redirect files - jupyter_lab_config #####
sed -i '/c.ServerApp.use_redirect_file/s/^#//g' ~/.jupyter/jupyter_lab_config.py
##### Switch from True to False - jupyter_lab_config #####
sed -i 's| c.ServerApp.use_redirect_file = True|c.ServerApp.use_redirect_file = False|' ~/.jupyter/jupyter_lab_config.py

. ~/.profile

echo
echo "##### You're done!!! #####"
echo "use source ~/.zshrc to launch the powerline10k setup"
echo


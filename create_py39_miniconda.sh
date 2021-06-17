#!/bin/bash

arch=$(uname -m)
echo $arch

if [[ $arch == x86_64 ]]; then
echo "X64 Architecture"
mini_vers=$"Miniconda3-latest-Linux-x86_64.sh"
echo $mini_vers
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
fi

if [[ $arch == x86_32 ]]; then
echo "X32 Architecture"
mini_vers=$"Miniconda3-latest-Linux-x86.sh"
echo $mini_vers
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86.sh
fi

#### Install Miniconda ####
bash $mini_vers -b -p $HOME/miniconda3
rm $mini_vers
eval "$(/home/$USER/miniconda3/conda shell.zsh hook)"

##### now init conda #####
conda init

##### add PATH check to ZSH to include miniconda #####
cat << EOF >> ~/.zshrc
if [ -d "\$HOME/miniconda3/bin" ]; then
    PATH="\$HOME/miniconda3/bin:\$PATH"
fi
EOF

sudo chown -R $USER /home/$USER/miniconda3

##### Do some updates #####
sudo apt update && sudo apt upgrade -y

# Add Raspberry Pi channel for conda installations
if [[ $arch == armv* ]]; then
conda config --add channels rpi
fi


###### install jupyter-lab and set the browser(Firefox in my case) to open #####
echo
echo "##### Creating Conda Environment 'py39' #####"
echo
conda update -y conda
conda update -y conda
conda env create -f conda_envs/py39.yml 
conda init zsh
conda activate py39
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
  ##### Use Firefox Browswer in WSL #####
  echo "export BROWSER='/mnt/c/Program Files/Mozilla Firefox/firefox.exe'" >> ~/.zshrc
fi

##### Make jupyter_lab_config #####
sed -i '/c.ServerApp.use_redirect_file/s/^#//g' ~/.jupyter/jupyter_lab_config.py
##### Make jupyter_lab_config #####
sed -i 's| c.ServerApp.use_redirect_file = True|c.ServerApp.use_redirect_file = False|' ~/.jupyter/jupyter_lab_config.py


#! /bin/bash

##### to make manual changes to bashrc, modify PS1 to something like this #####
# echo 'export PS1="[\t] ubuntu20:\w\$ "' >> ~/.bashrc

###### define basic promt colors for bash #####
# cat <<EOF >> ~/.bashrc
##### ANSI color codes #####
# RS="\[\033[0m\]"    # reset
# HC="\[\033[1m\]"    # hicolor
# UL="\[\033[4m\]"    # underline
# INV="\[\033[7m\]"   # inverse background and foreground
# FBLK="\[\033[30m\]" # foreground black
# FRED="\[\033[31m\]" # foreground red
# FGRN="\[\033[32m\]" # foreground green
# FYEL="\[\033[33m\]" # foreground yellow
# FBLE="\[\033[34m\]" # foreground blue
# FMAG="\[\033[35m\]" # foreground magenta
# FCYN="\[\033[36m\]" # foreground cyan
# FWHT="\[\033[37m\]" # foreground white
# BBLK="\[\033[40m\]" # background black
# BRED="\[\033[41m\]" # background red
# BGRN="\[\033[42m\]" # background green
# BYEL="\[\033[43m\]" # background yellow
# BBLE="\[\033[44m\]" # background blue
# BMAG="\[\033[45m\]" # background magenta
# BCYN="\[\033[46m\]" # background cyan
# BWHT="\[\033[47m\]" # background white
# EOF


# if [ "\$color_prompt" = yes ]; then
#     PS1='\${debian_chroot:+(\$debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\\$ '
# else
#     #PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
#     PS1="\$HC\$FYEL[ \$FBLE\${debian_chroot:+(\$debian_chroot)}\u\$FYEL: \$FBLE\w \$FYEL]\\\$ \$RS"
#     PS2="\$HC\$FYEL&gt; \$RS"
# fi
# EOF

##### install Oh My Zosh #####
sudo apt install -y zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" 
sudo apt-get install -y fonts-powerline
echo "Oh My Zosh install, use source ~/.zshrc or logout then login to activate"
# source ~/.zshrc

##### Make sure git is installed #####
sudo apt install -y git

##### Set some git credentials #####
echo
read -p 'git username: ' user_var
git config --global user.name "$user_var"
read -p 'git email: ' email_var
git config --global user.email "$email_var"
read -sp 'git password: ' pass_var
git config --global user.password "$pass_var"

##### cache these vars for 12 hours #####
git config --global credential.helper cache --timeout=43200

##### Use the power10k theme #####
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
sed -i 's|ZSH_THEME="robbyrussell"|ZSH_THEME="powerlevel10k/powerlevel10k"|' ~/.zshrc

###### Install Anaconda (miniconda), follow the prompts #####
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
rm Miniconda3-latest-Linux-x86_64.sh

echo " the current user is: $USER"
export PATH=/home/$USER/miniconda3/bin:$PATH

##### set PATH so it includes miniconda's bin #####
cat <<EOF >> ~/.bashrc
if [ -d "\$HOME/miniconda3/bin" ]; then
    PATH="\$HOME/miniconda3/bin:\$PATH"
fi
EOF

###### install jupyter-lab and set the browser(Firefox in my case) to open #####
echo
echo "##### Creating Conda Environment 'py39' #####"
echo
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


echo
echo "##### setting up bowser launch support for WSL - should make this an if statement #####"
echo
##### Use Firefox Browswer #####
echo "export BROWSER='/mnt/c/Program Files/Mozilla Firefox/firefox.exe'" >> ~/.zshrc

##### TODO: make this conditional #####
##### Uncomment the redirect files - jupyter_notebook_config #####
# sed -i '/c.NotebookApp.use_redirect_file/s/^#//g' ~/.jupyter/jupyter_notebook_config.py
##### Switch from True to False - jupyter_notebook_config #####
# sed -i 's| c.NotebookApp.use_redirect_file = True|c.NotebookApp.use_redirect_file = False|' ~/.jupyter/jupyter_notebook_config.py

##### Uncomment the redirect files - jupyter_lab_config #####
sed -i '/c.ServerApp.use_redirect_file/s/^#//g' ~/.jupyter/jupyter_lab_config.py
##### Switch from True to False - jupyter_lab_config #####
sed -i 's| c.ServerApp.use_redirect_file = True|c.ServerApp.use_redirect_file = False|' ~/.jupyter/jupyter_lab_config.py

. ~/.profile

echo
echo "##### You're done!!! #####"
echo "use source ~/.zshrc to launch the powerline10k setup"
echo


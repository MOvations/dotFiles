#!/bin/zsh

##### Add Color to tmux #####
echo 'set -g default-terminal "screen-256color"' >> ~/.tmux.conf

##### history shortcut #####
alias h='history'

##### my alias functions ####
printf "\n##### my alias functions ####\n" >> ~/.zshrc
echo 'mk() { mkdir -p "$@" && cd "$_"; }' >> ~/.zshrc  # use quotes for folders with spaces

printf "\n" >> ~/.zshrc
echo 'alias updater="zsh ~/.scripts/updater.sh"' >> ~/.zshrc 

##### Colorize the grep command output for ease of use (good for log files)##
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

##### get rid of command not found ##
alias cd..='cd ..'
 
##### a quick way to get out of current directory ##
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'

##### Colorize the ls output #####
alias ls='ls --color=auto'
 
##### Use a long listing format #####
alias ll='ls -lath --color=auto'
 
##### Show hidden files #####
alias l.='ls -d .* --color=auto'

##### tmux #####
alias ta="tmux attach -d"

# if user is not root, pass all commands via sudo #
if [ $UID -ne 0 ]; then
    alias reboot='sudo reboot'
fi

##### Launch Server #####
alias servr="python3 -m http.server --bind localhost 7200 "

##### Git aliases #####
alias gs='git status'
alias gc='git commit -am'
alias gp='git pull --rebase'
alias gl='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
git config --global credential.helper 'cache --timeout=30000' # cache git credentials for 8+ hrs

##### mk function ####
mk() { mkdir -p "$@" && cd "$_"; }

##### Weather #####
alias wttr="curl wttr.in"

##### Stash the SSH Passphrase #####
alias ssha='eval $(ssh-agent) && ssh-add'

##### Custom alias to my updater file #####
alias updater='bash ~/.scripts/updater.sh'

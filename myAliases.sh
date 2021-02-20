#!/bin/zsh

##### mk function ####
printf "\n##### mk function ####\n" >> ~/.zshrc
echo 'mk() { mkdir -p "$@" && cd "$_"; }' >> ~/.zshrc  # use quotes for folders with spaces

# Setup Terminal in Ubuntu with support for WSL2 and Ubuntu Server

I know this isn't a proper dotfile, but more of a catch-all for my common configs I automate away

## Motivation: <br>
Automating my depoloyments. 
I'll be trying to incorporate as many of my settingas as I like for all the linux environments I use.</br>

### Contents
* [Quickstart: Run and Done](#Quickstart-Run-and-Done)
* [Docker-compose files](#Docker-compose)
* [Thanks to](#thanks-to)
* [Final Notes](#final-notes)

## Quickstart: Run and Done 
Setup WSL2 for your Windows 10 pro system and isntall an Ubuntu distro from the Microsoft store. 
(Note: I've tested this on 20.04/18.04 so far)
I also use the new Microsoft Terminal, which you also install from the micro soft store

It's still a bit quirky (sorry) 
when install loads into ohmyzosh for the first time simply type "exit" to continue installation
it is safe to rerun the script if installs were missed

## Docker-Compose
Docker-Compose is pretty standard in my workflow now and as such adding the essentials in a templates folder. For networking reasons I merge all templates into a single docker-compose.yml file then add additional funcationality from portainer. See notes in individual template files

## Thanks to:
[Scott Hanselman](https://www.hanselman.com/blog/ItsTimeForYouToInstallWindowsTerminal.aspx)
and
[Fireship.io](https://fireship.io/lessons/windows-10-for-web-dev/)
for getting me setup with some great settings!

## Final Notes:

I left settings for bashrc (commented out) in the setup script if you'd like to have different look in an editor (e.g., VScode) vs Terminal

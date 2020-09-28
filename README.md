## Setup Windows Terminal in WSL2 on Ubuntu (18.04/20.04)

Motivation:
    I really dislike setting up  environments, and I do it a lot. So I'm taking the time to make an install to get things the way I like.

Instructions:
Setup WSL2 for your Windows 10 pro system and isntall an Ubuntu distro from the Microsoft store. 
(Note: I've tested this on 20.04/18.04 so far)
I also use the new Microstof Terminal, which you also install from the micro soft store

It's still a bit quirky (sorry) sometime it installs in one pass, sometimes it only gets upto the 'git' portion
if this happens run "code . " (without quotes) to launch VS Code and comment out the first part of the script. Also add the powerline10k to the .zshrc as well. Then rerun the modified script. Close the terminal reload, and boom. done. sometime this runs all at once, sometimes takes two passes. Still figuring out why...


Thanks to:
    [Scott Hanselman](https://www.hanselman.com/blog/ItsTimeForYouToInstallWindowsTerminal.aspx)
    and
    [Fireship.io](https://fireship.io/lessons/windows-10-for-web-dev/)
    for getting me setup with some great settings!

Note:
I implement 2 terminal settings (bash and zsh) as VScode and Windows Terminal will behave differently

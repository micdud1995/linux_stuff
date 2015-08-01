#!/bin/bash

clear

#=================================================================
# Creating repo dir and cloning repository
if [ ! -d ~/repo ] && [ ! -d ~/repo/linux_stuff ]; then
	echo
	echo Creating ~/repo/linux_stuff directory...
	echo Cloning repository...
	mkdir -p ~/repo
	mkdir -p ~/repo/linux_stuff
	mkdir -p ~/Obrazy
	mkdir -p ~/.i3
	cd ~/repo/linux_stuff
	git clone https://github.com/micdud1995/linux_stuff.git
else
	echo
	echo OK, ~/repo/linux_stuff already exists...
fi
#=================================================================

#=================================================================
echo
echo Configuration of i3...
echo
#=================================================================

sudo aptitude install i3 dmenu lxrandr pavucontrol xbacklight lxterminal xserver-xorg xinit nitrogen

#==============================================================
# Copying config files from repo 
cp ~/repo/linux_stuff/i3/hide.i3status.conf ~/.i3status.conf
cp ~/repo/linux_stuff/i3/config ~/.i3/config
cp ~/repo/linux_stuff/i3/i3lock-deb.png ~/Obrazy/i3lock-deb.png

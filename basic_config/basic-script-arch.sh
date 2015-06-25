#!/bin/bash

# run as a user!

clear

#=================================================================
# Creating repo dir and cloning repository
if [ ! -d ~/repo ] && [ ! -d ~/repo/linux_stuff ]; then
	echo
	echo Creating ~/repo/linux_stuff directory...
	echo Cloning repository...
	mkdir -p ~/repo
	mkdir ~/repo/linux_stuff
	cd ~/repo/linux_stuff
	git clone https://github.com/micdud1995/linux_stuff.git
else
	echo
	echo OK, ~/repo/linux_stuff already exists...
fi
#=================================================================

#=================================================================
echo
echo Configuration of moc player, midnight commander and zsh...
echo
#=================================================================

sudo pacman -S mc moc zsh tree scrot feh nitrogen slim git alsa-utils ncurses mirage

#=================================================================
# MOC 
mkdir -p ~/.moc
cp ~/repo/linux_stuff/basic_config/config_moc ~/.moc/config
#=================================================================

#=================================================================
# Midnight Commander
mkdir -p ~/.local/share/mc/skins
cp ~/repo/linux_stuff/basic_config/mc.ext ~/.config/mc/mc.ext
cp ~/repo/linux_stuff/basic_config/darkcourses_green.ini ~/.local/share/mc/skins/
sudo cp ~/repo/linux_stuff/basic_config/mc.keymap /etc/mc/mc.keymap
#=================================================================

#=================================================================
# Z-shell
cp ~/repo/linux_stuff/basic_config/hide.zshrc ~/.zshrc
chsh -s /bin/zsh 	# makes zsh default shell
#=================================================================

#=================================================================
# Others
sudo cp ~/repo/linux_stuff/basic_config/m /usr/bin/
chmod +x /usr/bin/m
sudo cp ~/repo/linux_stuff/basic_config/um /usr/bin/
chmod +x /usr/bin/um
#=================================================================

#=================================================================
# Polish letters
sudo cp vconsole.conf /etc/vconsole.conf
sudo cp 10-evdev.conf /etc/X11/xorg.conf.d/10-evdev.conf

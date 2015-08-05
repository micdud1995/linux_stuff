#!/bin/bash

# run as a user!
# configure visudo before

clear

#=================================================================
# Creating repo dir and cloning repository
if [ ! -d $HOME/repo ] && [ ! -d $HOME/repo/linux_stuff ]; then
	echo
	echo Creating ~/repo/linux_stuff directory...
	echo Cloning repository...
	mkdir -p $HOME/repo
	mkdir $HOME/repo/linux_stuff
	cd $HOME/repo/linux_stuff
	git clone https://github.com/micdud1995/linux_stuff.git
else
	echo
	echo OK, $HOME/repo/linux_stuff already exists...
fi
#=================================================================

#=================================================================
echo
echo Configuration of moc player, midnight commander, irssi, mutt and zsh...
echo
#=================================================================

sudo pacman -S mc moc zsh tree scrot nitrogen slim git alsa-utils ncurses mirage mutt xf86-input-synaptics expac zathura

#=================================================================
# MOC 
mkdir -p $HOME/.moc
cp $HOME/repo/linux_stuff/basic_config/config_moc $HOME/.moc/config
#=================================================================

#=================================================================
# Midnight Commander
mkdir -p $HOME/.local/share/mc/skins
cp $HOME/repo/linux_stuff/basic_config/mc.ext $HOME/.config/mc/mc.ext
cp $HOME/repo/linux_stuff/basic_config/darkcourses_green.ini $HOME/.local/share/mc/skins/
#=================================================================

#=================================================================
# Z-shell
cp $HOME/repo/linux_stuff/basic_config/hide.zshrc $HOME/.zshrc
chsh -s /bin/zsh 	# makes zsh default shell
#=================================================================

#=================================================================
# Mutt (text mail client)
cp $HOME/repo/linux_stuff/basic_config/hide.muttrc $HOME/.muttrc
#=================================================================

#=================================================================
# Irssi
cp $HOME/repo/linux_stuff/basic_config/config-irssi.rc $HOME/.irssi/config
cp $HOME/repo/linux_stuff/basic_config/industrial.theme $HOME/.irssi/
#=================================================================

#=================================================================
# Vimb web browser
sudo pacman -S libsoup webkitgtk2 
cd $HOME/tmp
git clone https://github.com/fanglingsu/vimb.git
cd $HOME/tmp/vimb
make clean
make install
cp $HOME/repo/linux_stuff/basic_config/config-vimb.rc $HOME/.config/vimb/config
cp $HOME/repo/linux_stuff/basic_config/bookmark-vimb.rc $HOME/.config/vimb/bookmark
#=================================================================

#=================================================================
# Others
sudo cp $HOME/repo/linux_stuff/basic_config/m /usr/bin/
chmod +x /usr/bin/m
sudo cp $HOME/repo/linux_stuff/basic_config/um /usr/bin/
chmod +x /usr/bin/um
#=================================================================

#=================================================================
# Polish letters
sudo cp $HOME/repo/linux_stuff/basic_config/vconsole.conf /etc/vconsole.conf
sudo cp $HOME/repo/linux_stuff/basic_config/10-evdev.conf /etc/X11/xorg.conf.d/10-evdev.conf

#=================================================================
# Cleaning script 
sudo cp $HOME/repo/linux_stuff/basic_config/arch-clear /usr/bin/arch-clear
sudo chmod +x /usr/bin/arch-clear
#=================================================================

#=================================================================
# Enabling touchpad
sudo cp /repo/linux_stuff/basic_config/50-synaptics.conf /etc/X11/xorg.conf.d/
#=================================================================

# run as a user!

clear

#=================================================================
# Creating repo dir and cloning repository
if [ ! -d ~/repo ] && [ ! -d ~/repo/linux_stuff ]; then
	echo
	echo =================================================================
	echo Creating ~/repo/linux_stuff directory...
	echo Cloning repository...
	echo =================================================================
	mkdir -p ~/repo
	mkdir ~/repo/linux_stuff
	cd ~/repo/linux_stuff
	git clone https://github.com/micdud1995/linux_stuff.git
else
	echo
	echo =================================================================
	echo OK, ~/repo/linux_stuff already exists...
	echo =================================================================
fi
#=================================================================

#=================================================================
echo
echo =================================================================
echo Configuration of moc player, midnight commander and zsh...
echo =================================================================
echo
#=================================================================

sudo aptitude install mc moc zsh tree scrot feh nitrogen slim git alsa-utils libncurses5-dev evince xzgv

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

# Removing all console beeps while running X
xset b off
#=================================================================

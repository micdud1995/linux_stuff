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
echo Configuration of i3...
echo =================================================================
echo
#=================================================================

sudo aptitude install i3 dmenu lxrandr pavucontrol xbacklight lxterminal xserver-xorg xinit nitrogen feh

#==============================================================
# Copying config files from repo 
cp ~/repo/linux_stuff/i3/hide.i3status.conf ~/.i3status.conf
cp ~/repo/linux_stuff/i3/config ~/.i3/config

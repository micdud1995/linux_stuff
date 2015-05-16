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
echo Configuration of conky...
echo =================================================================
echo
#=================================================================

sudo aptitude install conky

#==============================================================
# Copying .conkyrc
cp ~/repo/linux_stuff/conky/conky.conf ~/.conkyrc
#==============================================================

#==============================================================
# Copying fonts
cp ~/repo/linux_stuff/conky/hoog0555_cyr2.ttf /usr/share/fonts/truetype/ 
#==============================================================

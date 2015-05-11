# run this with sudo, not su!
# at first type: cd ~/repo && git clone https://github.com/micdud1995/linux_stuff.git

echo
echo Configuration conky...
echo

aptitude install conky

#==============================================================
# Copying .conkyrc
cp ~/repo/linux_stuff/conky/conky.conf ~/.conkyrc
#==============================================================

#==============================================================
# Copying fonts
cp ~/repo/linux_stuff/conky/hoog0555_cyr2.ttf /usr/share/fonts/truetype/ 
#==============================================================
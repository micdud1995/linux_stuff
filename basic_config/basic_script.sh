# run this with sudo, not su!
# at first type: cd ~/repo && git clone https://github.com/micdud1995/linux_stuff.git

echo
echo Configuration of moc player, midnight commander and zsh...
echo

aptitude install mc moc zsh

#=================================================================
# MOC 
mkdir ~/.moc
cp ~/repo/linux_stuff/basic_config/config_moc ~/.moc/config
#=================================================================

#=================================================================
# Midnight Commander
mkdir ~/.local/share/mc/skins
cp ~/repo/linux_stuff/basic_config/mc.ext ~/.config/mc/mc.ext
cp ~/repo/linux_stuff/basic_config/darkcourses_green.ini ~/.local/share/mc/skins/
#=================================================================

#=================================================================
# Z-shell
cp ~/repo/linux_stuff/basic_config/hide.zshrc ~/.zshrc
chsh -s /bin/zsh
#=================================================================


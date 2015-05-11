# run this with sudo, not su!
# at first type: cd ~/repo && git clone https://github.com/micdud1995/linux_stuff.git

echo
echo Configuration moc player, midnight commander and zsh...
echo

aptitude install mc moc zsh

mkdir ~/.moc
cp ~/repo/linux_stuff/basic_config/config_moc ~/.moc/config

mkdir ~/.local/share/mc/skins
cp ~/repo/linux_stuff/basic_config/mc.ext ~/.config/mc/mc.ext
cp ~/repo/linux_stuff/basic_config/darkcourses_green.ini ~/.local/share/mc/skins/

cp ~/repo/linux_stuff/basic_config/hide.zshrc ~/.zshrc
chsh -s /bin/zsh


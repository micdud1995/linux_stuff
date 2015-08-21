#!/bin/bash

#==============================================================================
# Title             debian-configurator.sh 
# Description       This script will config installed Debian GNU/Linux system 
# Author            Michał Dudek 
# Date              13-07-2015
# Version           1.0
# Notes             Run as a user, configure sudo before
# Bash_version      4.3-11+b1
# License           GNU General Public License v3.0
#==============================================================================

#=================================
# Colors
color0=g
color1=g
color2=r
color3=gr
color4=r
color5=b
color6=y
#=================================

cecho() {
  local code="\033["
  case "$1" in
    black  | bk) color="${code}0;30m";;
    red    |  r) color="${code}1;31m";;
    green  |  g) color="${code}1;32m";;
    yellow |  y) color="${code}1;33m";;
    blue   |  b) color="${code}1;34m";;
    purple |  p) color="${code}1;35m";;
    cyan   |  c) color="${code}1;36m";;
    gray   | gr) color="${code}0;37m";;
    *) local text="$1"
  esac
  [ -z "$text" ] && local text="$color$2${code}0m"
  printf "$text"
}

menu() 
{
    clear
    cecho c "==========> Choice your OS: \n"
    cecho r "1) Debian\n"
    cecho b "2) Arch Linux\n"
    read c2

    if [ "$c2" -eq "1" ] ; then
        menu-deb
    elif [ "$c2" -eq "2" ] ; then
        menu-arch
    else
        cecho r "Bad number\n"
    fi
}

menu-deb() 
{
    clear
    cecho $color0  "==================== CONFIG =======================\n"
    cecho $color1 "1) Git\t\t\t"
    cecho $color2 "12) Vim\n"
    cecho $color1 "2) Mkdirs/clone repo\t"
    cecho $color2 "13) Conky\n"
    cecho $color1 "3) Basic packages\t"
    cecho $color2 "14) DE\n"
    cecho $color1 "4) Text apps\t\t"
    cecho $color2 "15) SSH \n"
    cecho $color1 "5) Scripts & beep\t"
    cecho $color2 "16) Livestreamer [source]\n"
    cecho $color1 "6) Lenovo G580\t\t"
    cecho $color2 "17) Youtube-dl [source]\n"
    cecho $color1 "7) Shell\t\t"
    cecho $color2 "18) Steam\n"
    cecho $color3 "8) Sources.list\t\t"
    cecho $color2 "19) Virtualbox\n"
    cecho $color3 "9) Slim \t\t"
    cecho $color2 "20) Irssi\n"
    cecho $color3 "10) Grub\t\t"
    cecho $color2 "21) Vimb [source]\n"
    cecho $color3 "11) .xinitrc\n"
    cecho $color4 "99) Exit\t\t"
    cecho $color6 "100) All\n"
    cecho $color0 "===================================================\n"
    read c

    if [ "$c" -eq "1" ] ; then
        fun-git
        menu-deb
    elif [ "$c" -eq "2" ] ; then
        fun-dirs
        menu-deb
    elif [ "$c" -eq "3" ] ; then
        fun-packages
        menu-deb
    elif [ "$c" -eq "4" ] ; then
        fun-textapps
        menu-deb
    elif [ "$c" -eq "5" ] ; then
        fun-beepscripts
        menu-deb
    elif [ "$c" -eq "6" ] ; then
        fun-lenovo
        menu-deb
    elif [ "$c" -eq "7" ] ; then
        fun-shell
        menu-deb
    elif [ "$c" -eq "8" ] ; then
        fun-sources
        menu-deb
    elif [ "$c" -eq "9" ] ; then
        fun-slim
        menu-deb
    elif [ "$c" -eq "10" ] ; then
        fun-grub
        menu-deb
    elif [ "$c" -eq "11" ] ; then
        fun-xinit
        menu-deb
    elif [ "$c" -eq "12" ] ; then
        fun-vim
        menu-deb
    elif [ "$c" -eq "13" ] ; then
        fun-conky
        menu-deb
    elif [ "$c" -eq "14" ] ; then
        fun-de
        menu-deb
    elif [ "$c" -eq "15" ] ; then
        fun-ssh
        menu-deb
    elif [ "$c" -eq "16" ] ; then
        fun-livestreamer
        menu-deb
    elif [ "$c" -eq "17" ] ; then
        fun-youtubedl
        menu-deb
    elif [ "$c" -eq "18" ] ; then
        fun-steam
        menu-deb
    elif [ "$c" -eq "19" ] ; then
        fun-virtualbox
        menu-deb
    elif [ "$c" -eq "20" ] ; then
        fun-irssi
        menu-deb
    elif [ "$c" -eq "21" ] ; then
        fun-vimb
        menu-deb
    elif [ "$c" -eq "99" ] ; then
        clear
        exit
    elif [ "$c" -eq "100" ] ; then
        fun-all
    else
        cecho r "Bad number\n"
        read -p "Press any key..."
        menu-deb
    fi
}

fun-git()
{
    cecho c "==========> Git installing\n"
    sudo aptitude install git -y
    cecho c "==========> Setting user name\n"
    git config --global user.name "Michal Dudek"
    cecho c "==========> Setting user e-mail\n"
    git config --global user.email michal.dudek1995@gmail.com

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-dirs()
{
    cecho c "==========> Creating dirs...\n"
    mkdir -p $HOME/repo
    mkdir -p $HOME/tmp
    # Creating repo dir and cloning repository
    if [ ! -d $HOME/repo/linux_stuff ]; then
        cd $HOME/repo
        cecho c "==========> Cloning repository...\n"
        git clone https://github.com/micdud1995/linux_stuff.git
    else
        cecho c "==========> $HOME/repo/linux_stuff exists already...\n"
    fi

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-packages()
{
    cecho c "==========> Choice packages: \n"
    cecho c "1) All\n"
    cecho c "2) X server\n"
    read c2

    if [ "$c2" -eq "1" ] ; then
        cecho c "==========> Installing basic packages...\n"
        sudo aptitude install mc moc mutt tree scrot feh git alsa-utils libncurses5-dev zathura mirage xserver-xorg-input-synaptics mpv lxrandr pavucontrol xbacklight lxterminal xserver-xorg xorg xbase-clients xfonts-base xinit rtorrent pinta irssi -y
        cecho c "==========> Reconfiguring xserver-xorg...\n"
        sudo dpkg-reconfigure xserver-xorg
    elif [ "$c2" -eq "2" ] ; then
        sudo aptitude install xserver-xorg-input-synaptics xserver-xorg xorg xbase-clients xfonts-base xinit

    else
        cecho r "Bad number\n"
        read -p "Press any key..."
        menu-deb
    fi

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-textapps()
{
    cecho c "==========> Creating dirs\n"
    mkdir -p $HOME/.config/mc
    mkdir -p $HOME/.moc
    mkdir -p $HOME/.local/share/mc/skins
    mkdir -p $HOME/.rtorrent
    cecho c "==========> Installing packages\n"
    sudo aptitude install moc mc mutt rtorrent -y
    cecho c "==========> Configuration moc player\n"
    cp $HOME/repo/linux_stuff/config-files/config_moc $HOME/.moc/config
    cecho c "==========> Configuration midnight commander\n"
    cp $HOME/repo/linux_stuff/config-files/mc.ext $HOME/.config/mc/mc.ext
    cp $HOME/repo/linux_stuff/config-files/darkcourses_green.ini $HOME/.local/share/mc/skins/
    cecho c "==========> Configuration mutt\n"
    cp $HOME/repo/linux_stuff/config-files/hide.muttrc $HOME/.muttrc
    cecho c "==========> Configuration rtorrent\n"
    cp ~/repo/linux_stuff/config-files/hide.rtorrent.rc ~/.rtorrent.rc

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-beepscripts()
{
    cecho c "==========> Disabling beep sound\n"
    sudo rmmod pcspkr
    sudo echo "blacklist pcspkr" > /etc/modprobe.d/blacklist
    # Mount scripts
    cecho c "==========> Copying mount scripts\n"
    sudo cp $HOME/repo/linux_stuff/config-files/m /usr/bin/
    sudo chmod +x /usr/bin/m
    sudo cp $HOME/repo/linux_stuff/config-files/um /usr/bin/
    sudo chmod +x /usr/bin/um
    cecho c "==========> Copying live-usb script\n"
    sudo cp $HOME/repo/linux_stuff/config-files/live-usb /usr/bin/
    sudo chmod +x /usr/bin/live-usb

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-lenovo()
{
    cecho c "==========> Choice what to do:\n"
    cecho c "1) all\n"
    cecho c "2) Set wallpaper\n"
    cecho c "3) Enable touchpad\n"
    cecho c "4) Enable wifi\n"
    cecho c "5) Don't suspend with lid closed\n"
    read c2

    if [ "$c2" -eq "1" ] ; then
        cecho c "==========> Updating /etc/apt/sources.list\n"
        sudo cp $HOME/repo/linux_stuff/config-files/sources.list /etc/apt/sources.list
        cecho c "==========> Update system\n"
        sudo aptitude update
        cecho c "==========> Upgrade system\n"
        sudo aptitude upgrade -y
        cecho c "==========> Enabling microphone\n"
        sudo cp $HOME/repo/linux_stuff/config-files/alsa-base.conf /etc/modprobe.d/alsa-base.conf
        cecho c "==========> Enabling wifi\n"
        sudo aptitude install linux-headers-$(uname -r|sed 's,[^-]*-[^-]*-,,') broadcom-sta-dkms wicd
        sudo modprobe -r b44 b43 b43legacy ssb brcmsmac
        sudo modprobe wl
        sudo cp $HOME/repo/linux_stuff/config-files/interfaces /etc/network/interfaces
        sudo adduser michal netdev
        sudo /etc/init.d/dbus reload
        sudo /etc/init.d/wicd start
        wicd-client -n
        cecho c "==========> Enabling touchpad\n"
        sudo cp $HOME/repo/linux_stuff/config-files/50-synaptics.conf /etc/X11/xorg.conf.d/
        echo synclient TapButton1=1 >> $HOME/.xinitrc
        cecho c "==========> Setting wallpaper\n"
        sudo aptitude install feh
        mkdir -p $HOME/Obrazy
        cp $HOME/repo/linux_stuff/config-files/wallpaper.jpg $HOME/Obrazy/wallpaper.jpg
        feh --bg-scale $HOME/Obrazy/wallpaper.jpg
        cecho c "==========> Don't suspend when lid closed\n"
        sudo cp $HOME/repo/linux_stuff/config-files/logind.conf /etc/systemd/logind.conf
    elif [ "$c2" -eq "2" ] ; then
        cecho c "==========> Setting wallpaper\n"
        sudo aptitude install feh
        mkdir -p $HOME/Obrazy
        cp $HOME/repo/linux_stuff/config-files/wallpaper.jpg $HOME/Obrazy/wallpaper.jpg
    elif [ "$c2" -eq "3" ] ; then
        cecho c "==========> Enabling touchpad\n"
        sudo cp $HOME/repo/linux_stuff/config-files/50-synaptics.conf /etc/X11/xorg.conf.d/
    elif [ "$c2" -eq "4" ] ; then
        cecho c "==========> Enabling wifi\n"
        sudo aptitude install linux-headers-$(uname -r|sed 's,[^-]*-[^-]*-,,') broadcom-sta-dkms wicd
        sudo modprobe -r b44 b43 b43legacy ssb brcmsmac
        sudo modprobe wl
        sudo cp $HOME/repo/linux_stuff/config-files/interfaces /etc/network/interfaces
        sudo adduser michal netdev
        sudo /etc/init.d/dbus reload
        sudo /etc/init.d/wicd start
        wicd-client -n
    elif [ "$c2" -eq "5" ] ; then
        cecho c "==========> Don't suspend when lid closed\n"
        sudo cp $HOME/repo/linux_stuff/config-files/logind.conf /etc/systemd/logind.conf
    else
        cecho r "Bad number\n"
        read -p "Press any key..."
        menu-deb
    fi

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-shell()
{
    cecho c "==========> Choice shell: \n"
    cecho c "1) bash\n"
    cecho c "2) zsh\n"
    read c2

    if [ "$c2" -eq "1" ] ; then
        cecho c "==========> Installing colordiff\n"
        sudo aptitude install colordiff
        cecho c "==========> Configuration bash\n"
        cp $HOME/repo/linux_stuff/config-files/hide.bashrc $HOME/.bashrc
        cecho c "==========> Making bash default shell\n"
        chsh -s /bin/bash
    elif [ "$c2" -eq "2" ] ; then
        cecho c "==========> Installing zsh\n"
        sudo aptitude colordiff install zsh -y
        cecho c "==========> Configuration zsh\n"
        cp $HOME/repo/linux_stuff/config-files/hide.zshrc $HOME/.zshrc
        cecho c "==========> Making zsh default shell\n"
        chsh -s /bin/zsh

    else
        cecho r "Bad number\n"
        read -p "Press any key..."
        menu-deb
    fi

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-sources()
{
    cecho c "==========> Choice your version\n"
    cecho c "1) stable\n"
    cecho c "2) testing\n"
    cecho c "3) unstable\n"
    read c2

    if [ "$c2" -eq "1" ] ; then
        sudo sh -c "echo '### STABLE ###' > /etc/apt/sources.list"
        sudo sh -c "echo 'deb http://ftp.pl.debian.org/debian/ stable main contrib non-free' >> /etc/apt/sources.list"
        sudo sh -c "echo 'deb-src http://ftp.pl.debian.org/debian/ stable main contrib non-free' >> /etc/apt/sources.list"
        sudo sh -c "echo >> /etc/apt/sources.list"
        sudo sh -c "echo 'deb http://security.debian.org/ stable/updates main contrib non-free' >> /etc/apt/sources.list"
        sudo sh -c "echo 'deb-src http://security.debian.org/ stable/updates main contrib non-free' >> /etc/apt/sources.list"
        sudo sh -c "echo >> /etc/apt/sources.list"
        sudo sh -c "echo 'deb http://ftp.pl.debian.org/debian/ jessie-updates main' >> /etc/apt/sources.list"
        sudo sh -c "echo 'deb-src http://ftp.pl.debian.org/debian/ jessie-updates main' >> /etc/apt/sources.list"

    elif [ "$c2" -eq "2" ] ; then
        sudo sh -c "echo '### TESTING ###' > /etc/apt/sources.list"
        sudo sh -c "echo 'deb http://ftp.pl.debian.org/debian/ testing main contrib non-free' >> /etc/apt/sources.list"
        sudo sh -c "echo 'deb-src http://ftp.pl.debian.org/debian/ testing main contrib non-free' >> /etc/apt/sources.list"
        sudo sh -c "echo >> /etc/apt/sources.list"
        sudo sh -c "echo 'deb http://security.debian.org/ testing/updates main contrib non-free' >> /etc/apt/sources.list"
        sudo sh -c "echo 'deb-src http://security.debian.org/ testing/updates main contrib non-free' >> /etc/apt/sources.list"

    elif [ "$c2" -eq "3" ] ; then
        sudo sh -c "echo '### UNSTABLE ###' > /etc/apt/sources.list"
        sudo sh -c "echo 'deb http://ftp.pl.debian.org/debian/ unstable main contrib non-free' >> /etc/apt/sources.list"
        sudo sh -c "echo 'deb-src http://ftp.pl.debian.org/debian/ unstable main contrib non-free' >> /etc/apt/sources.list"
        sudo sh -c "echo >> /etc/apt/sources.list"
        sudo sh -c "echo 'deb http://security.debian.org/ unstable/updates main contrib non-free' >> /etc/apt/sources.list"
        sudo sh -c "echo 'deb-src http://security.debian.org/ unstable/updates main contrib non-free' >> /etc/apt/sources.list"
    else
        cecho r "Bad number\n"
    fi

    sudo aptitude update 
    sudo aptitude upgrade

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-slim()
{
    cecho c "==========> Installing slim\n"
    sudo aptitude install slim -y
    cecho c "==========> Copying slim.conf\n"
    sudo cp $HOME/repo/linux_stuff/config-files/slim.conf /etc/slim.conf
    cecho c "==========> Making slim default login manager\n"
    sudo dpkg-reconfigure slim

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-grub()
{
    cecho c "==========> Remaking grub file\n"
    sudo cp $HOME/repo/linux_stuff/config-files/grub /etc/default/grub
    sudo update-grub

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-xinit()
{
    cecho c "==========> Choice your DE\n"
    cecho c "1) i3\n"
    cecho c "2) lxde\n"
    cecho c "3) awesome\n"
    read c2

    if [ "$c2" -eq "1" ] ; then
        echo "setxkbmap pl &" > $HOME/.xinitrc
        echo "exec i3" >> $HOME/.xinitrc
    elif [ "$c2" -eq "2" ] ; then
        echo "setxkbmap pl &" > $HOME/.xinitrc
        echo "exec startlxde" >> $HOME/.xinitrc
    elif [ "$c2" -eq "3" ] ; then
        echo "setxkbmap pl &" > $HOME/.xinitrc
        echo "exec awesome" >> $HOME/.xinitrc
    else
        cecho r "Bad number\n"
    fi

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-vim()
{
    #==============================================================
    # Plugin list:
    #	Pathogen
    #	Nerdtree
    #	Syntastic
    #	Tagbar / Taglist
    #	GitGutter
    #	Nerdcommenter
    # 	Vim-airline
    #	Auto-pairs
    # 	Supertab
    #	SnipMate
    #   indentLine
    #   SingleCompile
    #   Vim-commentary
    #	Gruvbox theme
    #==============================================================

    cecho c "==========> Installing vim depedencies\n"
    sudo aptitude install vim curl exuberant-ctags fonts-inconsolata -y

    cecho c "==========> Making vim dirs\n"
    mkdir -p ~/tmp ~/.vim/autoload ~/.vim/bundle ~/.vim/colors ~/tmp/tagbar

    cecho c "==========> Pathogen\n"
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

    cecho c "==========> Nerdtree\n"
    cd ~/.vim/bundle && \
    git clone https://github.com/scrooloose/nerdtree.git

    cecho c "==========> Syntastic\n"
    cd ~/.vim/bundle && \
    git clone https://github.com/scrooloose/syntastic.git

    cecho c "==========> Taglist/Tagbar\n"
    cd ~/.vim/bundle && \
    git clone git://github.com/vim-scripts/taglist.vim.git
    #git clone https://github.com/vim-scripts/Tagbar.git

    cecho c "==========> Git-gutter\n"
    cd ~/.vim/bundle && \
    git clone git://github.com/airblade/vim-gitgutter.git

    cecho c "==========> Nerd-commenter\n"
    cd ~/.vim/bundle && \
    git clone https://github.com/scrooloose/nerdcommenter.git

    cecho c "==========> Vim-airline\n"
    cd ~/.vim/bundle && \
    git clone https://github.com/bling/vim-airline ~/.vim/bundle/vim-airline

    cecho c "==========> Auto-pairs\n"
    cd ~/.vim/bundle && \
    git clone git://github.com/jiangmiao/auto-pairs.git

    cecho c "==========> Supertab\n"
    git clone git://github.com/ervandew/supertab.git

    cecho c "==========> Snipmate\n"
    cd ~/.vim/bundle
    git clone https://github.com/tomtom/tlib_vim.git
    git clone https://github.com/MarcWeber/vim-addon-mw-utils.git
    git clone https://github.com/garbas/vim-snipmate.git
    git clone https://github.com/honza/vim-snippets.git

    cecho c "==========> Indent-line\n"
    cd ~/.vim/bundle
    git clone https://github.com/Yggdroot/indentLine.git

    cecho c "==========> Single-compile\n"
    cd ~/.vim/bundle
    git clone https://github.com/xuhdev/SingleCompile.git

    cecho c "==========> Vim-commentary\n"
    cd ~/.vim/bundle
    git clone https://github.com/tpope/vim-commentary.git

    #cecho c "==========> Gruvbox theme\n"
    #mkdir -p ~/tmp
    #cd ~/tmp && \
    #git clone https://github.com/morhetz/gruvbox.git
    #mv ~/tmp/gruvbox/autoload/gruvbox.vim ~/.vim/autoload/gruvbox.vim
    #mv ~/tmp/gruvbox/colors/gruvbox.vim ~/.vim/colors/gruvbox.vim
    #rm -rf ~/tmp/gruvbox

    #cecho c "==========> Sorcerer theme\n"
    #cd ~/tmp && \
    #git clone https://github.com/adlawson/vim-sorcerer.git
    #mv ~/tmp/vim-sorcerer/colors/sorcerer.vim ~/.vim/colors
    #rm -rf ~/tmp/vim-sorcerer

    cecho c "==========> Jellybeans theme\n"
    cd ~/tmp && \
    git clone https://github.com/nanotech/jellybeans.vim.git
    mv ~/tmp/jellybeans.vim/colors/jellybeans.vim ~/.vim/colors/jellybeans.vim
    rm -rf ~/tmp/jellybeans.vim

    cecho c "==========> Copying .vimrc\n"
    cp ~/repo/linux_stuff/vim/hide.vimrc ~/.vimrc
    
    cecho c "==========> Copying own snippets\n"
    cp $HOME/repo/linux_stuff/vim/cpp.snippets $HOME/.vim/bundle/vim-snippets/snippets/
    cp $HOME/repo/linux_stuff/vim/c.snippets $HOME/.vim/bundle/vim-snippets/snippets/
    cp $HOME/repo/linux_stuff/vim/python.snippets $HOME/.vim/bundle/vim-snippets/snippets/

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-conky()
{
    cecho c "==========> Installing conky\n"
    sudo aptitude install conky -y

    cecho c "==========> Copying .conkyrc\n"
    cp ~/repo/linux_stuff/conky/conky.conf ~/.conkyrc

    cecho c "==========> Copying fonts\n"
    sudo cp ~/repo/linux_stuff/conky/hoog0555_cyr2.ttf /usr/share/fonts/truetype/ 

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-de()
{
    cecho c "==========> Choice your DE\n"
    cecho c "1) i3\n"
    cecho c "2) lxde-core\n"
    cecho c "3) awesome\n"
    read c2

    if [ "$c2" -eq "1" ] ; then
        cecho c "==========> Creating dirs\n"
        mkdir -p $HOME/.i3
        mkdir -p $HOME/Obrazy
        cecho c "==========> Installing i3 depedencies\n"
        sudo aptitude install i3 dmenu lxrandr pavucontrol xbacklight lxterminal xserver-xorg xorg xbase-clients xfonts-base xinit feh -y

        cecho c "==========> Copying config files\n"
        cp ~/repo/linux_stuff/i3/hide.i3status.conf ~/.i3status.conf
        cp ~/repo/linux_stuff/i3/config ~/.i3/config
        cp ~/repo/linux_stuff/i3/i3lock-deb.png ~/Obrazy/i3lock-deb.png
    elif [ "$c2" -eq "2" ] ; then
        cecho c "==========> Installing lxde-core depedencies\n"
        sudo aptitude install xserver-xorg xorg xbase-clients xfonts-base xinit lxde-core lxterminal pavucontrol xbacklight
    elif [ "$c2" -eq "3" ] ; then
        cecho c "==========> Installing awesome depedencies\n"
        sudo aptitude install xserver-xorg xorg xbase-clients xfonts-base xinit awesome lxterminal pavucontrol xbacklight
    else
        cecho r "Bad number\n"
    fi

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-ssh()
{
    cecho c "==========> Installing SSH server\n"
    sudo aptitude install openssh-server
    sudo iptables -I INPUT -p tcp --dport 22 -j ACCEPT
    cecho c "==========> Restarting SSH server\n"
    sudo /etc/init.d/ssh restart
    cecho y "==========> To connect: ssh user@ip-number\n"
    cecho y "==========> To run GUI apps: export DISPLAY=:0\n"

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-livestreamer()
{
    cecho c "==========> Installing depedencies\n"
    sudo aptitude install python python-requests python-setuptools python-singledispatch -y
    cd $HOME/tmp
    cecho c "==========> Cloning repository\n"
    git clone https://github.com/chrippa/livestreamer.git
    cd $HOME/tmp/livestreamer
    cecho c "==========> Installing\n"
    sudo python setup.py install
    cecho c "==========> Cleaning tmp files\n"
    sudo rm -rf $HOME/tmp/livestreamer

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-youtubedl()
{
    cecho c "==========> Downloading youtube-dl from webpage\n"
    sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
    cecho c "==========> Making file executable\n"
    sudo chmod a+rx /usr/local/bin/youtube-dl

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-steam()
{
    mkdir -p $HOME/tmp
    cecho c "==========> Installing steam depedencies...\n"
    sudo aptitude install curl zenity -y
    cecho c "==========> Downloading .deb package...\n"
    wget https://steamcdn-a.akamaihd.net/client/installer/steam.deb -O $HOME/tmp/steam.deb
    cecho c "==========> Installing steam...\n"
    sudo dpkg -i $HOME/tmp/steam.deb

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-virtualbox()
{
    cecho c "==========> Installing virtualbox depedencies\n"
    sudo aptitude install virtualbox dkms build-essential linux-headers-amd64 virtualbox-guest-x11 virtualbox-dkms virtualbox-guest-utils -y

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-irssi()
{
    cecho c "==========> Creating dirs\n"
    mkdir $HOME/.irssi
    cecho c "==========> Installing irssi\n"
    sudo aptitude install irssi -y
    cecho c "==========> Copying config files\n"
    cp $HOME/repo/linux_stuff/config-files/config-irssi.rc $HOME/.irssi/config
    cp $HOME/repo/linux_stuff/config-files/cyanic.theme $HOME/.irssi/

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-vimb()
{
    mkdir -p $HOME/tmp
    mkdir -p $HOME/tmp/vimb
    mkdir -p $HOME/.config/vimb
    cecho c "==========> Installing depedencies for vimb...\n"
    sudo aptitude install libsoup2.4-dev libwebkit-dev libgtk-3-dev libwebkitgtk-3.0-dev -y
    cd $HOME/tmp
    git clone https://github.com/fanglingsu/vimb.git
    cd $HOME/tmp/vimb
    make clean
    sudo make install
    cp $HOME/repo/linux_stuff/config-files/config-vimb.rc $HOME/.config/vimb/config
    cp $HOME/repo/linux_stuff/config-files/bookmark-vimb.rc $HOME/.config/vimb/bookmark

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-all()
{
    clear
    cecho r "==========> Step: 1/20\n"
    fun-sources
    cecho r "==========> Step: 2/20\n"
    fun-git
    cecho r "==========> Step: 3/20\n"
    fun-dirs
    cecho r "==========> Step: 4/20\n"
    fun-packages
    cecho r "==========> Step: 5/20\n"
    fun-textapps
    cecho r "==========> Step: 6/20\n"
    fun-beepscripts
    cecho r "==========> Step: 7/20\n"
    fun-lenovo
    cecho r "==========> Step: 8/20\n"
    fun-shell
    cecho r "==========> Step: 9/20\n"
    fun-slim
    cecho r "==========> Step: 10/20\n"
    fun-grub
    cecho r "==========> Step: 11/20\n"
    fun-xinit
    cecho r "==========> Step: 12/20\n"
    fun-vim
    cecho r "==========> Step: 13/20\n"
    fun-de
    cecho r "==========> Step: 14/20\n"
    fun-ssh
    cecho r "==========> Step: 15/20\n"
    fun-livestreamer
    cecho r "==========> Step: 16/20\n"
    fun-youtubedl
    cecho r "==========> Step: 17/20\n"
    fun-steam
    cecho r "==========> Step: 18/20\n"
    fun-virtualbox
    cecho r "==========> Step: 19/20\n"
    fun-irssi
    cecho r "==========> Step: 20/20\n"
    fun-vimb
}


###############################################################################################
######################################  ARCH  #################################################
###############################################################################################

menu-arch() 
{
    clear
    cecho $color0  "================= CONFIG =================\n"
    cecho $color1 "1) Git\t\t\t"
    cecho $color5 "12) Vim\n"
    cecho $color1 "2) Mkdirs/clone repo\t"
    cecho $color5 "13) Conky\n"
    cecho $color1 "3) Basic packages\t"
    cecho $color5 "14) DE\n"
    cecho $color1 "4) Text apps\t\t"
    cecho $color5 "15) SSH \n"
    cecho $color1 "5) Scripts & beep\t"
    cecho $color5 "16) Livestreamer\n"
    cecho $color1 "6) Lenovo G580\t\t"
    cecho $color5 "17) Youtube-dl\n"
    cecho $color3 "7) Shell\t\t"
    cecho $color5 "18) Steam\n"
    cecho $color3 "8) Pacman\t\t"
    cecho $color5 "19) Virtualbox\n"
    cecho $color3 "9) Slim \t\t"
    cecho $color5 "20) Irssi\n"
    cecho $color3 "10) Grub\t\t"
    cecho $color5 "21) Vimb [source]\n"
    cecho $color3 "11) .xinitrc\t\t"
    cecho $color6 "0) Inst. ending\n"
    cecho $color5 "99) Exit\t\t"
    cecho $color6 "100) All\n"
    cecho $color0 "==========================================\n"
    read c

    if [ "$c" -eq "0" ] ; then
        fun-install-arch
    elif [ "$c" -eq "1" ] ; then
        fun-git-arch
    elif [ "$c" -eq "2" ] ; then
        fun-dirs-arch 
    elif [ "$c" -eq "3" ] ; then
        fun-packages-arch
    elif [ "$c" -eq "4" ] ; then
        fun-textapps-arch
    elif [ "$c" -eq "5" ] ; then
        fun-beepscripts-arch
    elif [ "$c" -eq "6" ] ; then
        fun-lenovo-arch
    elif [ "$c" -eq "7" ] ; then
        fun-shell-arch
    elif [ "$c" -eq "8" ] ; then
        fun-pacman
    elif [ "$c" -eq "9" ] ; then
        fun-slim-arch
    elif [ "$c" -eq "10" ] ; then
        fun-grub-arch
    elif [ "$c" -eq "11" ] ; then
        fun-xinit-arch
    elif [ "$c" -eq "12" ] ; then
        fun-vim-arch
    elif [ "$c" -eq "13" ] ; then
        fun-conky-arch
    elif [ "$c" -eq "14" ] ; then
        fun-de-arch
    elif [ "$c" -eq "15" ] ; then
        fun-ssh-arch
    elif [ "$c" -eq "16" ] ; then
        fun-livestreamer-arch
    elif [ "$c" -eq "17" ] ; then
        fun-youtubedl-arch
    elif [ "$c" -eq "18" ] ; then
        fun-steam-arch
    elif [ "$c" -eq "19" ] ; then
        fun-virtualbox-arch
    elif [ "$c" -eq "20" ] ; then
        fun-irssi-arch
    elif [ "$c" -eq "21" ] ; then
        fun-vimb-arch
    elif [ "$c" -eq "99" ] ; then
        clear
        exit
    elif [ "$c" -eq "100" ] ; then
        fun-all-arch
    else
        cecho r "Bad number\n"
        read -p "Press any key..."
        menu-arch
    fi
}

fun-install-arch()
{
    cecho r "==========> Pacman updating\n"
    fun-pacman

    cecho r "==========> Installing network depedencies\n"
    pacman -S wget net-tools wicd wireless_tools wpa_supplicant wpa_actiond

    cecho r "==========> Installing xorg\n"
	pacman -S xorg-server xorg-server-utils xorg-apps xorg-xinit xf86-input-evdev xf86-input-mouse xf86-input-keyboard xf86-video-vesa xf86-input-synaptics mesa lib32-mesa-libgl i3 slim lxterminal htop tree 

    cecho r "==========> Installing audio depedencies\n"
    pacman -S alsa-firmware alsa-lib alsa-plugins alsa-utils pulseaudio pulseaudio-alsa libcanberra libcanberra-pulse

    cecho r "==========> Language settings\n"
    echo "LANG=pl_PL.UTF-8" > /etc/locale.conf
    export LANG=pl_PL.UTF-8

    cecho r "==========> Enabling services\n"
    systemctl disable dhcpcd
    systemctl disable network-auto-wired.service
    systemctl enable wicd
    systemctl enable slim.service

    cecho r "==========> Adding michal user\n"
	useradd -m -g users -s /bin/bash michal
	chfn michal
	passwd michal 
	pacman -S sudo
	visudo

    cecho r "Bad number\n"
    read -p "Press any key..."
    menu-arch
}
fun-git-arch()
{
    cecho c "==========> Git installing\n"
    sudo pacman -S git --noconfirm
    cecho c "==========> Setting user name\n"
    git config --global user.name "Michal Dudek"
    cecho c "==========> Setting user e-mail\n"
    git config --global user.email michal.dudek1995@gmail.com

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-dirs-arch()
{
    cecho c "==========> Creating dirs...\n"
    mkdir -p $HOME/repo
    mkdir -p $HOME/tmp
    # Creating repo dir and cloning repository
    if [ ! -d $HOME/repo/linux_stuff ]; then
        cd $HOME/repo
        cecho c "==========> Cloning repository...\n"
        git clone https://github.com/micdud1995/linux_stuff.git
    else
        cecho c "==========> $HOME/repo/linux_stuff exists already...\n"
    fi

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-packages-arch()
{
    cecho c "==========> Choice packages: \n"
    cecho c "1) All\n"
    cecho c "2) Xorg\n"
    read c2

    if [ "$c2" -eq "1" ] ; then
        cecho c "==========> Installing basic packages...\n"
        sudo pacman -S mc moc mutt tree scrot feh git alsa-utils ncurses zathura mirage  mpv lxrandr pavucontrol lxterminal rtorrent pinta irssi xf86-input-synaptics expac lib32-mesa-libgl xorg-server xf86-input-evdev xf86-input-mouse xf86-input-keyboard xorg --noconfirm 
    elif [ "$c2" -eq "2" ] ; then
        sudo pacman -S xorg xf86-input-synaptics lib32-mesa-libgl xorg-server xf86-input-evdev xf86-input-mouse xf86-input-keyboard 
    else
        cecho r "Bad number\n"
        read -p "Press any key..."
        menu-arch
    fi

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-textapps-arch()
{
    cecho c "==========> Creating dirs\n"
    mkdir -p $HOME/.config/mc
    mkdir -p $HOME/.moc
    mkdir -p $HOME/.local/share/mc/skins
    mkdir -p $HOME/.rtorrent
    cecho c "==========> Installing packages\n"
    sudo pacman -S moc mc mutt rtorrent --noconfirm
    cecho c "==========> Configuration moc player\n"
    cp $HOME/repo/linux_stuff/config-files/config_moc $HOME/.moc/config
    cecho c "==========> Configuration midnight commander\n"
    cp $HOME/repo/linux_stuff/config-files/mc.ext $HOME/.config/mc/mc.ext
    cp $HOME/repo/linux_stuff/config-files/darkcourses_green.ini $HOME/.local/share/mc/skins/
    cecho c "==========> Configuration mutt\n"
    cp $HOME/repo/linux_stuff/config-files/hide.muttrc $HOME/.muttrc
    cecho c "==========> Configuration rtorrent\n"
    cp ~/repo/linux_stuff/config-files/hide.rtorrent.rc ~/.rtorrent.rc

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-beepscripts-arch()
{
    cecho c "==========> Setting polish letters\n"
    sudo mkdir -p /etc/X11/xorg.conf.d
    sudo cp $HOME/repo/linux_stuff/config-files/vconsole.conf /etc/vconsole.conf
    sudo cp $HOME/repo/linux_stuff/config-files/10-evdev.conf /etc/X11/xorg.conf.d/10-evdev.conf
    cecho c "==========> Disabling beep sound\n"
    # Disable beep sound in console
    set bell-style none
    # Disable beep sound in X
    xset b off
    # Cleaning script 
    sudo cp $HOME/repo/linux_stuff/config-files/arch-clear /usr/bin/arch-clear
    sudo chmod +x /usr/bin/arch-clear
    # Mount scripts
    cecho c "==========> Copying mount scripts\n"
    sudo cp $HOME/repo/linux_stuff/config-files/m /usr/bin/
    sudo chmod +x /usr/bin/m
    sudo cp $HOME/repo/linux_stuff/config-files/um /usr/bin/
    sudo chmod +x /usr/bin/um
    cecho c "==========> Copying live-usb script\n"
    sudo cp $HOME/repo/linux_stuff/config-files/live-usb /usr/bin/
    sudo chmod +x /usr/bin/live-usb
    # cecho c "==========> Enabling touchpad\n"
    # sudo cp /repo/linux_stuff/config-files/50-synaptics.conf /etc/X11/xorg.conf.d/

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-lenovo-arch()
{
    cecho c "==========> Disabling beep sound\n"
    sudo rmmod pcspkr
    cecho c "==========> Update & upgrade system\n"
    sudo pacman -Syyu --noconfirm
    cecho c "==========> Setting wallpaper\n"
    mkdir -p $HOME/Obrazy
    cp $HOME/repo/linux_stuff/config-files/wallpaper.jpg $HOME/Obrazy/wallpaper.jpg
    feh --bg-scale $HOME/Obrazy/wallpaper.jpg

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-shell-arch()
{
    cecho c "==========> Choice shell: \n"
    cecho c "1) bash\n"
    cecho c "2) zsh\n"
    read c2

    if [ "$c2" -eq "1" ] ; then
        cecho c "==========> Installing bash and colordiff\n"
        sudo pacman -S bash colordiff
        cecho c "==========> Configuration bash\n"
        cp $HOME/repo/linux_stuff/config-files/hide.bashrc $HOME/.bashrc
        cecho c "==========> Making bash default shell\n"
        chsh -s /bin/bash
        cecho c "==========> Copying .bash_profile\n"
        sudo cp $HOME/repo/linux_stuff/config-files/hide.bash_profile $HOME/.bash_profile
    elif [ "$c2" -eq "2" ] ; then
        cecho c "==========> Installing zsh and colordiff\n"
        sudo pacman -S zsh -y
        cecho c "==========> Configuration zsh\n"
        cp $HOME/repo/linux_stuff/config-files/hide.zshrc $HOME/.zshrc
        cecho c "==========> Making zsh default shell\n"
        chsh -s /bin/zsh
    else
        cecho r "Bad number\n"
        read -p "Press any key..."
        menu-arch
    fi

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-pacman()
{
    cecho c "==========> Copying pacman.conf: \n"
    sudo cp $HOME/repo/linux_stuff/config-files/pacman.conf /etc/pacman.conf
    sudo pacman -Syyu

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-slim-arch()
{
    cecho c "==========> Installing slim\n"
    sudo pacman -S slim --noconfirm
    cecho c "==========> Copying slim.conf\n"
    sudo cp $HOME/repo/linux_stuff/config-files/slim.conf /etc/slim.conf
    cecho c "==========> Enabling slim service\n"
    sudo systemctl enable slim

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-grub-arch()
{
    cecho c "==========> Remaking grub file\n"
    sudo cp $HOME/repo/linux_stuff/config-files/grub /etc/default/grub
    sudo grub-mkconfig -o /boot/grub/grub.cfg

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-xinit-arch()
{
    cecho c "==========> Choice your DE\n"
    cecho c "1) i3\n"
    cecho c "2) lxde\n"
    cecho c "3) awesome\n"
    read c2

    if [ "$c2" -eq "1" ] ; then
        echo "setxkbmap pl &" > $HOME/.xinitrc
        echo "exec i3" >> $HOME/.xinitrc
    elif [ "$c2" -eq "2" ] ; then
        echo "setxkbmap pl &" > $HOME/.xinitrc
        echo "exec startlxde" >> $HOME/.xinitrc
    elif [ "$c2" -eq "3" ] ; then
        echo "setxkbmap pl &" > $HOME/.xinitrc
        echo "exec awesome" >> $HOME/.xinitrc
    else
        cecho r "Bad number\n"
    fi

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-vim-arch()
{
    #==============================================================
    # Plugin list:
    #	Pathogen
    #	Nerdtree
    #	Syntastic
    #	Tagbar / Taglist
    #	GitGutter
    #	Nerdcommenter
    # 	Vim-airline
    #	Auto-pairs
    # 	Supertab
    #	SnipMate
    #   indentLine
    #   SingleCompile
    #   Vim-commentary
    #	Gruvbox theme
    #==============================================================

    cecho c "==========> Installing vim depedencies\n"
    sudo pacman -S vim curl ctags ttf-inconsolata --noconfirm

    cecho c "==========> Making vim dirs\n"
    mkdir -p ~/tmp ~/.vim/autoload ~/.vim/bundle ~/.vim/colors ~/tmp/tagbar

    cecho c "==========> Pathogen\n"
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

    cecho c "==========> Nerdtree\n"
    cd ~/.vim/bundle && \
    git clone https://github.com/scrooloose/nerdtree.git

    cecho c "==========> Syntastic\n"
    cd ~/.vim/bundle && \
    git clone https://github.com/scrooloose/syntastic.git

    cecho c "==========> Taglist/Tagbar\n"
    cd ~/.vim/bundle && \
    git clone git://github.com/vim-scripts/taglist.vim.git
    #git clone https://github.com/vim-scripts/Tagbar.git

    cecho c "==========> Git-gutter\n"
    cd ~/.vim/bundle && \
    git clone git://github.com/airblade/vim-gitgutter.git

    cecho c "==========> Nerd-commenter\n"
    cd ~/.vim/bundle && \
    git clone https://github.com/scrooloose/nerdcommenter.git

    cecho c "==========> Vim-airline\n"
    cd ~/.vim/bundle && \
    git clone https://github.com/bling/vim-airline ~/.vim/bundle/vim-airline

    cecho c "==========> Auto-pairs\n"
    cd ~/.vim/bundle && \
    git clone git://github.com/jiangmiao/auto-pairs.git

    cecho c "==========> Supertab\n"
    git clone git://github.com/ervandew/supertab.git

    cecho c "==========> Snipmate\n"
    cd ~/.vim/bundle
    git clone https://github.com/tomtom/tlib_vim.git
    git clone https://github.com/MarcWeber/vim-addon-mw-utils.git
    git clone https://github.com/garbas/vim-snipmate.git
    git clone https://github.com/honza/vim-snippets.git

    cecho c "==========> Indent-line\n"
    cd ~/.vim/bundle
    git clone https://github.com/Yggdroot/indentLine.git

    cecho c "==========> Single-compile\n"
    cd ~/.vim/bundle
    git clone https://github.com/xuhdev/SingleCompile.git

    cecho c "==========> Vim-commentary\n"
    cd ~/.vim/bundle
    git clone https://github.com/tpope/vim-commentary.git

    #cecho c "==========> Gruvbox theme\n"
    #mkdir -p ~/tmp
    #cd ~/tmp && \
    #git clone https://github.com/morhetz/gruvbox.git
    #mv ~/tmp/gruvbox/autoload/gruvbox.vim ~/.vim/autoload/gruvbox.vim
    #mv ~/tmp/gruvbox/colors/gruvbox.vim ~/.vim/colors/gruvbox.vim
    #rm -rf ~/tmp/gruvbox

    #cecho c "==========> Sorcerer theme\n"
    #cd ~/tmp && \
    #git clone https://github.com/adlawson/vim-sorcerer.git
    #mv ~/tmp/vim-sorcerer/colors/sorcerer.vim ~/.vim/colors
    #rm -rf ~/tmp/vim-sorcerer

    cecho c "==========> Jellybeans theme\n"
    cd ~/tmp && \
    git clone https://github.com/nanotech/jellybeans.vim.git
    mv ~/tmp/jellybeans.vim/colors/jellybeans.vim ~/.vim/colors/jellybeans.vim
    rm -rf ~/tmp/jellybeans.vim

    cecho c "==========> Copying .vimrc\n"
    cp ~/repo/linux_stuff/vim/hide.vimrc ~/.vimrc
    
    cecho c "==========> Copying own snippets\n"
    cp $HOME/repo/linux_stuff/vim/cpp.snippets $HOME/.vim/bundle/vim-snippets/snippets/
    cp $HOME/repo/linux_stuff/vim/c.snippets $HOME/.vim/bundle/vim-snippets/snippets/
    cp $HOME/repo/linux_stuff/vim/python.snippets $HOME/.vim/bundle/vim-snippets/snippets/

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-conky-arch()
{
    cecho c "==========> Installing conky\n"
    sudo pacman -S conky --noconfirm

    cecho c "==========> Copying .conkyrc\n"
    cp ~/repo/linux_stuff/conky/conky.conf ~/.conkyrc

    cecho c "==========> Copying fonts\n"
    sudo cp ~/repo/linux_stuff/conky/hoog0555_cyr2.ttf /usr/share/fonts/truetype/ 

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-de-arch()
{
    cecho c "==========> Choice your DE\n"
    cecho c "1) i3\n"
    cecho c "2) lxde-core\n"
    cecho c "3) awesome\n"
    read c2

    if [ "$c2" -eq "1" ] ; then
        cecho c "==========> Creating dirs\n"
        mkdir -p $HOME/.i3
        mkdir -p $HOME/Obrazy
        cecho c "==========> Installing i3 depedencies\n"
        sudo pacman -S i3 dmenu lxrandr pavucontrol lxterminal xorg xinit feh xf86-input-synaptics lib32-mesa-libgl xorg-server xf86-input-evdev xf86-input-mouse xf86-input-keyboard --noconfirm

        cecho c "==========> Copying config files\n"
        cp ~/repo/linux_stuff/i3/hide.i3status.conf ~/.i3status.conf
        cp ~/repo/linux_stuff/i3/config ~/.i3/config
        cp ~/repo/linux_stuff/i3/i3lock-arch.png ~/Obrazy/i3lock-arch.png
    elif [ "$c2" -eq "2" ] ; then
        cecho c "==========> Installing lxde-core depedencies\n"
        sudo pacman -S xserver-xorg xorg xinit lxde-core lxterminal pavucontrol xf86-input-synaptics lib32-mesa-libgl xf86-input-evdev xf86-input-mouse xf86-input-keyboard --noconfirm
    elif [ "$c2" -eq "3" ] ; then
        cecho c "==========> Installing awesome depedencies\n"
        sudo pacman -S xserver-xorg xorg xinit awesome lxterminal pavucontrol xf86-input-synaptics lib32-mesa-libgl xf86-input-evdev xf86-input-mouse xf86-input-keyboard --noconfirm
    else
        cecho r "Bad number\n"
    fi

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-ssh-arch()
{
    cecho c "==========> Installing SSH server\n"
    sudo pacman -S openssh --noconfirm
    sudo iptables -I INPUT -p tcp --dport 22 -j ACCEPT
    cecho y "==========> To connect: ssh user@ip-number\n"
    cecho y "==========> To run GUI apps: export DISPLAY=:0\n"

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-livestreamer-arch()
{
    cecho c "==========> Installing livestreamer\n"
    sudo pacman -S livestreamer --noconfirm

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-youtubedl-arch()
{
    cecho c "==========> Installing youtube-dl\n"
    sudo pacman -S youtube-dl --noconfirm

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-steam-arch()
{
    cecho c "==========> Installing steam depedencies\n"
    sudo pacman -S curl dbus desktop-file-utils freetype2 gdk-pixbuf2 hicolor-icon-theme lib32-gcc-libs lib32-mesa-libgl lib32-libx11 ttf-font zenity lib32-alsa-plugins lib32-mesa-dri  
    cecho c "==========> Installing steam\n"
    sudo pacman -S steam

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-virtualbox-arch()
{
    cecho c "==========> Installing virtualbox depedencies\n"
    sudo pacman -S virtualbox linux-headers virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-modules --noconfirm
    cecho c "==========> Adding modules\n"
    sudo modprobe vboxdrv
    sudo modprobe -a vboxguest vboxsf vboxvideo
    cecho c "==========> Adding michal to VB group\n"
    sudo gpasswd -a michal vboxusers

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-irssi-arch()
{
    cecho c "==========> Creating dirs\n"
    mkdir $HOME/.irssi
    cecho c "==========> Installing irssi\n"
    sudo pacman -S irssi --noconfirm
    cecho c "==========> Copying config files\n"
    cp $HOME/repo/linux_stuff/config-files/config-irssi.rc $HOME/.irssi/config
    cp $HOME/repo/linux_stuff/config-files/cyanic.theme $HOME/.irssi/

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-vimb-arch()
{
    mkdir -p $HOME/.config/vimb
    cecho c "==========> Installing depedencies for vimb...\n"
    sudo pacman -S libsoup webkitgtk2 --noconfirm
    cd $HOME/tmp
    git clone https://github.com/fanglingsu/vimb.git
    cd $HOME/tmp/vimb
    make clean
    sudo make install
    cp $HOME/repo/linux_stuff/config-files/config-vimb.rc $HOME/.config/vimb/config
    cp $HOME/repo/linux_stuff/config-files/bookmark-vimb.rc $HOME/.config/vimb/bookmark

    cecho c "Done\n"
    read -p "Press any key..."
    clear
}
fun-all-arch()
{
    clear
    cecho r "==========> Step: 1/20\n"
    fun-pacman
    cecho r "==========> Step: 2/20\n"
    fun-git-arch
    cecho r "==========> Step: 3/20\n"
    fun-dirs-arch
    cecho r "==========> Step: 4/20\n"
    fun-packages-arch
    cecho r "==========> Step: 5/20\n"
    fun-textapps-arch
    cecho r "==========> Step: 6/20\n"
    fun-beepscripts-arch
    cecho r "==========> Step: 7/20\n"
    fun-lenovo-arch
    cecho r "==========> Step: 8/20\n"
    fun-shell-arch
    cecho r "==========> Step: 9/20\n"
    fun-slim-arch
    cecho r "==========> Step: 10/20\n"
    fun-grub-arch
    cecho r "==========> Step: 11/20\n"
    fun-xinit-arch
    cecho r "==========> Step: 12/20\n"
    fun-vim-arch
    cecho r "==========> Step: 13/20\n"
    fun-de-arch
    cecho r "==========> Step: 14/20\n"
    fun-ssh-arch
    cecho r "==========> Step: 15/20\n"
    fun-livestreamer-arch
    cecho r "==========> Step: 16/20\n"
    fun-youtubedl-arch
    cecho r "==========> Step: 17/20\n"
    fun-steam-arch
    cecho r "==========> Step: 18/20\n"
    fun-virtualbox-arch
    cecho r "==========> Step: 19/20\n"
    fun-irssi-arch
    cecho r "==========> Step: 20/20\n"
    fun-vimb-arch
}

menu

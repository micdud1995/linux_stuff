#!/bin/bash

# run as a user!
# configure visudo before

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

color0=g
color1=g
color2=r
color3=gr
color4=r

menu() {
    clear
    cecho $color0  "=================================== CONFIG ======================================\n"
    cecho $color1 "1) Install - git\t\t\t\t"
    cecho $color2 "10) Configure - vim\n"
    cecho $color1 "2) Create dirs and clone repo\t\t\t"
    cecho $color2 "11) Configure - conky\n"
    cecho $color1 "3) Install - basic packages\t\t\t"
    cecho $color2 "12) Configure - i3\n"
    cecho $color1 "4) Configure moc, mc, zsh, mutt, rtorrent\t"
    cecho $color2 "13) Install - SSH \n"
    cecho $color1 "5) Copy own scripts and disable beep sound\t"
    cecho $color2 "14) Install - livestreamer [source]\n"
    cecho $color1 "6) Configure - Lenovo G580\t\t\t"
    cecho $color2 "15) Install - youtube-dl [source]\n"
    cecho $color3 "7) Configure - slim \t\t\t\t"
    cecho $color2 "16) Install - virtualbox\n"
    cecho $color3 "8) Configure - grub\t\t\t\t"
    cecho $color2 "17) Install - irssi\n"
    cecho $color3 "9) Configure - .xinitrc\t\t\t\t"
    cecho $color2 "18) Install - vimb [source]\n"
    cecho $color4 "99) Exit\n"
    cecho $color0 "=================================================================================\n"
    read c

    if [ "$c" -eq "1" ] ; then
        # Installing git
        cecho c "=========================> Git installing\n"
        sudo aptitude install git -y
        cecho c "=========================> Setting user name\n"
        git config --global user.name "Michal Dudek"
        cecho c "=========================> Setting user e-mail\n"
        git config --global user.email michal.dudek1995@gmail.com
        cecho c "Done\n"
        read -p "Press any key..."
        menu
    elif [ "$c" -eq "2" ] ; then
        cecho c "=========================> Creating dirs...\n"
        mkdir -p $HOME/repo
        mkdir -p $HOME/tmp
        # Creating repo dir and cloning repository
        if [ ! -d $HOME/repo/linux_stuff ]; then
            cd $HOME/repo
            cecho c "=========================> Cloning repository...\n"
            git clone https://github.com/micdud1995/linux_stuff.git
        else
            cecho c "=========================> $HOME/repo/linux_stuff exists already...\n"
        fi

        cecho c "Done\n"
        read -p "Press any key..."
        menu
    elif [ "$c" -eq "3" ] ; then
        # Basic packages
        cecho c "=========================> Installing basic packages...\n"
        sudo aptitude install mc moc zsh mutt tree scrot nitrogen git alsa-utils libncurses5-dev zathura mirage xserver-xorg-input-synaptics mpv lxrandr pavucontrol xbacklight lxterminal xserver-xorg xinit rtorrent pinta irssi -y

        cecho c "Done\n"
        read -p "Press any key..."
        menu
    elif [ "$c" -eq "4" ] ; then
        cecho c "=========================> Creating dirs\n"
        mkdir -p $HOME/.config/mc
        mkdir -p $HOME/.moc
        mkdir -p $HOME/.local/share/mc/skins
        mkdir -p $HOME/.rtorrent
        cecho c "=========================> Installing packages\n"
        sudo aptitude install moc mc zsh mutt rtorrent -y
        cecho c "=========================> Configuration moc player\n"
        cp $HOME/repo/linux_stuff/config-files/config_moc $HOME/.moc/config
        cecho c "=========================> Configuration midnight commander\n"
        cp $HOME/repo/linux_stuff/config-files/mc.ext $HOME/.config/mc/mc.ext
        cp $HOME/repo/linux_stuff/config-files/darkcourses_green.ini $HOME/.local/share/mc/skins/
        cecho c "=========================> Configuration zsh\n"
        cp $HOME/repo/linux_stuff/config-files/hide.zshrc $HOME/.zshrc
        chsh -s /bin/zsh 	# makes zsh default shell
        cecho c "=========================> Configuration mutt\n"
        cp $HOME/repo/linux_stuff/config-files/hide.muttrc $HOME/.muttrc
        cecho c "=========================> Configuration rtorrent\n"
        cp ~/repo/linux_stuff/config-files/hide.rtorrent.rc ~/.rtorrent.rc
        cecho c "Done\n"
        read -p "Press any key..."
        menu
    elif [ "$c" -eq "5" ] ; then
        cecho c "=========================> Disabling beep sound\n"
        # Disable beep sound in console
        set bell-style none
        # Disable beep sound in X
        xset b off
        # Mount scripts
        cecho c "=========================> Copying mount scripts\n"
        sudo cp $HOME/repo/linux_stuff/config-files/m /usr/bin/
        sudo chmod +x /usr/bin/m
        sudo cp $HOME/repo/linux_stuff/config-files/um /usr/bin/
        sudo chmod +x /usr/bin/um
        cecho c "=========================> Copying live-usb script\n"
        sudo cp $HOME/repo/linux_stuff/config-files/live-usb /usr/bin/
        sudo chmod +x /usr/bin/live-usb

        cecho c "Done\n"
        read -p "Press any key..."
        menu
    elif [ "$c" -eq "6" ] ; then
        cecho c "=========================> Updating /etc/apt/sources.list\n"
        sudo cp $HOME/repo/linux_stuff/config-files/sources.list /etc/apt/sources.list
        cecho c "=========================> Update system\n"
        sudo aptitude update
        cecho c "=========================> Upgrade system\n"
        sudo aptitude upgrade -y
        cecho c "=========================> Enabling microphone\n"
        sudo cp $HOME/repo/linux_stuff/config-files/alsa-base.conf /etc/modprobe.d/alsa-base.conf
        cecho c "=========================> Enabling wifi\n"
        sudo aptitude install linux-headers-$(uname -r|sed 's,[^-]*-[^-]*-,,') broadcom-sta-dkms wicd
        sudo modprobe -r b44 b43 b43legacy ssb brcmsmac
        sudo modprobe wl
        sudo cp $HOME/repo/linux_stuff/config-files/interfaces /etc/network/interfaces
        sudo adduser michal netdev
        sudo /etc/init.d/dbus reload
        sudo /etc/init.d/wicd start
        wicd-client -n
        cecho c "=========================> Enabling touchpad\n"
        synclient TapButton1=1
        echo synclient TapButton1=1 >> $HOME/.xinitrc

        cecho c "Done\n"
        read -p "Press any key..."
        menu
    elif [ "$c" -eq "7" ] ; then
        cecho c "=========================> Installing slim\n"
        sudo aptitude install slim -y
        cecho c "=========================> Copying slim.conf\n"
        sudo cp $HOME/repo/linux_stuff/config-files/slim.conf /etc/slim.conf
        cecho c "=========================> Making slim default login manager\n"
        sudo dpkg-reconfigure slim

        cecho c "Done\n"
        read -p "Press any key..."
        menu
    elif [ "$c" -eq "8" ] ; then
        cecho c "=========================> Remaking grub file\n"
        sudo cp $HOME/repo/linux_stuff/config-files/grub /etc/default/grub
        sudo update-grub

        cecho c "Done\n"
        read -p "Press any key..."
        menu
    elif [ "$c" -eq "9" ] ; then
        cecho c "=========================> Choice your DE\n"
        cecho c "1) i3\n"
        cecho c "2) lxde\n"
        read c2

        if [ "$c2" -eq "1" ] ; then
            echo "setxkbmap pl &" > $HOME/.xinitrc
            echo "exec i3" >> $HOME/.xinitrc
        elif [ "$c2" -eq "2" ] ; then
            echo "setxkbmap pl &" > $HOME/.xinitrc
            echo "exec startlxde" >> $HOME/.xinitrc
        else
            cecho r "Bad number\n"
        fi

        cecho c "Done\n"
        read -p "Press any key..."
        menu

    elif [ "$c" -eq "10" ] ; then
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
        #   Rainbow parantheses
        #   Vim-commentary
        #	Gruvbox theme
        #==============================================================

        cecho c "=========================> Installing vim depedencies\n"
        sudo aptitude install vim curl exuberant-ctags fonts-inconsolata -y

        cecho c "=========================> Making vim dirs\n"
        mkdir -p ~/tmp ~/.vim/autoload ~/.vim/bundle ~/.vim/colors ~/tmp/tagbar

        cecho c "=========================> Pathogen\n"
        curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

        cecho c "=========================> Nerdtree\n"
        cd ~/.vim/bundle && \
        git clone https://github.com/scrooloose/nerdtree.git

        cecho c "=========================> Syntastic\n"
        cd ~/.vim/bundle && \
        git clone https://github.com/scrooloose/syntastic.git

        cecho c "=========================> Taglist/Tagbar\n"
        cd ~/.vim/bundle && \
        git clone git://github.com/vim-scripts/taglist.vim.git
        #git clone https://github.com/vim-scripts/Tagbar.git

        cecho c "=========================> Git-gutter\n"
        cd ~/.vim/bundle && \
        git clone git://github.com/airblade/vim-gitgutter.git

        cecho c "=========================> Nerd-commenter\n"
        cd ~/.vim/bundle && \
        git clone https://github.com/scrooloose/nerdcommenter.git

        cecho c "=========================> Vim-airline\n"
        cd ~/.vim/bundle && \
        git clone https://github.com/bling/vim-airline ~/.vim/bundle/vim-airline

        cecho c "=========================> Auto-pairs\n"
        cd ~/.vim/bundle && \
        git clone git://github.com/jiangmiao/auto-pairs.git

        cecho c "=========================> Supertab\n"
        git clone git://github.com/ervandew/supertab.git

        cecho c "=========================> Snipmate\n"
        cd ~/.vim/bundle
        git clone https://github.com/tomtom/tlib_vim.git
        git clone https://github.com/MarcWeber/vim-addon-mw-utils.git
        git clone https://github.com/garbas/vim-snipmate.git
        git clone https://github.com/honza/vim-snippets.git

        cecho c "=========================> Indent-line\n"
        cd ~/.vim/bundle
        git clone https://github.com/Yggdroot/indentLine.git

        cecho c "=========================> Single-compile\n"
        cd ~/.vim/bundle
        git clone https://github.com/xuhdev/SingleCompile.git

        cecho c "=========================> Rainbow paranthesis\n"
        cd ~/.vim/bundle
        git clone https://github.com/luochen1990/rainbow.git

        cecho c "=========================> Vim-commentary\n"
        cd ~/.vim/bundle
        git clone https://github.com/tpope/vim-commentary.git

        #cecho c "=========================> Gruvbox theme\n"
        #mkdir -p ~/tmp
        #cd ~/tmp && \
        #git clone https://github.com/morhetz/gruvbox.git
        #mv ~/tmp/gruvbox/autoload/gruvbox.vim ~/.vim/autoload/gruvbox.vim
        #mv ~/tmp/gruvbox/colors/gruvbox.vim ~/.vim/colors/gruvbox.vim
        #rm -rf ~/tmp/gruvbox

        #cecho c "=========================> Sorcerer theme\n"
        #cd ~/tmp && \
        #git clone https://github.com/adlawson/vim-sorcerer.git
        #mv ~/tmp/vim-sorcerer/colors/sorcerer.vim ~/.vim/colors
        #rm -rf ~/tmp/vim-sorcerer

        cecho c "=========================> Jellybeans theme\n"
        cd ~/tmp && \
        git clone https://github.com/nanotech/jellybeans.vim.git
        mv ~/tmp/jellybeans.vim/colors/jellybeans.vim ~/.vim/colors/jellybeans.vim
        rm -rf ~/tmp/jellybeans.vim

        cecho c "=========================> Copying .vimrc\n"
        cp ~/repo/linux_stuff/vim/hide.vimrc ~/.vimrc
        
        cecho c "=========================> Copying own snippets\n"
        cp $HOME/repo/linux_stuff/vim/cpp.snippets $HOME/.vim/bundle/vim-snippets/snippets/
        cp $HOME/repo/linux_stuff/vim/c.snippets $HOME/.vim/bundle/vim-snippets/snippets/
        cp $HOME/repo/linux_stuff/vim/python.snippets $HOME/.vim/bundle/vim-snippets/snippets/

        cecho c "Done\n"
        read -p "Press any key..."
        menu
    elif [ "$c" -eq "11" ] ; then
        cecho c "=========================> Installing conky\n"
        sudo aptitude install conky -y

        cecho c "=========================> Copying .conkyrc\n"
        cp ~/repo/linux_stuff/conky/conky.conf ~/.conkyrc

        cecho c "=========================> Copying fonts\n"
        sudo cp ~/repo/linux_stuff/conky/hoog0555_cyr2.ttf /usr/share/fonts/truetype/ 

        cecho c "Done\n"
        read -p "Press any key..."
        menu
    elif [ "$c" -eq "12" ] ; then
        cecho c "=========================> Creating dirs\n"
        mkdir -p $HOME/.i3
        mkdir -p $HOME/Obrazy
        cecho c "=========================> Installing i3 depedencies\n"
        sudo aptitude install i3 dmenu lxrandr pavucontrol xbacklight lxterminal xserver-xorg xinit nitrogen -y

        cecho c "=========================> Copying config files\n"
        cp ~/repo/linux_stuff/i3/hide.i3status.conf ~/.i3status.conf
        cp ~/repo/linux_stuff/i3/config ~/.i3/config
        cp ~/repo/linux_stuff/i3/i3lock-deb.png ~/Obrazy/i3lock-deb.png

        cecho c "Done\n"
        read -p "Press any key..."
        menu
    elif [ "$c" -eq "13" ] ; then
        cecho c "=========================> Installing SSH server\n"
        sudo aptitude install openssh-server
        sudo iptables -I INPUT -p tcp --dport 22 -j ACCEPT
        cecho c "=========================> Restarting SSH server\n"
        sudo /etc/init.d/ssh restart
        # Accepting running gui programs
        export DISPLAY=:0 
        cecho y "=========================> To connect: ssh user@ip-number\n"

        cecho c "Done\n"
        read -p "Press any key..."
        menu
    elif [ "$c" -eq "14" ] ; then
        cecho c "=========================> Installing depedencies\n"
        sudo aptitude install python python-requests python-setuptools python-singledispatch -y
        cd $HOME/tmp
        cecho c "=========================> Cloning repository\n"
        git clone https://github.com/chrippa/livestreamer.git
        cd $HOME/tmp/livestreamer
        cecho c "=========================> Installing\n"
        sudo python setup.py install
        cecho c "=========================> Cleaning tmp files\n"
        rm -rf $HOME/tmp/livestreamer

        cecho c "Done\n"
        read -p "Press any key..."
        menu
    elif [ "$c" -eq "15" ] ; then
        cecho c "=========================> Downloading youtube-dl from webpage\n"
        sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
        cecho c "=========================> Making file executable\n"
        sudo chmod a+rx /usr/local/bin/youtube-dl

        cecho c "Done\n"
        read -p "Press any key..."
        menu
    elif [ "$c" -eq "15" ] ; then
        cecho c "=========================> Installing virtualbox depedencies\n"
        sudo aptitude install virtualbox dkms build-essential linux-headers-amd64 virtualbox-guest-x11 virtualbox-dkms virtualbox-guest-utils -y

        cecho c "Done\n"
        read -p "Press any key..."
        menu
    elif [ "$c" -eq "17" ] ; then
        cecho c "=========================> Creating dirs\n"
        mkdir $HOME/.irssi
        cecho c "=========================> Installing irssi\n"
        sudo aptitude install irssi -y
        cecho c "=========================> Copying config files\n"
        cp $HOME/repo/linux_stuff/config-files/config-irssi.rc $HOME/.irssi/config
        cp $HOME/repo/linux_stuff/config-files/cyanic.theme $HOME/.irssi/

        cecho c "Done\n"
        read -p "Press any key..."
        menu
    elif [ "$c" -eq "18" ] ; then
        # Vimb web browser
        mkdir -p $HOME/.config/vimb
        cecho c "=========================> Installing depedencies for vimb...\n"
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
        menu
    elif [ "$c" -eq "99" ] ; then
        clear
        exit
    else
        cecho r "Bad number\n"
        read -p "Press any key..."
        menu
    fi
}

menu

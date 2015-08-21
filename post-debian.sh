#!/bin/bash

info(){
    whiptail --title "Debian config" --msgbox "At first:\n1. Install sudo\n2. adduser foo sudo\n3. run visudo" 20 60
}

select_system() {
	OS=$(whiptail --nocancel --title "Select OS" --menu "Select your OS" 20 60 10 \
	"Debian_8" "" 3>&1 1>&2 2>&3)

    case "$OS" in
        "Debian_8")
            repo_dirs
        ;;
        "*")
            whiptail --title "Debian config" --msgbox "Wrong OS" 20 60
            main_menu
        ;;
    esac
}

repo_dirs() {
    if (whiptail --title "Cloning repository" --yesno "Do you want to clone repo?\nThere are important config files" 20 60) then
        mkdir -p $HOME/repo
        mkdir -p $HOME/tmp
        # Creating repo dir and cloning repository
        if [ ! -d $HOME/repo/linux_stuff ]; then
            cd $HOME/repo
            sudo aptitude install git -y
            git clone https://github.com/micdud1995/linux_stuff.git
        else
            whiptail --title "Debian config" --msgbox "$HOME/repo/linux_stuff exists already" 20 60
        fi
        config_sources
    else
        config_sources
    fi
}

config_sources() {
    if (whiptail --title "Updating sources" --yesno "Do you want to update sources.list file?" 20 60) then
        VERSION=$(whiptail --nocancel --title "Edit sources.list" --menu "Select your OS" 20 60 10 \
        "Stable"    "" \
        "Testing"   "" \
        "Sid"       "" 3>&1 1>&2 2>&3)

        case "$VERSION" in
            "Stable")
                sudo sh -c "echo '### STABLE ###' > /etc/apt/sources.list"
                sudo sh -c "echo 'deb http://ftp.pl.debian.org/debian/ stable main contrib non-free' >> /etc/apt/sources.list"
                sudo sh -c "echo 'deb-src http://ftp.pl.debian.org/debian/ stable main contrib non-free' >> /etc/apt/sources.list"
                sudo sh -c "echo >> /etc/apt/sources.list"
                sudo sh -c "echo 'deb http://security.debian.org/ stable/updates main contrib non-free' >> /etc/apt/sources.list"
                sudo sh -c "echo 'deb-src http://security.debian.org/ stable/updates main contrib non-free' >> /etc/apt/sources.list"
                sudo sh -c "echo >> /etc/apt/sources.list"
                sudo sh -c "echo 'deb http://ftp.pl.debian.org/debian/ jessie-updates main' >> /etc/apt/sources.list"
                sudo sh -c "echo 'deb-src http://ftp.pl.debian.org/debian/ jessie-updates main' >> /etc/apt/sources.list"
            ;;
            "Testing")
                sudo sh -c "echo '### TESTING ###' > /etc/apt/sources.list"
                sudo sh -c "echo 'deb http://ftp.pl.debian.org/debian/ testing main contrib non-free' >> /etc/apt/sources.list"
                sudo sh -c "echo 'deb-src http://ftp.pl.debian.org/debian/ testing main contrib non-free' >> /etc/apt/sources.list"
                sudo sh -c "echo >> /etc/apt/sources.list"
                sudo sh -c "echo 'deb http://security.debian.org/ testing/updates main contrib non-free' >> /etc/apt/sources.list"
                sudo sh -c "echo 'deb-src http://security.debian.org/ testing/updates main contrib non-free' >> /etc/apt/sources.list"
            ;;
            "Sid")
                sudo sh -c "echo '### UNSTABLE ###' > /etc/apt/sources.list"
                sudo sh -c "echo 'deb http://ftp.pl.debian.org/debian/ unstable main contrib non-free' >> /etc/apt/sources.list"
                sudo sh -c "echo 'deb-src http://ftp.pl.debian.org/debian/ unstable main contrib non-free' >> /etc/apt/sources.list"
                sudo sh -c "echo >> /etc/apt/sources.list"
                sudo sh -c "echo 'deb http://security.debian.org/ unstable/updates main contrib non-free' >> /etc/apt/sources.list"
                sudo sh -c "echo 'deb-src http://security.debian.org/ unstable/updates main contrib non-free' >> /etc/apt/sources.list"
            ;;
            "*")
                whiptail --title "Debian config" --msgbox "Wrong version" 20 60
                main_menu
            ;;
        esac

        sudo aptitude update
        sudo aptitude upgrade -y
    fi

    config_shell
}

config_shell() {
    if (whiptail --title "Shell" --yesno "Do you want to config shell?" 20 60) then
        SHELL=$(whiptail --nocancel --title "Select shell" --menu "Select your shell:" 20 60 10 \
        "Bash"  "" \
        "Zsh"   "" 3>&1 1>&2 2>&3)

        case "$SHELL" in
            "Bash")
                sudo aptitude install colordiff bash -y
                cp $HOME/repo/linux_stuff/config-files/hide.bashrc $HOME/.bashrc
                chsh -s /bin/bash
            ;;
            "Zsh")
                sudo aptitude install colordiff zsh -y
                cp $HOME/repo/linux_stuff/config-files/hide.zshrc $HOME/.zshrc
                chsh -s /bin/zsh
            ;;
        esac
    fi

    config_gui
}

config_gui() {
    if (whiptail --title "Debian config" --yesno "Install graphics drivers now? \nDrivers for NVIDIA, AMD, Intel, and Virtual Box guests" 20 60) then
        GPU=$(whiptail --title "Debian config" --menu "Select your GPU" 20 60 10 \
            "AMD"     "AMD/ATI Graphics" \
            "Intel"   "Intel Graphics" \
            "Nvidia"  "NVIDIA Graphics" \
            "VBOX"    "VirtualBox Guest" 3>&1 1>&2 2>&3)

        case "$GPU" in
            "AMD")
                whiptail --title "Error" --msgbox "Not supported yet" 20 60
                main_menu
            ;;
            "Intel")
                sudo aptitude install xserver-xorg-video-intel -y
                main_menu
            ;;
            "Nvidia")
                whiptail --title "Error" --msgbox "Not supported yet" 20 60
                main_menu
            ;;
            "VBOX")
                sudo aptitude install dkms build-essential linux-headers-amd64 virtualbox-guest-x11 virtualbox-dkms virtualbox-guest-utils -y
                main_menu
            ;;
        esac
    fi

    if (whiptail --title "Debian config" --yesno "Would you like to install a desktop environment or window manager?" 20 60) then
        DE=$(whiptail --title  "Debian config" --menu "Select environment:" 20 60 10 \
        "i3"            "i3 tiling WM" \
        "lxde-core"     "fast DE"   3>&1 1>&2 2>&3)

        case "$DE" in
            "i3")
                mkdir -p $HOME/.i3
                mkdir -p $HOME/Obrazy

                sudo aptitude install i3 dmenu -y

                cp ~/repo/linux_stuff/i3/hide.i3status.conf ~/.i3status.conf
                cp ~/repo/linux_stuff/i3/config ~/.i3/config
                cp ~/repo/linux_stuff/i3/i3lock-deb.png ~/Obrazy/i3lock-deb.png

                echo "exec i3" > ~/.xinitrc
            ;;
            "lxde-core")
                sudo aptitude install lxde-core -y

                echo "startlxde" > ~/.xinitrc
            ;;
        esac
    fi

    config_packages
}

config_packages() {
    if (whiptail --title "Debian config" --yesno "Would you like to install some common software?" 20 60) then
        software=$(whiptail --title "Additional software" --checklist "Choose your desired software \nUse spacebar to check/uncheck \npress enter when finished" 20 60 14 \
            "alsa-utils"                    "Sound" ON \
            "apache"  	                    "Web Server" OFF \
            "bash"                          "Shell" ON \
            "conky"                         "System Info" OFF \
            "feh"                           "Image Viewer" ON \
            "htop"                          "Process Info" ON \
            "irssi"                         "IRC Client" ON \
            "iceweasel"                     "Web Browser" OFF\
            "libncurses5-dev"               "ncurses" ON \
            "livestreamer"                  "Stream Tool" ON \
            "lxrandr"                       "Output manager" ON \
            "lxterminal"                    "Light terminal" ON \
            "lynx"                          "Web Browser" ON \
            "mc"                            "Midnight Commander" ON \
            "mirage"                        "Image Viewer" ON \
            "moc"                           "Music Player" ON \
            "mpv"                           "Video Player" ON \
            "mutt"                          "Mail Client" ON \
            "openssh"                       "Secure Shell" ON \
            "pavucontrol"                   "Sound output" ON \
            "pinta"                         "Image Editor" ON \
            "rtorrent"                      "Torrent Client" ON \
            "screenfetch"                   "System Info" ON \
            "scrot"                         "Screenshots" ON \
            "steam"                         "Steam Client" ON \
            "tree"                          "Tree of dirs" ON \
            "ufw"                           "Firewall" OFF \
            "vim" 	  	                    "Text Editor" ON \
            "vimb"                          "Web Browser" ON \
            "virtualbox"                    "Virtual Machines" ON \
            "xbacklight"                    "Screen brightness" ON \
            "xorg" 	  	                    "X Server" ON \
            "xserver-xorg-input-synaptics"  "Touchpad" ON \
            "youtube-dl"                    "YT Download" ON \
            "zathura"                       "PDF Viewer" ON \
            "zsh"     	                    "The Z shell" OFF 3>&1 1>&2 2>&3)

        download=$(echo "$software" | sed 's/\"//g')
        sudo aptitude install $download -y

        if [[ $download == *"conky"* ]] ; then
            sudo aptitude install conky -y
            cp ~/repo/linux_stuff/conky/conky.conf ~/.conkyrc
            sudo cp ~/repo/linux_stuff/conky/hoog0555_cyr2.ttf /usr/share/fonts/truetype/ 
        fi

        if [[ $download == *"git"* ]] ; then
            sudo aptitude install git -y
            name=$(whiptail --nocancel --inputbox "Set git username:" 20 60 "Michał Dudek" 3>&1 1>&2 2>&3)
            git config --global user.name "$name"
            mail=$(whiptail --nocancel --inputbox "Set git usermail:" 20 60 "michal.dudek1995@gmail.com" 3>&1 1>&2 2>&3)
            git config --global user.email $mail
        fi

        if [[ $download == *"openssh"* ]] ; then
            sudo aptitude install openssh-server -y
            sudo iptables -I INPUT -p tcp --dport 22 -j ACCEPT
            sudo /etc/init.d/ssh restart
            export DISPLAY=:0
        fi

        if [[ $download == *"mc"* ]] ; then
            mkdir -p $HOME/.config/mc
            mkdir -p $HOME/.local/share/mc/skins
            cp $HOME/repo/linux_stuff/config-files/mc.ext $HOME/.config/mc/mc.ext
            cp $HOME/repo/linux_stuff/config-files/darkcourses_green.ini $HOME/.local/share/mc/skins/
        fi

        if [[ $download == *"moc"* ]] ; then
            mkdir -p $HOME/.moc
            cp $HOME/repo/linux_stuff/config-files/config_moc $HOME/.moc/config
        fi
        
        if [[ $download == *"mutt"* ]] ; then
            cp $HOME/repo/linux_stuff/config-files/hide.muttrc $HOME/.muttrc
        fi

        if [[ $download == *"irssi"* ]] ; then
            mkdir $HOME/.irssi
            cp $HOME/repo/linux_stuff/config-files/config-irssi.rc $HOME/.irssi/config
            cp $HOME/repo/linux_stuff/config-files/cyanic.theme $HOME/.irssi/
        fi

        if [[ $download == *"irssi"* ]] ; then
            mkdir -p $HOME/.rtorrent
            cp ~/repo/linux_stuff/config-files/hide.rtorrent.rc ~/.rtorrent.rc
        fi

        if [[ $download == *"virtualbox"* ]] ; then
            sudo aptitude install dkms build-essential linux-headers-amd64 virtualbox-guest-x11 virtualbox-dkms virtualbox-guest-utils -y
        fi

        if [[ $download == *"livestreamer"* ]] ; then
            sudo aptitude install python python-requests python-setuptools python-singledispatch -y
            cd $HOME/tmp
            git clone https://github.com/chrippa/livestreamer.git
            cd $HOME/tmp/livestreamer
            sudo python setup.py install
            sudo rm -rf $HOME/tmp/livestreamer
        fi

        if [[ $download == *"youtube-dl"* ]] ; then
            sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
            sudo chmod a+rx /usr/local/bin/youtube-dl
        fi

        if [[ $download == *"vimb"* ]] ; then
            mkdir -p $HOME/tmp
            mkdir -p $HOME/tmp/vimb
            mkdir -p $HOME/.config/vimb
            sudo aptitude install libsoup2.4-dev libwebkit-dev libgtk-3-dev libwebkitgtk-3.0-dev -y
            cd $HOME/tmp
            git clone https://github.com/fanglingsu/vimb.git
            cd $HOME/tmp/vimb
            make clean
            sudo make install
            cp $HOME/repo/linux_stuff/config-files/config-vimb.rc $HOME/.config/vimb/config
            cp $HOME/repo/linux_stuff/config-files/bookmark-vimb.rc $HOME/.config/vimb/bookmark
        fi

        if [[ $download == *"steam"* ]] ; then
            mkdir -p $HOME/tmp
            sudo aptitude install curl zenity -y
            wget https://steamcdn-a.akamaihd.net/client/installer/steam.deb -O $HOME/tmp/steam.deb
            sudo dpkg -i $HOME/tmp/steam.deb
        fi

        if [[ $download == *"vim"* ]] ; then
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

            sudo aptitude install vim curl exuberant-ctags fonts-inconsolata -y

            # Making dirs
            mkdir -p ~/tmp ~/.vim/autoload ~/.vim/bundle ~/.vim/colors ~/tmp/tagbar

            # Pathogen
            curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

            # Nerdtree
            cd ~/.vim/bundle && \
            git clone https://github.com/scrooloose/nerdtree.git

            # Syntastic
            cd ~/.vim/bundle && \
            git clone https://github.com/scrooloose/syntastic.git

            # Taglist/Tagbar
            cd ~/.vim/bundle && \
            git clone git://github.com/vim-scripts/taglist.vim.git
            #git clone https://github.com/vim-scripts/Tagbar.git

            # Git-gutter
            cd ~/.vim/bundle && \
            git clone git://github.com/airblade/vim-gitgutter.git

            # Nerd-commenter
            cd ~/.vim/bundle && \
            git clone https://github.com/scrooloose/nerdcommenter.git

            # Vim-airline
            cd ~/.vim/bundle && \
            git clone https://github.com/bling/vim-airline ~/.vim/bundle/vim-airline

            # Auto-pairs
            cd ~/.vim/bundle && \
            git clone git://github.com/jiangmiao/auto-pairs.git

            # Supertab
            git clone git://github.com/ervandew/supertab.git

            # Snipmate
            cd ~/.vim/bundle
            git clone https://github.com/tomtom/tlib_vim.git
            git clone https://github.com/MarcWeber/vim-addon-mw-utils.git
            git clone https://github.com/garbas/vim-snipmate.git
            git clone https://github.com/honza/vim-snippets.git

            # Indent-line
            cd ~/.vim/bundle
            git clone https://github.com/Yggdroot/indentLine.git

            # Single-compile
            cd ~/.vim/bundle
            git clone https://github.com/xuhdev/SingleCompile.git

            # Vim-commentary
            cd ~/.vim/bundle
            git clone https://github.com/tpope/vim-commentary.git

            # Gruvbox theme
            #mkdir -p ~/tmp
            #cd ~/tmp && \
            #git clone https://github.com/morhetz/gruvbox.git
            #mv ~/tmp/gruvbox/autoload/gruvbox.vim ~/.vim/autoload/gruvbox.vim
            #mv ~/tmp/gruvbox/colors/gruvbox.vim ~/.vim/colors/gruvbox.vim
            #rm -rf ~/tmp/gruvbox

            # Sorcerer theme
            #cd ~/tmp && \
            #git clone https://github.com/adlawson/vim-sorcerer.git
            #mv ~/tmp/vim-sorcerer/colors/sorcerer.vim ~/.vim/colors
            #rm -rf ~/tmp/vim-sorcerer

            # Jellybeans theme
            cd ~/tmp && \
            git clone https://github.com/nanotech/jellybeans.vim.git
            mv ~/tmp/jellybeans.vim/colors/jellybeans.vim ~/.vim/colors/jellybeans.vim
            rm -rf ~/tmp/jellybeans.vim

            # Copying .vimrc
            cp ~/repo/linux_stuff/vim/hide.vimrc ~/.vimrc
            
            # Copying snippets
            cp $HOME/repo/linux_stuff/vim/cpp.snippets $HOME/.vim/bundle/vim-snippets/snippets/
            cp $HOME/repo/linux_stuff/vim/c.snippets $HOME/.vim/bundle/vim-snippets/snippets/
            cp $HOME/repo/linux_stuff/vim/python.snippets $HOME/.vim/bundle/vim-snippets/snippets/
        fi
    fi

    config_scripts
}

config_scripts() {
    if (whiptail --title "Scripts" --yesno "Would you like to copy useful scripts?" 20 60) then
        scripts=$(whiptail --title "Additional scripts" --checklist "Choose your desired scripts\nUse spacebar to check/uncheck \npress enter when finished" 20 60 10 \
            "m"                    "Mount script" ON \
            "um"                    "Umount script" ON \
            "live-usb"     	        "Live-USB script" ON 3>&1 1>&2 2>&3)

        if [[ $scripts == *"m"* ]] ; then
            sudo cp $HOME/repo/linux_stuff/config-files/m /usr/bin/
            sudo chmod +x /usr/bin/m
        fi

        if [[ $scripts == *"um"* ]] ; then
            sudo cp $HOME/repo/linux_stuff/config-files/um /usr/bin/
            sudo chmod +x /usr/bin/um
        fi

        if [[ $scripts == *"live-usb"* ]] ; then
            sudo cp $HOME/repo/linux_stuff/config-files/live-usb /usr/bin/
            sudo chmod +x /usr/bin/live-usb
        fi
    fi 

    config_beep
}

config_beep() {
    if (whiptail --title "Beep sound" --yesno "Would you disable beep sound in your system?" 20 60) then
        sudo rmmod pcspkr
        sudo sh -c "echo 'blacklist pcspkr' > /etc/modprobe.d/blacklist"
    fi

    config_laptop
}

config_laptop() {
    if (whiptail --title "Additional settings" --yesno "Configure computer options?" 20 60) then
        scripts=$(whiptail --title "Additional scripts" --checklist "Choose your desired scripts\nUse spacebar to check/uncheck \npress enter when finished" 20 60 10 \
            "Wallpaper"     "Set wallpaper" ON \
            "Touchpad"      "Enable touchpad" ON \
            "WiFi"          "Enable Lenovo G580 net. card" ON \
            "Microphone"    "Enable Lenovo G580 microphone" ON \
            "Lid"     	    "Don't suspend laptop" ON 3>&1 1>&2 2>&3)

        if [[ $scripts == *"Wallpaper"* ]] ; then
            sudo aptitude install feh
            mkdir -p $HOME/Obrazy
            cp $HOME/repo/linux_stuff/config-files/wallpaper.jpg $HOME/Obrazy/wallpaper.jpg
            feh --bg-scale $HOME/Obrazy/wallpaper.jpg
        fi

        if [[ $scripts == *"Touchpad"* ]] ; then
            sudo cp $HOME/repo/linux_stuff/config-files/50-synaptics.conf /etc/X11/xorg.conf.d/
            echo synclient TapButton1=1 >> $HOME/.xinitrc
        fi

        if [[ $scripts == *"WiFi"* ]] ; then
            sudo aptitude install linux-headers-$(uname -r|sed 's,[^-]*-[^-]*-,,') broadcom-sta-dkms wicd
            sudo modprobe -r b44 b43 b43legacy ssb brcmsmac
            sudo modprobe wl
            sudo cp $HOME/repo/linux_stuff/config-files/interfaces /etc/network/interfaces
            sudo adduser michal netdev
            sudo /etc/init.d/dbus reload
            sudo /etc/init.d/wicd start
            wicd-client -n
        fi

        if [[ $scripts == *"WiFi"* ]] ; then
            sudo cp $HOME/repo/linux_stuff/config-files/alsa-base.conf /etc/modprobe.d/alsa-base.conf
        fi

        if [[ $scripts == *"Lid"* ]] ; then
            sudo cp $HOME/repo/linux_stuff/config-files/logind.conf /etc/systemd/logind.conf
        fi
    fi 

    whiptail --title "Debian config" --msgbox "System configured." 20 60
    exit
}

main_menu() {
	menu_item=$(whiptail --nocancel --title "Debian config" --menu "Menu Items:" 20 60 10 \
		"Select OS"             "-" \
		"Clone repo"            "-" \
		"Config sources"        "-" \
		"Config shell"          "-" \
		"Install GUI"           "-" \
		"Install packages"      "-" \
		"Copy scripts"          "-" \
		"Disable beep"          "-" \
		"Config laptop things"  "-" \
		"Configure Network"     "-" \
		"Exit Installer"        "-" 3>&1 1>&2 2>&3)

	case "$menu_item" in
        "Select OS")
            select_system
		;;
		"Clone repo")
            repo_dirs
		;;
		"Config sources")
            config_sources
		;;
		"Config shell")
            config_shell
		;;
    	"Install GUI") 
            config_gui
		;;
		"Install packages") 
            config_packages
		;;
		"Copy scripts")
            config_scripts
		;;
		"Disable beep")
            config_beep
		;;
		"Config laptop things")
            config_laptop
		;;
		"Reboot System") 
            sudo reboot
		;;
		"Exit Installer")
            whiptail --title "Debian config" --msgbox "System configured." 20 60
            exit
		;;
	esac
}

main_menu
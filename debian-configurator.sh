#!/bin/bash

#==============================================================================
# Title             debian-configurator.sh
# Description       This script will config installed Debian GNU/Linux system 
# Author            Michał Dudek 
# Date              21-08-2015
# Version           2.0.1
# Notes             Run with sudo
# License           GNU General Public License v3.0
#==============================================================================

info(){
    if [[ $UID != 0  ]]; then
        whiptail --title "Debian config" --msgbox \
        "Please run this script with sudo" 20 70
    else
        main_menu
    fi
}

select_system() {
	OS=$(whiptail --nocancel --title "Select OS" --menu "Select your OS" 20 70 10 \
	"Debian_8" "" 3>&1 1>&2 2>&3)

    case "$OS" in
        "Debian_8")
            repo_dirs
        ;;
        "*")
            whiptail --title "Debian config" --msgbox "Wrong OS" 20 70
            main_menu
        ;;
    esac
}

repo_dirs() {
    if (whiptail --title "Config files" --yes-button "Yes" --no-button "No" --yesno \
        "Do you want to use config files of author?\nConfigs: DE, WM, conky, autostart, wallpaper etc.\n\nDon't worry - you can change all later" 20 70) then

        CONFIG=YES
        mkdir -p $HOME/repo
        mkdir -p $HOME/tmp
        # Creating repo dir and cloning repository
        if [[ ! -d $HOME/repo/linux_stuff ]]; then
            cd $HOME/repo
            aptitude install git -y
            git clone https://github.com/micdud1995/linux_stuff.git
        else
            whiptail --title "Debian config" --msgbox "$HOME/repo/linux_stuff exists already" 20 70
        fi

    elif (whiptail --title "Cloning repository" --yes-button "Yes" --no-button "No" --yesno \
        "Do you want to clone repo?\nThere are important files for this program\n\nRepository: \ngithub.com/micdud1995/linux_stuff.git" 20 70) then

        CONFIG=NO
        mkdir -p $HOME/repo
        mkdir -p $HOME/tmp
        # Creating repo dir and cloning repository
        if [[ ! -d $HOME/repo/linux_stuff ]]; then
            cd $HOME/repo
            aptitude install git -y
            git clone https://github.com/micdud1995/linux_stuff.git
        else
            whiptail --title "Debian config" --msgbox "$HOME/repo/linux_stuff exists already" 20 70
        fi
    else
        CONFIG=NO
    fi

    config_sources
}

config_sources() {
    if (whiptail --title "Updating sources" --yes-button "Yes" --no-button "No" --yesno \
        "Do you want to update sources.list file?\n\nYou can choose between different versions of sources.\n\nContrib software requires non-free depedencies.\nNon-free section contains non-free software." 20 70) then

        VERSION=$(whiptail --nocancel --title "Edit sources.list" --menu "Select version of repositories" 20 70 10 \
        "Stable"    "" \
        "Testing"   "" \
        "Sid"       "" \
        "Stable contrib non-free"    "" \
        "Testing contrib non-free"   "" \
        "Sid contrib non-free"       "" 3>&1 1>&2 2>&3)

        case "$VERSION" in
            "Stable")
                NONFREE=0
                sh -c "echo '### STABLE ###' > /etc/apt/sources.list"
                sh -c "echo 'deb http://ftp.pl.debian.org/debian/ stable main' >> /etc/apt/sources.list"
                sh -c "echo 'deb-src http://ftp.pl.debian.org/debian/ stable main' >> /etc/apt/sources.list"
                sh -c "echo >> /etc/apt/sources.list"
                sh -c "echo 'deb http://security.debian.org/ stable/updates main' >> /etc/apt/sources.list"
                sh -c "echo 'deb-src http://security.debian.org/ stable/updates main' >> /etc/apt/sources.list"
                sh -c "echo >> /etc/apt/sources.list"
                sh -c "echo 'deb http://ftp.pl.debian.org/debian/ jessie-updates main' >> /etc/apt/sources.list"
                sh -c "echo 'deb-src http://ftp.pl.debian.org/debian/ jessie-updates main' >> /etc/apt/sources.list"
            ;;
            "Testing")
                NONFREE=0
                sh -c "echo '### TESTING ###' > /etc/apt/sources.list"
                sh -c "echo 'deb http://ftp.pl.debian.org/debian/ testing main' >> /etc/apt/sources.list"
                sh -c "echo 'deb-src http://ftp.pl.debian.org/debian/ testing main' >> /etc/apt/sources.list"
                sh -c "echo >> /etc/apt/sources.list"
                sh -c "echo 'deb http://security.debian.org/ testing/updates main' >> /etc/apt/sources.list"
                sh -c "echo 'deb-src http://security.debian.org/ testing/updates main' >> /etc/apt/sources.list"
            ;;
            "Sid")
                NONFREE=0
                sh -c "echo '### UNSTABLE ###' > /etc/apt/sources.list"
                sh -c "echo 'deb http://ftp.pl.debian.org/debian/ unstable main' >> /etc/apt/sources.list"
                sh -c "echo 'deb-src http://ftp.pl.debian.org/debian/ unstable main' >> /etc/apt/sources.list"
                sh -c "echo >> /etc/apt/sources.list"
                sh -c "echo 'deb http://security.debian.org/ unstable/updates main' >> /etc/apt/sources.list"
                sh -c "echo 'deb-src http://security.debian.org/ unstable/updates main' >> /etc/apt/sources.list"
            ;;
            "Stable contrib non-free")
                NONFREE=1
                sh -c "echo '### STABLE ###' > /etc/apt/sources.list"
                sh -c "echo 'deb http://ftp.pl.debian.org/debian/ stable main contrib non-free' >> /etc/apt/sources.list"
                sh -c "echo 'deb-src http://ftp.pl.debian.org/debian/ stable main contrib non-free' >> /etc/apt/sources.list"
                sh -c "echo >> /etc/apt/sources.list"
                sh -c "echo 'deb http://security.debian.org/ stable/updates main contrib non-free' >> /etc/apt/sources.list"
                sh -c "echo 'deb-src http://security.debian.org/ stable/updates main contrib non-free' >> /etc/apt/sources.list"
                sh -c "echo >> /etc/apt/sources.list"
                sh -c "echo 'deb http://ftp.pl.debian.org/debian/ jessie-updates main' >> /etc/apt/sources.list"
                sh -c "echo 'deb-src http://ftp.pl.debian.org/debian/ jessie-updates main' >> /etc/apt/sources.list"
            ;;
            "Testing contrib non-free")
                NONFREE=1
                sh -c "echo '### TESTING ###' > /etc/apt/sources.list"
                sh -c "echo 'deb http://ftp.pl.debian.org/debian/ testing main contrib non-free' >> /etc/apt/sources.list"
                sh -c "echo 'deb-src http://ftp.pl.debian.org/debian/ testing main contrib non-free' >> /etc/apt/sources.list"
                sh -c "echo >> /etc/apt/sources.list"
                sh -c "echo 'deb http://security.debian.org/ testing/updates main contrib non-free' >> /etc/apt/sources.list"
                sh -c "echo 'deb-src http://security.debian.org/ testing/updates main contrib non-free' >> /etc/apt/sources.list"
            ;;
            "Sid contrib non-free")
                NONFREE=1
                sh -c "echo '### UNSTABLE ###' > /etc/apt/sources.list"
                sh -c "echo 'deb http://ftp.pl.debian.org/debian/ unstable main contrib non-free' >> /etc/apt/sources.list"
                sh -c "echo 'deb-src http://ftp.pl.debian.org/debian/ unstable main contrib non-free' >> /etc/apt/sources.list"
                sh -c "echo >> /etc/apt/sources.list"
                sh -c "echo 'deb http://security.debian.org/ unstable/updates main contrib non-free' >> /etc/apt/sources.list"
                sh -c "echo 'deb-src http://security.debian.org/ unstable/updates main contrib non-free' >> /etc/apt/sources.list"
            ;;
            "*")
                whiptail --title "Debian config" --msgbox "Wrong version" 20 70
                main_menu
            ;;
        esac

        aptitude update
        aptitude upgrade -y
    fi

    config_shell
}

config_shell() {
    if (whiptail --title "Shell" --yes-button "Yes" --no-button "No" --yesno \
        "Do you want to config shell?\n\nYou can choose between zsh and bash.\nScript will unpack fancy config file for it." 20 70) then

        SHELL=$(whiptail --nocancel --title "Select shell" --menu "Select your shell:" 20 70 10 \
        "Bash"  "" \
        "Zsh"   "" 3>&1 1>&2 2>&3)

        case "$SHELL" in
            "Bash")
                aptitude install colordiff bash -y

                if [ "$CONFIG" == "YES" ]; then
                    cp $HOME/repo/linux_stuff/config-files/bash/hide.bashrc $HOME/.bashrc
                fi

                chsh -s /bin/bash
            ;;
            "Zsh")
                aptitude install colordiff zsh -y

                if [ "$CONFIG" == "YES" ]; then
                    cp $HOME/repo/linux_stuff/config-files/zsh/hide.zshrc $HOME/.zshrc
                fi

                chsh -s /bin/zsh
            ;;
        esac
    fi

    config_gui
}

config_gui() {
    if (whiptail --title "Debian config" --yes-button "Yes" --no-button "No" --yesno \
        "Install graphics drivers now? \nDrivers for Intel, and Virtual Box guests" 20 70) then

        GPU=$(whiptail --title "Debian config" --menu "Select your GPU" 20 70 10 \
            "Intel"   "Intel Graphics" \
            "VBOX"    "VirtualBox Guest" 3>&1 1>&2 2>&3)

        case "$GPU" in
            "AMD")
                whiptail --title "Error" --msgbox "Not supported yet" 20 70
                main_menu
            ;;
            "Intel")
                aptitude install xserver-xorg-video-intel -y
            ;;
            "Nvidia")
                whiptail --title "Error" --msgbox "Not supported yet" 20 70
                main_menu
            ;;
            "VBOX")
                aptitude install dkms build-essential linux-headers-amd64 virtualbox-guest-x11 virtualbox-dkms virtualbox-guest-utils -y
            ;;
        esac
    fi

    if (whiptail --title "Debian config" --yes-button "Yes" --no-button "No" --yesno \
        "Do you want to install a DE or WM?\n\n\n\n*awesome is configurable tiling wm\n\n*i3 is an improved dynamic, tiling window manager \n\n*LXDE is an extremely fast-performing and energy-saving desktop environment" 20 70) then

        DE=$(whiptail --title  "Debian config" --menu "Select environment:" 20 70 10 \
        "awesome"       "configurable tiling WM" \
        "i3"            "i3 tiling WM" \
        "lxde-core"     "fast DE"   3>&1 1>&2 2>&3)

        case "$DE" in
            "awesome")
                aptitude install awesome

                if [ "$CONFIG" == "YES" ]; then
                    mkdir -p $HOME/.config/awesome
                    mkdir -p ~/.config/awesome/themes/
                    mkdir -p ~/.config/awesome/themes/my
                    cp $HOME/repo/linux_stuff/config-files/rc.lua $HOME/.config/awesome/rc.lua
                fi

                echo "exec awesome" > ~/.xinitrc
            ;;
            "i3")
                aptitude install i3 dmenu fonts-font-awesome -y

                if [ "$CONFIG" == "YES" ]; then
                    mkdir -p $HOME/.i3
                    mkdir -p $HOME/Obrazy
                    cp $HOME/repo/linux_stuff/i3/hide.i3status.conf ~/.i3status.conf
                    cp $HOME/repo/linux_stuff/i3/config ~/.i3/config
                    cp $HOME/repo/linux_stuff/i3/workspace* ~/.i3/
                    cp $HOME/repo/linux_stuff/i3/load_workspaces.sh ~/.i3/
                    chmod +x $HOME/.i3/load_workspaces.sh
                    cp $HOME/repo/linux_stuff/i3/i3lock-deb.png ~/Obrazy/i3lock-deb.png
                fi

                echo "exec i3" > ~/.xinitrc
            ;;
            "lxde-core")
                aptitude install lxde-core -y

                echo "startlxde" > ~/.xinitrc
            ;;
            "xfce")
                aptitude install xfce4 -y

                echo "startxfce4" > ~/.xinitrc
            ;;
        esac
    fi

    if (whiptail --title "Making Esc from Caps Lock" --yes-button "Yes" --no-button "No" --yesno \
        "Do you want to use Caps Lock as a additional Escape?" 20 70) then
        setxkbmap -option caps:escape &
    fi

    config_packages
}

config_packages() {
    if (whiptail --title "Debian config" --yes-button "Yes" --no-button "No" --yesno \
        "Do you want to install some common software?\n\nPackages demanding configuration will be configured automatically." 20 70) then

        software=$(whiptail --title "Additional software" --checklist "Choose your desired software \nUse spacebar to check/uncheck \npress enter when finished" 20 70 14 \
            "alsa-utils"                    "Sound" OFF \
            "apache"  	                    "Web Server" OFF \
            "bash"                          "Shell" OFF \
            "cmus"                          "Music player" OFF \
            "conky"                         "System Info" OFF \
            "dictd"                         "Offline dictionary" OFF \
            "dwb"                           "Web Browser" OFF \
            "faenza-icon-theme"             "Icon Theme" OFF \
            "feh"                           "Image Viewer" OFF \
            "fuck"                          "Command correcting" OFF \
            "htop"                          "Process Info" OFF \
            "irssi"                         "IRC Client" OFF \
            "iceweasel"                     "Web Browser" OFF \
            "libncurses5-dev"               "ncurses" OFF \
            "libreoffice"                   "Libre Office" OFF \
            "lightdm"                       "Login Manager" OFF \
            "links"                         "Web Browser" OFF \
            "livestreamer"                  "Stream Tool" OFF \
            "lxrandr"                       "Output manager" OFF \
            "lxterminal"                    "Light terminal" OFF \
            "mc"                            "Midnight Commander" OFF \
            "mirage"                        "Image Viewer" OFF \
            "moc"                           "Music Player" OFF \
            "mpv"                           "Video Player" OFF \
            "mutt"                          "Mail Client" OFF \
            "nethack"                       "Roguelike game" OFF \
            "newsbeuter"                    "RSS feed reader" OFF \
            "openssh"                       "Secure Shell" OFF \
            "pavucontrol"                   "Sound output" OFF \
            "pinta"                         "Image Editor" OFF \
            "ranger"                        "File manager" OFF \
            "rtorrent"                      "Torrent Client" OFF \
            "screenfetch"                   "System Info" OFF \
            "slim"                          "Login Manager" OFF \
            "scrot"                         "Screenshots" OFF \
            "steam"                         "Steam Client" OFF \
            "tor"                           "Communication System" OFF \
            "torbrowser-launcher"           "Web Browser" OFF \
            "tree"                          "Tree of dirs" OFF \
            "ufw"                           "Firewall" OFF \
            "unzip"                         "Unpack zip archives" OFF \
            "vim" 	  	                    "Text Editor" OFF \
            "vim-nox" 	  	                "Vim with script support" OFF \
            "vimb"                          "Web Browser" OFF \
            "virtualbox"                    "Virtual Machines" OFF \
            "weechat"                       "IRC Client" OFF \
            "xbacklight"                    "Screen brightness" OFF \
            "xboxdrv"                       "Xbox pad driver" OFF \
            "xterm"                         "Terminal emulator" OFF \
            "xorg" 	  	                    "X Server" OFF \
            "xserver-xorg-input-synaptics"  "Touchpad" OFF \
            "youtube-dl"                    "YT Download" OFF \
            "zathura"                       "PDF Viewer" OFF \
            "zip"                           "Files archiver" OFF \
            "zsh"     	                    "Z-shell" OFF 3>&1 1>&2 2>&3)

        download=$(echo "$software" | sed 's/\"//g')
        aptitude install $download -y

        if [[ $download == *" fuck "* ]] ; then
            cd $HOME/tmp
            wget -O - https://raw.githubusercontent.com/nvbn/thefuck/master/install.sh | sh - && $0
        fi

        if [[ $download == *" dictd "* ]] ; then
            language=$(whiptail --title "DIctionary languages" --menu "Choose your dictionary" 20 70 11 \
            "eng-pol" \
            "eng-deu" \
            "eng-fra" \
            "eng-rus" \
            "eng-spa" 3>&1 1>&2 2>&3)

            case "$language" in
                "eng-pol")
                    aptitude install dict-freedict-eng-pol -y
                ;;
                "eng-deu")
                    aptitude install dict-freedict-eng-deu -y
                ;;
                "eng-fra")
                    aptitude install dict-freedict-eng-fra -y
                ;;
                "eng-rus")
                    aptitude install dict-freedict-eng-rus -y
                ;;
                "eng-spa")
                    aptitude install dict-freedict-eng-spa -y
                ;;
            esac
        fi

        if [[ $download == *" cmus "* ]] ; then
            if [ "$CONFIG" == "YES" ]; then
                cp $HOME/repo/linux_stuff/config-files/cmus/zenburn.theme /usr/share/cmus/
            fi
        fi

        if [[ $download == *" xterm "* ]] ; then
            echo "XTerm*selectToClipboard: true" >> $HOME/.Xdefaults
        fi

        if [[ $download == *" weechat "* ]] ; then
            if [ "$CONFIG" == "YES" ]; then
                mkdir -p $HOME/.weechat
                cp $HOME/repo/linux_stuff/config-files/weechat/* $HOME/.weechat/
            fi
            rm -f $HOME/.weechat/weechat.log
            ln -s /dev/null weechat.log
        fi

        if [[ $download == *" newsbeuter "* ]] ; then
            if [ "$CONFIG" == "YES" ]; then
                mkdir -p $HOME/.config/newsbeuter
                cp $HOME/repo/linux_stuff/config-files/newsbeuter/urls $HOME/.config/newsbeuter/urls
                cp $HOME/repo/linux_stuff/config-files/newsbeuter/config $HOME/.config/newsbeuter/config
            fi
        fi

        if [[ $download == *" conky "* ]] ; then
            if [ "$CONFIG" == "YES" ]; then
                cp ~/repo/linux_stuff/conky/conky.conf ~/.conkyrc
                cp ~/repo/linux_stuff/conky/hoog0555_cyr2.ttf /usr/share/fonts/truetype/ 
            fi
        fi

        if [[ $download == *" dwb "* ]] ; then
            if [ "$CONFIG" == "YES" ]; then
                cp ~/repo/linux_stuff/config-files/dwb/bookmarks ~/.config/dwb/default/bookmarks
            fi
        fi

        if [[ $download == *" xboxdrv "* ]] ; then
            sh -c "echo 'blacklist xpad' >> /etc/modprobe.d/blacklist"
            rmmod xpad
        fi

        if [[ $download == *" git "* ]] ; then
            name=$(whiptail --nocancel --inputbox "Set git username:" 20 70 "Michał Dudek" 3>&1 1>&2 2>&3)
            git config --global user.name "$name"
            mail=$(whiptail --nocancel --inputbox "Set git usermail:" 20 70 "dud95@gmx.us" 3>&1 1>&2 2>&3)
            git config --global user.email $mail
        fi

        if [[ $download == *" openssh "* ]] ; then
            aptitude install openssh-server -y
            iptables -I INPUT -p tcp --dport 22 -j ACCEPT
            /etc/init.d/ssh restart
            export DISPLAY=:0
        fi

        if [[ $download == *" mc "* ]] ; then
            if [ "$CONFIG" == "YES" ]; then
                mkdir -p $HOME/.config/mc
                mkdir -p $HOME/.local/share/mc/skins
                cp $HOME/repo/linux_stuff/config-files/midnight-commander/mc.ext $HOME/.config/mc/mc.ext
                cp $HOME/repo/linux_stuff/config-files/midnight-commander/darkcourses_green.ini $HOME/.local/share/mc/skins/
            fi
        fi

        if [[ $download == *" moc "* ]] ; then
            if [ "$CONFIG" == "YES" ]; then
                mkdir -p $HOME/.moc
                cp $HOME/repo/linux_stuff/config-files/moc/config $HOME/.moc/config
                cp $HOME/repo/linux_stuff/config-files/moc/cyanic_theme /usr/share/moc/themes/
            fi
        fi

        if [[ $download == *"libreoffice"* ]] ; then
            language=$(whiptail --title "Libre office language" --menu "Choose your language" 20 70 11 \
            "Polski"        "Polish" \
            "Deutsch"       "German" \
            "British"       "English_british" \
            "American"      "English_american" \
            "Espanol"       "Spanish" 3>&1 1>&2 2>&3)

            case "$language" in
                "Polski")
                    aptitude install libreoffice-l10n-pl -y
                ;;
                "Deutsch")
                    aptitude install libreoffice-l10n-de -y
                ;;
                "British")
                    aptitude install libreoffice-l10n-en-gb -y
                ;;
                "American")
                    aptitude install libreoffice-l10n-en-us -y
                ;;
                "Espanol")
                    aptitude install libreoffice-l10n-es -y
                ;;
            esac
        fi
        
        if [[ $download == *" mutt "* ]] ; then
            if [ "$CONFIG" == "YES" ]; then
                cp $HOME/repo/linux_stuff/config-files/mutt/hide.muttrc $HOME/.muttrc
            fi
        fi

        if [[ $download == *" irssi "* ]] ; then
            mkdir $HOME/.irssi
            if (whiptail --title "Irssi channels" --yes-button "Yes" --no-button "No" --yesno \
                "Do you want to add channels to autostart?\n\n#debian\n#debian-offtopic\n#listekklonu\n#plug\n#error" 20 70) then

                cp $HOME/repo/linux_stuff/config-files/irssi/config $HOME/.irssi/config
                cp $HOME/repo/linux_stuff/config-files/cyanic.theme $HOME/.irssi/
            fi
        fi

        if [[ $download == *" rtorrent "* ]] ; then
            if [ "$CONFIG" == "YES" ]; then
                mkdir -p $HOME/.rtorrent
                cp ~/repo/linux_stuff/config-files/rtorrent/hide.rtorrent.rc ~/.rtorrent.rc
            fi
        fi

        if [[ $download == *" virtualbox "* ]] ; then
            aptitude install dkms build-essential linux-headers-amd64 virtualbox-guest-x11 virtualbox-dkms virtualbox-guest-utils -y
        fi

        if [[ $download == *" livestreamer "* ]] ; then
            aptitude install python python-requests python-setuptools python-singledispatch -y
            cd $HOME/tmp
            git clone https://github.com/chrippa/livestreamer.git
            cd $HOME/tmp/livestreamer
            python setup.py install
            rm -rf $HOME/tmp/livestreamer
        fi

        if [[ $download == *" youtube-dl "* ]] ; then
            wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
            chmod a+rx /usr/local/bin/youtube-dl
        fi

        if [[ $download == *" vimb "* ]] ; then
            aptitude install libsoup2.4-dev libwebkit-dev libgtk-3-dev libwebkitgtk-3.0-dev -y
            mkdir -p $HOME/tmp
            mkdir -p $HOME/tmp/vimb
            mkdir -p $HOME/.config/vimb
            cd $HOME/tmp
            git clone https://github.com/fanglingsu/vimb.git
            cd $HOME/tmp/vimb
            make clean
            make install

            if [ "$CONFIG" == "YES" ]; then
                cp $HOME/repo/linux_stuff/config-files/vimb/config $HOME/.config/vimb/config
                cp $HOME/repo/linux_stuff/config-files/dwb/bookmarks $HOME/.config/vimb/bookmark
            fi
        fi

        if [[ $download == *" steam "* ]] ; then
            mkdir -p $HOME/tmp
            aptitude install curl zenity steam -y
        fi

        if [[ $download == *" slim "* ]] ; then
            if [ "$CONFIG" == "YES" ]; then
                cp $HOME/repo/linux_stuff/config-files/slim/slim.conf /etc/slim.conf
                dpkg-reconfigure slim
            fi
        fi

        if [[ $download == *" lightdm "* ]] ; then
            if [ "$CONFIG" == "YES" ]; then
                cp $HOME/repo/linux_stuff/config-files/lightdm/lightdm.conf /etc/ligthdm/lightdm.conf
                dpkg-reconfigure lightdm
            fi
        fi

        if [[ $download == *" vim "* ]] ; then
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

            aptitude install vim curl exuberant-ctags fonts-inconsolata -y

            if [ "$CONFIG" == "YES" ]; then
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
                cp $HOME/repo/linux_stuff/vim/sh.snippets $HOME/.vim/bundle/vim-snippets/snippets/
            fi
        fi 

        if [[ $download == *" vim-nox "* ]] ; then
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
            #   YouCompleteMe
            #	Gruvbox theme
            #==============================================================

            aptitude install vim-nox build-essential cmake python-dev curl exuberant-ctags fonts-inconsolata -y

            if [ "$CONFIG" == "YES" ]; then
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

                # YouCompleteMe
                cd ~/.vim/bundle/
                git clone https://github.com/Valloric/YouCompleteMe.git
                cd YouCompleteMe/
                git submodule update --init --recursive
                ./install.sh
                
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
    fi

    config_scripts
} 

config_scripts() {
    if (whiptail --title "Scripts" --yes-button "Yes" --no-button "No" --yesno \
        "Do you want to copy useful scripts?\n\n - Mounting [m command]\n - Unmounting [um command]\n - Creating live-usb [live-usb command]" 20 70) then

        scripts=$(whiptail --title "Additional scripts" --checklist "Choose your desired scripts\nUse spacebar to check/uncheck \nPress enter when finished" 20 70 10 \
            "m"             "Mount script" ON \
            "um"            "Umount script" ON \
            "live-usb"     	"Live-USB script" ON 3>&1 1>&2 2>&3)

        if [[ $scripts == *" m "* ]] ; then
            aptitude install fuse ntfs-3g -y
            cp $HOME/repo/linux_stuff/config-files/scripts/m /usr/bin/
            chmod +x /usr/bin/m
        fi

        if [[ $scripts == *" um "* ]] ; then
            aptitude install fuse ntfs-3g -y
            cp $HOME/repo/linux_stuff/config-files/scripts/um /usr/bin/
            chmod +x /usr/bin/um
        fi

        if [[ $scripts == *" live-usb "* ]] ; then
            cp $HOME/repo/linux_stuff/config-files/scripts/live-usb /usr/bin/
            chmod +x /usr/bin/live-usb
        fi
    fi 

    config_beep
}

config_beep() {
    if (whiptail --title "Beep sound" --yes-button "Yes" --no-button "No" --yesno \
        "Do you want to disable beep sound in your system?\n\nA beep is a short, single tone, typically high-pitched, generally made by a computer." 20 70) then

        rmmod pcspkr
        sh -c "echo 'blacklist pcspkr' > /etc/modprobe.d/blacklist"
    fi

    config_pc
}

config_pc() {
    if (whiptail --title "Additional settings" --yes-button "Yes" --no-button "No" --yesno \
        "Do you want to configure computer options?\n\nYou can set here things depending on your computer and personal preferences." 20 70) then

        scripts=$(whiptail --title "Additional scripts" --checklist "Choose your desired software\nSpacebar - check/uncheck \nEnter - finished" 20 70 10 \
            "Wallpaper"     "Set wallpaper" OFF \
            "Touchpad"      "Enable touchpad" OFF \
            "WiFi"          "Enable Lenovo G580 net. card" OFF \
            "Microphone"    "Enable Lenovo G580 microphone" OFF \
            "CS:GO config"  "Global Offensive config file" OFF \
            "Lid"     	    "Don't suspend laptop when lid closed" OFF 3>&1 1>&2 2>&3)

        if [[ $scripts == *" Wallpaper "* ]] ; then
            aptitude install feh
            mkdir -p $HOME/Obrazy
            cp $HOME/repo/linux_stuff/config-files/wallpaper.jpg $HOME/Obrazy/wallpaper.jpg
            feh --bg-scale $HOME/Obrazy/wallpaper.jpg
        fi

        if [[ $scripts == *" Touchpad "* ]] ; then
            mkdir -p /etc/X11/xorg.conf.d
            cp $HOME/repo/linux_stuff/config-files/50-synaptics.conf /etc/X11/xorg.conf.d/50-synaptics.conf
            echo synclient TapButton1=1 >> $HOME/.xinitrc
        fi

        if [[ $scripts == *" WiFi "* ]] ; then
            aptitude install linux-headers-$(uname -r|sed 's,[^-]*-[^-]*-,,') broadcom-sta-dkms wicd
            modprobe -r b44 b43 b43legacy ssb brcmsmac
            modprobe wl
            cp $HOME/repo/linux_stuff/config-files/interfaces /etc/network/interfaces
            adduser michal netdev
            /etc/init.d/dbus reload
            /etc/init.d/wicd start
            wicd-client -n
        fi

        if [[ $scripts == *" Microphone "* ]] ; then
            cp $HOME/repo/linux_stuff/config-files/alsa-base.conf /etc/modprobe.d/alsa-base.conf
        fi

        if [[ $scripts == *" CS:GO config "* ]] ; then
            if [[ -d $HOME/.steam/steam/steamapps/common/Counter-Strike\ Global\ Offensive/csgo/cfg ]]; then
                cp $HOME/repo/linux_stuff/config-files/CS:GO/autoexec.cfg $HOME/.steam/steam/steamapps/common/Counter-Strike\ Global\ Offensive/csgo/cfg/
            else
                whiptail --title "Debian config" --msgbox "Counter-Strike Global Offensive isn't installed" 20 70
            fi
        fi

        if [[ $scripts == *" Lid "* ]] ; then
            cp $HOME/repo/linux_stuff/config-files/logind.conf /etc/systemd/logind.conf
        fi
    fi 

    whiptail --title "Debian config" --msgbox "System configured." 20 70
    exit
}

main_menu() {
	menu_item=$(whiptail --nocancel --title "Debian config" --menu "Menu Items:" 20 70 10 \
		"Select OS"             "-" \
		"Clone repo"            "-" \
		"Config sources"        "-" \
		"Config shell"          "-" \
		"Install GUI"           "-" \
		"Install packages"      "-" \
		"Copy scripts"          "-" \
		"Disable beep"          "-" \
		"Config PC things"      "-" \
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
		"Config PC things")
            config_pc
		;;
		"Reboot System") 
            reboot
		;;
		"Exit Installer")
            whiptail --title "Debian config" --msgbox "System configured." 20 70
            exit
		;;
	esac
}

info

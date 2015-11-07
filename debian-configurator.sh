#!/usr/bin/env bash

#==============================================================================
# Title             debian-configurator.sh
# Description       This script will config installed Debian GNU/Linux system 
# Author            Michal Dudek 
# Date              03-11-2015
# Version           2.1.0
# Notes             Run as a root
# License           GNU General Public License v3.0
#==============================================================================

#==============================================================================
# Constant variables
ROOT_UID=0
OS=""
VERSION=""
SHELL=""
GPU=""
DE=""
HOME=""
#==============================================================================

info()
{
    if [[ $UID != $ROOT_UID  ]]; then
        whiptail --title "Debian config" --msgbox \
        "Please run this script as a root" 20 70
    else
        HOME=$(whiptail --nocancel --inputbox "Your home folder is: " 20 70 "/home/michal" 3>&1 1>&2 2>&3)
        main_menu
    fi
}

select_system() 
{
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

repo_dirs() 
{
    if [[ ! -d $HOME/repo/linux_stuff ]]; then
        if (whiptail --title "Cloning repository" --yes-button "Yes" --no-button "No" --yesno \
            "Do you want to clone repo?\nThere are important files for this program\n\nRepository: \ngithub.com/micdud1995/linux_stuff.git" 20 70) then

            mkdir -p $HOME/repo
            mkdir -p $HOME/tmp
            # Creating repo dir and cloning repository
            if [[ ! -d $HOME/repo/linux_stuff ]]; then
                cd $HOME/repo
                aptitude install git -y
                git clone https://github.com/micdud1995/linux_stuff.git
            fi
        fi
    else
        whiptail --title "Debian config" --msgbox "OK, $HOME/repo/linux_stuff exists already" 20 70
    fi

    config_sources
}

config_sources() 
{
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
                sh -c "echo '### TESTING ###' > /etc/apt/sources.list"
                sh -c "echo 'deb http://ftp.pl.debian.org/debian/ testing main' >> /etc/apt/sources.list"
                sh -c "echo 'deb-src http://ftp.pl.debian.org/debian/ testing main' >> /etc/apt/sources.list"
                sh -c "echo >> /etc/apt/sources.list"
                sh -c "echo 'deb http://security.debian.org/ testing/updates main' >> /etc/apt/sources.list"
                sh -c "echo 'deb-src http://security.debian.org/ testing/updates main' >> /etc/apt/sources.list"
            ;;
            "Sid")
                sh -c "echo '### UNSTABLE ###' > /etc/apt/sources.list"
                sh -c "echo 'deb http://ftp.pl.debian.org/debian/ unstable main' >> /etc/apt/sources.list"
                sh -c "echo 'deb-src http://ftp.pl.debian.org/debian/ unstable main' >> /etc/apt/sources.list"
                sh -c "echo >> /etc/apt/sources.list"
                sh -c "echo 'deb http://security.debian.org/ unstable/updates main' >> /etc/apt/sources.list"
                sh -c "echo 'deb-src http://security.debian.org/ unstable/updates main' >> /etc/apt/sources.list"
            ;;
            "Stable contrib non-free")
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
                sh -c "echo '### TESTING ###' > /etc/apt/sources.list"
                sh -c "echo 'deb http://ftp.pl.debian.org/debian/ testing main contrib non-free' >> /etc/apt/sources.list"
                sh -c "echo 'deb-src http://ftp.pl.debian.org/debian/ testing main contrib non-free' >> /etc/apt/sources.list"
                sh -c "echo >> /etc/apt/sources.list"
                sh -c "echo 'deb http://security.debian.org/ testing/updates main contrib non-free' >> /etc/apt/sources.list"
                sh -c "echo 'deb-src http://security.debian.org/ testing/updates main contrib non-free' >> /etc/apt/sources.list"
            ;;
            "Sid contrib non-free")
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

    config_gui
}

config_gui() 
{
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
        "Do you want to install a DE or WM?\n\n\n\n*awesome is configurable tiling wm\n\n*i3 is an improved dynamic, tiling window manager \n\n*LXDE is an extremely fast DE" 20 70) then

        DE=$(whiptail --title  "Debian config" --menu "Select environment:" 20 70 10 \
        "awesome"           "configurable WM ver. 3.4" \
        "i3"                "i3 tiling WM" \
        "xfce"              "lightweight DE" \
        "lxde-core"         "fast DE"   3>&1 1>&2 2>&3)

        case "$DE" in
            "awesome")
                aptitude install xorg xinit awesome fonts-font-awesome fonts-inconsolata -y
                mkdir -p $HOME/.config/awesome
                mkdir -p ~/.config/awesome/themes/
                cp -r $HOME/repo/linux_stuff/config-files/awesome/* $HOME/.config/awesome/
                cp $HOME/repo/linux_stuff/config-files/xinit/hide.xinitrc $HOME/.xinitrc
            ;;
            "i3")
                aptitude install xorg xinit i3 dmenu fonts-font-awesome feh weechat vim-nox lxterminal ranger moc -y
                mkdir -p $HOME/.i3
                mkdir -p $HOME/Obrazy
                cp $HOME/repo/linux_stuff/config-files/i3/hide.i3status.conf ~/.i3status.conf
                cp $HOME/repo/linux_stuff/config-files/i3/debian-config ~/.i3/config
                cp $HOME/repo/linux_stuff/config-files/i3/workspace* ~/.i3/
                cp $HOME/repo/linux_stuff/config-files/i3/load_workspaces.sh ~/.i3/
                chmod +x $HOME/.i3/load_workspaces.sh
                cp $HOME/repo/linux_stuff/config-files/i3/i3lock-deb.png ~/Obrazy/i3lock-deb.png
                cp $HOME/repo/linux_stuff/config-files/xinit/hide.xinitrc $HOME/.xinitrc
            ;;
            "lxde-core")
                aptitude install xorg xinit lxde-core -y
                cp $HOME/repo/linux_stuff/config-files/xinit/hide.xinitrc $HOME/.xinitrc
            ;;
            "xfce")
                aptitude install xorg xinit xfce4 -y
                cp $HOME/repo/linux_stuff/config-files/xinit/hide.xinitrc $HOME/.xinitrc
            ;;
        esac
    fi

    config_packages
}

config_packages() 
{
    if (whiptail --title "Debian config" --yes-button "Yes" --no-button "No" --yesno \
        "Do you want to install/config some common software?" 20 70) then

    (whiptail --title "Additional software" --separate-output --checklist "Choose your desired software \nUse spacebar to check/uncheck \npress enter when finished" 20 70 14 \
            "alsa-utils"                    "Sound" OFF \
            "apache"  	                    "Web Server" OFF \
            "bash"                          "Shell" OFF \
            "brasero"                       "Burning app" OFF \
            "cmus"                          "Music player" OFF \
            "conky"                         "System Info" OFF \
            "dictd"                         "Offline dictionary" OFF \
            "faenza-icon-theme"             "Icon Theme" OFF \
            "feh"                           "Image Viewer" OFF \
            "fuck"                          "Command correcting" OFF \
            "git"                           "Content tracker" OFF \
            "gummi"                         "LaTeX Editor" OFF \
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
            "moc"                           "Music Player" OFF \
            "mpv"                           "Video Player" OFF \
            "mutt"                          "Mail Client" OFF \
            "nethack-console"               "Roguelike game" OFF \
            "newsbeuter"                    "RSS feed reader" OFF \
            "openssh"                       "Secure Shell" OFF \
            "pavucontrol"                   "Sound output" OFF \
            "pinta"                         "Image Editor" OFF \
            "ranger"                        "File manager" OFF \
            "rtorrent"                      "Torrent Client" OFF \
            "screenfetch"                   "System Info" OFF \
            "scrot"                         "Screenshots" OFF \
            "tor"                           "Communication System" OFF \
            "tree"                          "Tree of dirs" OFF \
            "ufw"                           "Firewall" OFF \
            "unpacking"                     "Archive tools" OFF \
            "uzbl"                          "Web Browser" OFF \
            "vim-clear" 	  	            "Text Editor" OFF \
            "vim-nox" 	  	                "Vim with script support" OFF \
            "virtualbox"                    "Virtual Machines" OFF \
            "w3m"                           "Web Browser" OFF \
            "weechat"                       "IRC Client" OFF \
            "xcalib"                        "Screen brightness" OFF \
            "xboxdrv"                       "Xbox pad driver" OFF \
            "xterm"                         "Terminal emulator" OFF \
            "xorg" 	  	                    "X Server" OFF \
            "xserver-xorg-input-synaptics"  "Touchpad" OFF \
            "youtube-dl"                    "YT Download" OFF \
            "zathura"                       "PDF Viewer" OFF \
            "zsh"     	                    "Z-shell" OFF 2>results)

        while read choice
        do
            case $choice in
                    alsa-utils)
                        aptitude install alsa-utils -y
                    ;;
                    apache)
                        aptitude install apache -y
                    ;;
                    bash)
                        SHELL=BASH

                        aptitude install colordiff bash -y
                        cp $HOME/repo/linux_stuff/config-files/bash/debian-bashrc $HOME/.bashrc
                        chsh -s /bin/bash
                    ;;
                    brasero)
                        aptitude install brasero -y
                    ;;
                    cmus)
                        aptitude install cmus -y
                        mkdir -p $HOME/.cmus
                        cp $HOME/repo/linux_stuff/config-files/cmus/zenburn.theme $HOME/.cmus/
                    ;;
                    conky)
                        aptitude install conky -y
                        cp ~/repo/linux_stuff/config-files/conky/hide.conkyrc ~/.conkyrc
                        cp ~/repo/linux_stuff/config-files/conky/hoog0555_cyr2.ttf /usr/share/fonts/truetype/ 
                    ;;
                    faenza-icon-theme)
                        aptitude install faenza-icon-theme -y
                    ;;
                    feh)
                        aptitude install feh -y
                    ;;
                    fuck)
                        cd $HOME/tmp
                        wget -O - https://raw.githubusercontent.com/nvbn/thefuck/master/install.sh | sh - && $0
                    ;;
                    git)
                        aptitude install git -y
                        name=$(whiptail --nocancel --inputbox "Set git username:" 20 70 "Michał Dudek" 3>&1 1>&2 2>&3)
                        git config --global user.name "$name"
                        mail=$(whiptail --nocancel --inputbox "Set git usermail:" 20 70 "dud95@gmx.us" 3>&1 1>&2 2>&3)
                        git config --global user.email $mail
                    ;;
                    gummi)
                        aptitude install gummi texlive-full texlive-lang-polish texlive-doc-pl texlive-math-extra texlive-latex-extra-doc -y
                    ;;
                    htop)
                        aptitude install htop -y
                    ;;
                    iceweasel)
                        aptitude install iceweasel -y
                    ;;
                    irssi)
                        aptitude install irssi -y
                        mkdir $HOME/.irssi
                        if (whiptail --title "Irssi channels" --yes-button "Yes" --no-button "No" --yesno \
                        "Do you want to add channels to autostart?\n\n#debian\n#debian-offtopic\n#listekklonu\n#plug\n#error" 20 70) then

                        cp $HOME/repo/linux_stuff/config-files/irssi/config $HOME/.irssi/config
                        cp $HOME/repo/linux_stuff/config-files/cyanic.theme $HOME/.irssi/
                        fi
                    ;;
                    libncurses5-dev)
                        aptitude install libncurses5-dev -y
                    ;;
                    libreoffice)
                        aptitude install libreoffice -y
                        (whiptail --title "Libre office language" --menu "Choose your language" 20 70 11 \
                        "Polski"        "Polish" \
                        "Deutsch"       "German" \
                        "British"       "English_british" \
                        "American"      "English_american" \
                        "Espanol"       "Spanish" 2>results3)

                        while read choice3
                        do
                            case $choice3 in
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
                        done < results3
                    ;;
                    lightdm)
                        aptitude install lightdm -y
                        cp $HOME/repo/linux_stuff/config-files/lightdm/lightdm.conf /etc/ligthdm/lightdm.conf
                        dpkg-reconfigure lightdm
                    ;;
                    links)
                        aptitude install links -y
                    ;;
                    livestreamer)
                        aptitude install python python-requests python-setuptools python-singledispatch -y
                        cd $HOME/tmp
                        git clone https://github.com/chrippa/livestreamer.git
                        cd $HOME/tmp/livestreamer
                        python setup.py install
                        rm -rf $HOME/tmp/livestreamer
                    ;;
                    lxrandr)
                        aptitude install lxrandr -y
                    ;;
                    lxterminal)
                        aptitude install lxterminal -y
                    ;;
                    mpv)
                        aptitude install mpv -y
                    ;;
                    nethack-concole)
                        aptitude install nethack-console -y
                    ;;
                    unpacking)
                        aptitude install p7zip unrar unzip zip -y
                    ;;
                    pavucontrol)
                        aptitude install pavucontrol -y
                    ;;
                    pinta)
                        aptitude install pinta -y
                    ;;
                    screenfetch)
                        aptitude install screenfetch -y
                    ;;
                    scrot)
                        aptitude install scrot -y
                    ;;
                    tor)
                        aptitude install tor torbrowser-launcher -y
                    ;;
                    ranger)
                        aptitude install w3m w3m-img ranger -y
                        mkdir -p $HOME/.config/ranger
                        mkdir -p $HOME/.config/ranger/colorschemes
                        cp $HOME/repo/linux_stuff/config-files/ranger/red.py $HOME/.config/ranger/colorschemes/
                        cp $HOME/repo/linux_stuff/config-files/ranger/debian-rc.conf $HOME/.config/ranger/rc.conf
                    ;;
                    ufw)
                        aptitude install ufw -y
                        ufw enable
                    ;;
                    w3m)
                        aptitude install w3m-img -y
                    ;;
                    weechat)
                        aptitude install weechat -y
                        mkdir -p $HOME/.weechat
                        cp $HOME/repo/linux_stuff/config-files/weechat/* $HOME/.weechat/
                        rm -f $HOME/.weechat/weechat.log
                        ln -s /dev/null weechat.log
                    ;;
                    newsbeuter)
                        aptitude install newsbeuter -y
                        mkdir -p $HOME/.config/newsbeuter
                        cp $HOME/repo/linux_stuff/config-files/newsbeuter/debian-urls $HOME/.config/newsbeuter/urls
                        cp $HOME/repo/linux_stuff/config-files/newsbeuter/debian-config $HOME/.config/newsbeuter/config
                    ;;
                    openssh)
                        aptitude install openssh-server -y
                        iptables -I INPUT -p tcp --dport 22 -j ACCEPT
                        /etc/init.d/ssh restart
                        export DISPLAY=:0
                    ;;
                    mc)
                        aptitude install mc -y
                        mkdir -p $HOME/.config/mc
                        mkdir -p $HOME/.local/share/mc/skins
                        cp $HOME/repo/linux_stuff/config-files/midnight-commander/mc.ext $HOME/.config/mc/mc.ext
                        cp $HOME/repo/linux_stuff/config-files/midnight-commander/darkcourses_green.ini $HOME/.local/share/mc/skins/
                    ;;
                    moc)
                        aptitude install moc -y
                        mkdir -p $HOME/.moc
                        cp $HOME/repo/linux_stuff/config-files/moc/debian-config $HOME/.moc/config
                        cp $HOME/repo/linux_stuff/config-files/moc/red_theme /usr/share/moc/themes/
                    ;;
                    mutt)
                        aptitude install mutt -y
                        cp $HOME/repo/linux_stuff/config-files/mutt/hide.muttrc $HOME/.muttrc
                    ;;
                    rtorrent)
                        aptitude install rtorrent -y
                        mkdir -p $HOME/.rtorrent
                        cp ~/repo/linux_stuff/config-files/rtorrent/hide.rtorrent.rc ~/.rtorrent.rc
                    ;;
                    virtualbox)
                        aptitude install dkms build-essential linux-headers-amd64 virtualbox-guest-x11 virtualbox-dkms virtualbox-guest-utils -y
                    ;;
                    youtube-dl)
                        wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
                        chmod a+rx /usr/local/bin/youtube-dl
                    ;;
                    slim)
                        aptitude install slim -y
                        cp $HOME/repo/linux_stuff/config-files/slim/slim.conf /etc/slim.conf
                        dpkg-reconfigure slim
                    ;;
                    xboxdrv)
                        aptitude install xboxdrv -y
                        sh -c "echo 'blacklist xpad' >> /etc/modprobe.d/blacklist"
                        rmmod xpad
                    ;;
                    xcalib)
                        aptitude install xcalib -y
                    ;;
                    xorg)
                        aptitude install xorg -y
                    ;;
                    xserver-xorg-input-synaptics)
                        aptitude install xserver-xorg-input-synaptics -y
                    ;;
                    xterm)
                        aptitude install xterm fonts-inconsolata -y
                        cp $HOME/repo/linux_stuff/config-files/xterm/hide.Xresources $HOME/.Xresources
                        xrdb -merge ~/.Xresources 
                    ;;
                    zathura)
                        aptitude install zathura -y
                    ;;
                    zsh)
                        SHELL=ZSH

                        aptitude install colordiff zsh -y
                        cp $HOME/repo/linux_stuff/config-files/zsh/hide.zshrc $HOME/.zshrc
                        chsh -s /bin/zsh
                    ;;
                    vim-clear)
                        #==============================================================
                        # Plugin list:
                        #	Pathogen
                        #	Nerdtree
                        #	Syntastic
                        #	Taglist
                        #	GitGutter
                        #   CtrlP
                        # 	Vim-airline
                        #	Auto-pairs
                        # 	Supertab
                        #	Neosnippet
                        #   indentLine
                        #   SingleCompile
                        #   Vim-commentary
                        #	Gruvbox theme
                        #==============================================================

                        aptitude install vim curl exuberant-ctags fonts-inconsolata -y

                        # Making dirs
                        mkdir -p ~/tmp ~/.vim/autoload ~/.vim/bundle ~/.vim/colors ~/tmp/tagbar

                        # Pathogen
                        curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

                        # CtrlP
                        cd ~/.vim/bundle
                        git clone https://github.com/kien/ctrlp.vim.git

                        # Nerdtree
                        cd ~/.vim/bundle && \
                        git clone https://github.com/scrooloose/nerdtree.git

                        # Syntastic
                        cd ~/.vim/bundle && \
                        git clone https://github.com/scrooloose/syntastic.git

                        # Taglist
                        cd ~/.vim/bundle && \
                        git clone git://github.com/vim-scripts/taglist.vim.git

                        # Git-gutter
                        cd ~/.vim/bundle && \
                        git clone git://github.com/airblade/vim-gitgutter.git

                        # Vim-airline
                        cd ~/.vim/bundle && \
                        git clone https://github.com/bling/vim-airline ~/.vim/bundle/vim-airline

                        # Auto-pairs
                        cd ~/.vim/bundle && \
                        git clone git://github.com/jiangmiao/auto-pairs.git

                        # Supertab
                        git clone git://github.com/ervandew/supertab.git

                        # Neosnippet
                        cd ~/.vim/bundle
                        git clone https://github.com/Shougo/neosnippet.vim
                        git clone https://github.com/Shougo/neosnippet-snippets
                        cp $HOME/repo/linux_stuff/vim/python.snip $HOME/.vim/bundle/neosnippet-snippets/neosnippets/python.snip

                        # Indent-line
                        cd ~/.vim/bundle
                        git clone https://github.com/Yggdroot/indentLine.git

                        # Single-compile
                        cd ~/.vim/bundle
                        git clone https://github.com/xuhdev/SingleCompile.git

                        # Vim-commentary
                        cd ~/.vim/bundle
                        git clone https://github.com/tpope/vim-commentary.git

                        # Jellybeans theme
                        cd ~/tmp && \
                        git clone https://github.com/nanotech/jellybeans.vim.git
                        mv ~/tmp/jellybeans.vim/colors/jellybeans.vim ~/.vim/colors/jellybeans.vim
                        rm -rf ~/tmp/jellybeans.vim

                        # Copying .vimrc
                        cp ~/repo/linux_stuff/vim/hide.vimrc ~/.vimrc
                    ;;
                    vim-nox)
                        #==============================================================
                        # Plugin list:
                        #	Pathogen
                        #	Nerdtree
                        #	Syntastic
                        #	Taglist
                        #	GitGutter
                        #   CtrlP
                        # 	Vim-airline
                        #	Auto-pairs
                        # 	Supertab
                        #	Neosnippet
                        #   indentLine
                        #   SingleCompile
                        #   Vim-commentary
                        #   YouCompleteMe
                        #	Gruvbox theme
                        #==============================================================

                        aptitude install vim-nox build-essential cmake python-dev curl exuberant-ctags fonts-inconsolata -y

                        # Making dirs
                        mkdir -p ~/tmp ~/.vim/autoload ~/.vim/bundle ~/.vim/colors ~/tmp/tagbar

                        # Pathogen
                        curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

                        # CtrlP
                        cd ~/.vim/bundle
                        git clone https://github.com/kien/ctrlp.vim.git

                        # Nerdtree
                        cd ~/.vim/bundle && \
                        git clone https://github.com/scrooloose/nerdtree.git

                        # Syntastic
                        cd ~/.vim/bundle && \
                        git clone https://github.com/scrooloose/syntastic.git

                        # Taglist
                        cd ~/.vim/bundle && \
                        git clone git://github.com/vim-scripts/taglist.vim.git

                        # Git-gutter
                        cd ~/.vim/bundle && \
                        git clone git://github.com/airblade/vim-gitgutter.git

                        # Vim-airline
                        cd ~/.vim/bundle && \
                        git clone https://github.com/bling/vim-airline ~/.vim/bundle/vim-airline

                        # Auto-pairs
                        cd ~/.vim/bundle && \
                        git clone git://github.com/jiangmiao/auto-pairs.git

                        # Supertab
                        git clone git://github.com/ervandew/supertab.git

                        # Neosnippet
                        cd ~/.vim/bundle
                        git clone https://github.com/Shougo/neosnippet.vim
                        git clone https://github.com/Shougo/neosnippet-snippets
                        cp $HOME/repo/linux_stuff/vim/python.snip $HOME/.vim/bundle/neosnippet-snippets/neosnippets/python.snip

                        # Indent-line
                        cd ~/.vim/bundle
                        git clone https://github.com/Yggdroot/indentLine.git

                        # Single-compile
                        cd ~/.vim/bundle
                        git clone https://github.com/xuhdev/SingleCompile.git

                        # Vim-commentary
                        cd ~/.vim/bundle
                        git clone https://github.com/tpope/vim-commentary.git

                        # Jellybeans theme
                        cd ~/tmp && \
                        git clone https://github.com/nanotech/jellybeans.vim.git
                        mv ~/tmp/jellybeans.vim/colors/jellybeans.vim ~/.vim/colors/jellybeans.vim
                        rm -rf ~/tmp/jellybeans.vim

                        # YouCompleteMe
                        cd ~/.vim/bundle/
                        git clone https://github.com/Valloric/YouCompleteMe.git
                        cd YouCompleteMe/
                        git submodule update --init --recursive
                        ./install.sh

                        # Copying .vimrc
                        cp ~/repo/linux_stuff/vim/hide.vimrc ~/.vimrc
                    ;;
                    uzbl)
                        aptitude install uzbl -y
                        cp $HOME/repo/linux_stuff/config-files/uzbl/config ~/.config/uzbl/config
                        cp $HOME/repo/linux_stuff/config-files/dwb/bookmarks $HOME/.local/share/uzbl/bookmarks
                    ;;
                    dictd)
                        aptitude install dictd -y
                        whiptail --title "Test" --checklist --separate-output "Choose:" 20 78 15 \
                        "eng-pol" "" OFF \
                        "eng-deu" "" OFF \
                        "eng-fra" "" OFF \
                        "eng-rus" "" OFF \
                        "eng-spa" "" off 2>results2

                        while read choice2
                        do
                                case $choice2 in
                                        eng-pol)
                                            aptitude install dict-freedict-eng-pol -y
                                        ;;
                                        eng-deu)
                                            aptitude install dict-freedict-eng-deu -y
                                        ;;
                                        eng-fra) 
                                            aptitude install dict-freedict-eng-fra -y
                                        ;;
                                        eng-rus) 
                                            aptitude install dict-freedict-eng-rus -y
                                        ;;
                                        eng-spa) 
                                            aptitude install dict-freedict-eng-spa -y
                                        ;;
                                        *)
                                        ;;
                                esac
                        done < results2
                    ;;
            esac
        done < results

    fi
    config_scripts
} 

config_scripts() 
{
    if (whiptail --title "Scripts" --yes-button "Yes" --no-button "No" --yesno \
        "Do you want to copy useful scripts?" 20 70) then

        (whiptail --title "Scripts" --checklist --separate-output "Choose:" 20 78 15 \
        "m" "" OFF \
        "um" "" OFF \
        "live-usb" "" OFF 2>results)

        while read choice
        do
            case $choice in
                m)
                    aptitude install fuse ntfs-3g -y
                    cp $HOME/repo/linux_stuff/config-files/scripts/m /usr/local/bin/
                    chmod +x /usr/local/bin/m
                ;;
                um)
                    aptitude install fuse ntfs-3g -y
                    cp $HOME/repo/linux_stuff/config-files/scripts/um /usr/local/bin/
                    chmod +x /usr/local/bin/um
                ;;
                live-usb)
                    cp $HOME/repo/linux_stuff/config-files/scripts/live-usb /usr/local/bin/
                    chmod +x /usr/local/bin/live-usb
                ;;
            esac
        done < results
    fi 

    config_pc
}


config_pc() 
{
    if (whiptail --title "Additional settings" --yes-button "Yes" --no-button "No" --yesno \
        "Do you want to configure computer options?\n\nYou can set here things depending on your computer and personal preferences." 20 70) then

    (whiptail --title "Additional settings" --checklist --separate-output "Choose your desired software\nSpacebar - check/uncheck \nEnter - finished:" 20 78 15 \
    "Wallpaper" "Set wallpaper" OFF \
    "Beep" "Disable bepp sound" OFF \
    "Caps" "Making Esc from Caps Lock key" OFF \
    "Touchpad" "Enable touchpad" OFF \
    "WiFi" "Enable Lenovo G580 net. card" OFF \
    "Microphone" "Enable Lenovo G580 microphone" OFF \
    "CS:GO" "Global Offensive config file" OFF \
    "Grub" "Boot loader configuration" OFF \
    ".xinitrc" "Editing file" OFF \
    "Lid" "Don't suspend laptop when lid closed" off 2>results)

    while read choice
    do
        case $choice in
            Beep)
                rmmod pcspkr
                sh -c "echo 'blacklist pcspkr' > /etc/modprobe.d/blacklist"
            ;;
            Caps)
                setxkbmap -option caps:escape &
            ;;
            .xinitrc)
                vim $HOME/.xinitrc
            ;;
            Wallpaper)
                aptitude install feh -y
                mkdir -p $HOME/Obrazy
                cp $HOME/repo/linux_stuff/config-files/wallpapers/debian-wallpaper.jpg $HOME/Obrazy/wallpaper.jpg
                feh --bg-scale $HOME/Obrazy/wallpaper.jpg
            ;;
            Touchpad)
                mkdir -p /etc/X11/xorg.conf.d
                cp $HOME/repo/linux_stuff/config-files/other/50-synaptics.conf /etc/X11/xorg.conf.d/50-synaptics.conf
            ;;
            WiFi)
                aptitude install linux-headers-$(uname -r|sed 's,[^-]*-[^-]*-,,') broadcom-sta-dkms wicd -y
                modprobe -r b44 b43 b43legacy ssb brcmsmac
                modprobe wl
                cp $HOME/repo/linux_stuff/config-files/other/interfaces /etc/network/interfaces
                adduser michal netdev
                /etc/init.d/dbus reload
                /etc/init.d/wicd start
                wicd-client -n
            ;;
            Microphone)
                cp $HOME/repo/linux_stuff/config-files/other/alsa-base.conf /etc/modprobe.d/alsa-base.conf
            ;;
            CS:GO)
                if [[ -d $HOME/.steam/steam/steamapps/common/Counter-Strike\ Global\ Offensive/csgo/cfg ]]; then
                    cp $HOME/repo/linux_stuff/config-files/CS:GO/autoexec.cfg $HOME/.steam/steam/steamapps/common/Counter-Strike\ Global\ Offensive/csgo/cfg/
                else
                    whiptail --title "Debian config" --msgbox "Counter-Strike Global Offensive isn't installed" 20 70
                fi
            ;;
            Grub)
                vim /etc/default/grub
                update-grub
            ;;
            Lid)
                cp $HOME/repo/linux_stuff/config-files/lid/logind.conf /etc/systemd/logind.conf
            ;;
        esac
    done < results

    fi 

    whiptail --title "Debian config" --msgbox "System configured." 20 70
    exit
}

main_menu() 
{
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

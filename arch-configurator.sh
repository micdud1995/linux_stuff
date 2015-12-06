#!/usr/bin/env bash

#==============================================================================
# Title             arch-configurator.sh
# Description       This script will config installed Arch GNU/Linux system 
# Author            Michal Dudek 
# Date              04-12-2015
# Version           0.1
# Notes             Run as a root
# License           GNU General Public License v3.0
#==============================================================================

#==============================================================================
# Global variables
ROOT_UID=0
VERSION=""
SHELL=""
GPU=""
DE=""
HOME=""
USER=""
#==============================================================================

info()
{
    if [[ "$UID" != "$ROOT_UID"  ]]; then
        whiptail --title "Arch config" --msgbox \
        "Please run this script as a root" 20 70
        exit 126
    else
        USER=$(whiptail --nocancel --inputbox "Type your user name: " 20 70 "michal" 3>&1 1>&2 2>&3)

        HOME="/home/$USER"
        mkdir -p $HOME/repo
        mkdir -p $HOME/tmp
        mkdir -p $HOME/Documents
        mkdir -p $HOME/Music
        mkdir -p $HOME/Movies
        mkdir -p $HOME/Downloads
        mkdir -p $HOME/Pictures
        mkdir -p $HOME/Desktop

        main_menu
    fi
}

repo_dirs() 
{
    if [[ ! -d $HOME/repo/linux_stuff ]]; then
        if (whiptail --title "Cloning repository" --yes-button "Yes" --no-button "No" --yesno \
            "Do you want to clone repo?\nThere are important files for this program\n\nRepository: \ngithub.com/micdud1995/linux_stuff.git" 20 70) then

            # Creating repo dir and cloning repository
            if [[ ! -d $HOME/repo/linux_stuff ]]; then
                cd $HOME/repo
                pacman -S git --noconfirm
                git clone https://github.com/micdud1995/linux_stuff.git
            fi
        fi
    else
        whiptail --title "Arch config" --msgbox "OK, $HOME/repo/linux_stuff exists already" 20 70
    fi

    config_pacman
}

config_pacman() 
{
    if (whiptail --title "Pacman config" --yes-button "Yes" --no-button "No" --yesno \
        "Do you want to edit pacman.conf?" 20 70) then
	
        nano /etc/pacman.conf

        pacman -Syu --noconfirm

    fi

    if (whiptail --title "Pacman config" --yes-button "Yes" --no-button "No" --yesno \
        "Do you want to install yaourt?" 20 70) then

        YAOURT_VER=$(whiptail --title  "Arch config" --menu "Select drivers:" 20 70 10 \
        "64bit"                 "" \
        "32bit"                  ""   3>&1 1>&2 2>&3)

        case "$YAOURT_VER" in
            "64bit")
                sh -c "echo '[archlinuxfr]' >> /etc/pacman.conf"
                sh -c "echo 'SigLevel = Never' >> /etc/pacman.conf"
                sh -c "echo 'Server = http://repo.archlinux.fr/x86_64' >> /etc/pacman.conf"
            ;;
            "32bit")
                sh -c "echo '[archlinuxfr]' >> /etc/pacman.conf"
                sh -c "echo 'SigLevel = Never' >> /etc/pacman.conf"
                sh -c "echo 'Server = http://repo.archlinux.fr/i686' >> /etc/pacman.conf"
            ;;
        esac

        pacman -Syu --noconfirm
        pacman -S yaourt --noconfirm

    fi


    config_gui
}

config_gui() 
{
    if (whiptail --title "Arch config" --yes-button "Yes" --no-button "No" --yesno \
        "Install graphics drivers now? \nDrivers for Intel, and Virtual Box guests" 20 70) then

         pacman -S xorg-server xorg-server-utils mesa mesa-libgl xorg-xinit

        DRIVERS=$(whiptail --title  "Arch config" --menu "Select drivers:" 20 70 10 \
        "intel"                 "" \
        "intel-multilib"        "" \
        "amd"                   "" \
        "amd-multilib"          "" \
        "nvidia"                "" \
        "nvidia-multilib"       "" \
        "vbox"                  ""   3>&1 1>&2 2>&3)

        case "$DRIVERS" in
            "intel")
                 pacman -S xf86-video-intel
            ;;
            "intel-multilib")
                 pacman -S xf86-video-intel lib32-mesa-libgl
            ;;
            "amd")
                 pacman -S xf86-video-ati 
            ;;
            "amd-multilib")
                 pacman -S xf86-video-ati lib32-mesa-libgl
            ;;
            "nvidia")
                 pacman -S nvidia nvidia-libgl nvidia-utils 
            ;;
            "nvidia-multilib")
                 pacman -S nvidia nvidia-libgl lib32-nvidia-libgl nvidia-utils lib32-nvidia-utils
            ;;
            "vbox")
                 pacman -S virtualbox-guest-utils virtualbox-guest-modules
                 cp $HOME/repo/linux_stuff/config-files/virtualbox/vbox.conf /etc/modules-load.d/vbox.conf
            ;;
        esac
    fi

    if (whiptail --title "Arch config" --yes-button "Yes" --no-button "No" --yesno \
        "Do you want to install a DE or WM?" 20 70) then

        DE=$(whiptail --title  "Arch config" --menu "Select environment:" 20 70 10 \
        "i3"                "" \
        "xfce"              "" \
        "gnome"             "" \
        "lxde-common"       ""   3>&1 1>&2 2>&3)

        case "$DE" in
            "i3")
                pacman -S i3-wm i3status dmenu ttf-inconsolata terminus-font tamsyn-font alsa-utils feh rxvt-unicode udiskie --noconfirm
                yaourt -S ttf-font-awesome xcalib --noconfirm
                mkdir -p $HOME/.i3
                mkdir -p $HOME/.config/i3status
                mkdir -p $HOME/.config/i3/
                cp $HOME/repo/linux_stuff/config-files/i3/hide.i3status.conf $HOME/.i3status.conf
                cp $HOME/repo/linux_stuff/config-files/i3/arch-config $HOME/.i3/config
                # cp $HOME/repo/linux_stuff/config-files/i3/workspace* $HOME/.i3/
                # cp $HOME/repo/linux_stuff/config-files/i3/load_workspaces.sh $HOME/.i3/
                # chmod +x $HOME/.i3/load_workspaces.sh

                cp $HOME/repo/linux_stuff/config-files/i3/i3lock-arch.png $HOME/Pictures/i3lock-arch.png
                cp $HOME/repo/linux_stuff/config-files/wallpapers/arch-wallpaper.jpg $HOME/Pictures/wallpaper.png
                cp $HOME/repo/linux_stuff/config-files/xinit/hide.xinitrc $HOME/.xinitrc
                nano $HOME/.xinitrc
            ;;
            "lxde-core")
                pacman -S lxde-core lxpanel lxappearance lxappearance-obconf lxrandr faenza-icon-theme --noconfirm
                cp $HOME/repo/linux_stuff/config-files/lxde/lxde-rc.xml $HOME/.config/openbox/
                cp $HOME/repo/linux_stuff/config-files/lxde/panel $HOME/.config/lxpanel/LXDE/panels/panel
                cp $HOME/repo/linux_stuff/config-files/scripts/run-cmus /usr/local/bin/
                chmod +x /usr/local/bin/run-cmus
                cp $HOME/repo/linux_stuff/config-files/xinit/hide.xinitrc $HOME/.xinitrc
                nano $HOME/.xinitrc
            ;;
            "xfce")
                pacman -S xfwm4 --noconfirm
                cp $HOME/repo/linux_stuff/config-files/xinit/hide.xinitrc $HOME/.xinitrc
                nano $HOME/.xinitrc
            ;;
            "gnome")
                pacman -S gnome --noconfirm
                cp $HOME/repo/linux_stuff/config-files/xinit/hide.xinitrc $HOME/.xinitrc
                nano $HOME/.xinitrc
            ;;
        esac
    fi

    config_packages
}

config_packages() 
{
    if (whiptail --title "Arch config" --yes-button "Yes" --no-button "No" --yesno \
        "Do you want to install/config some common software?" 20 70) then

        (whiptail --title "Additional software" --separate-output --checklist \
        "Choose your desired software \nUse spacebar to check/uncheck \npress enter when finished" 20 70 14 \
        "alsa-utils"                    "Sound" OFF \
        "archey3"                       "System Info" OFF \
        "apache"  	                    "Web Server" OFF \
        "bash"                          "Shell" OFF \
        "brasero"                       "Burning app" OFF \
        "calcurse"                      "Text-based organizer" OFF \
        "cmus"                          "Music player" OFF \
        "conky"                         "System Info" OFF \
        "faenza-icon-theme"             "Icon Theme" OFF \
        "feh"                           "Image Viewer" OFF \
        "firefox"                       "Web Browser" OFF \
        "fuck"                          "Command correcting" OFF \
        "git"                           "Content tracker" OFF \
        "gummi"                         "LaTeX Editor" OFF \
        "htop"                          "Process Info" OFF \
        "libreoffice"                   "Libre Office" OFF \
        "lightdm"                       "Login Manager" OFF \
        "links"                         "Web Browser" OFF \
        "livestreamer"                  "Stream Tool" OFF \
        "lxrandr"                       "Output manager" OFF \
        "mc"                            "Midnight Commander" OFF \
        "moc"                           "Music Player" OFF \
        "mpv"                           "Video Player" OFF \
        "mutt"                          "Mail Client" OFF \
        "ncurses"                       "ncurses library" OFF \
        "nethack"                       "Roguelike game" OFF \
        "newsbeuter"                    "RSS feed reader" OFF \
        "openssh"                       "Secure Shell" OFF \
        "pavucontrol"                   "Sound output" OFF \
        "pinta"                         "Image Editor" OFF \
        "ranger"                        "File manager" OFF \
        "rtorrent"                      "Torrent Client" OFF \
        "rxvt-unicode"                  "Terminal emulator" OFF \
        "scrot"                         "Screenshots" OFF \
        "tor"                           "Communication System" OFF \
        "tree"                          "Tree of dirs" OFF \
        "ufw"                           "Firewall" OFF \
        "unpacking"                     "Archive tools" OFF \
        "uzbl"                          "Web Browser" OFF \
        "vifm"                          "File Manager" OFF \
        "vim-minimal" 	  	            "Text Editor" OFF \
        "vim" 	  	                    "Vim with scripts support" OFF \
        "virtualbox"                    "Virtual Machines" OFF \
        "w3m"                           "Web Browser" OFF \
        "weechat"                       "IRC Client" OFF \
        "xcalib"                        "Screen brightness" OFF \
        "xboxdrv"                       "Xbox pad driver" OFF \
        "xorg" 	  	                    "X Server" OFF \
        "youtube-dl"                    "YT Downloader" OFF \
        "zathura"                       "PDF Viewer" OFF \
        "zsh"     	                    "Z-shell" OFF 2>results)

        while read choice
        do
            case $choice in
                alsa-utils)
                    pacman -S alsa-utils --noconfirm
                ;;
                apache)
                    pacman -S apache --noconfirm
                ;;
                bash)
                    SHELL="BASH"

                    pacman -S colordiff bash ttf-inconsolata --noconfirm
                    cp $HOME/repo/linux_stuff/config-files/bash/arch-bashrc $HOME/.bashrc
                    chsh -s /bin/bash
                ;;
                brasero)
                    pacman -S brasero --noconfirm
                ;;
                calcurse)
                    pacman -S calcurse --noconfirm
                ;;
                cmus)
                    pacman -S cmus --noconfirm
                    mkdir -p $HOME/.cmus
                    cp $HOME/repo/linux_stuff/config-files/cmus/zenburn.theme $HOME/.cmus/
                    cp $HOME/repo/linux_stuff/config-files/cmus/solarized.theme $HOME/.cmus/
                ;;
                conky)
                    pacman -S conky --noconfirm

                    CONKY=$(whiptail --title  "Arch config" --menu "Select conky file:" 20 70 10 \
                    "red"               "all informations" \
                    "binary"            "binary clock" \
                    "indicator"         "desktop indicator" 3>&1 1>&2 2>&3)

                    case "$CONKY" in
                        "red")
                            cp $HOME/repo/linux_stuff/config-files/conky/hide.conkyrc $HOME/.conkyrc
                            cp $HOME/repo/linux_stuff/config-files/conky/hoog0555_cyr2.ttf /usr/share/fonts/truetype/ 
                        ;;
                        "binary")
                            cp $HOME/repo/linux_stuff/config-files/conky/binary-clock $HOME/.conkyrc
                        ;;
                        "indicator")
                            cp $HOME/repo/linux_stuff/config-files/conky/workspace-indicator $HOME/.conkyrc
                        ;;
                    esac
                ;;
                faenza-icon-theme)
                    pacman -S faenza-icon-theme --noconfirm
                ;;
                feh)
                    pacman -S feh --noconfirm
                ;;
                firefox)
                    pacman -S firefox --noconfirm
                ;;
                fuck)
                    pacman -S thefuck
                ;;
                git)
                    pacman -S git --noconfirm
                    name=$(whiptail --nocancel --inputbox "Set git username:" 20 70 "<name>" 3>&1 1>&2 2>&3)
                    git config --global user.name "$name"
                    mail=$(whiptail --nocancel --inputbox "Set git usermail:" 20 70 "<mail>" 3>&1 1>&2 2>&3)
                    git config --global user.email $mail
                    edit=$(whiptail --nocancel --inputbox "Set git text editor:" 20 70 "vim" 3>&1 1>&2 2>&3)
                    git config --global core.editor $edit
                ;;
                gummi)
                    pacman -S gummi texlive-most --noconfirm
                ;;
                htop)
                    pacman -S htop --noconfirm
                ;;
                libreoffice)
                    pacman -S libreoffice-still --noconfirm
                ;;
                lightdm)
                    pacman -S lightdm --noconfirm
                ;;
                links)
                    pacman -S links --noconfirm
                ;;
                livestreamer)
                    pacman -S livestreamer
                ;;
                lxrandr)
                    pacman -S lxrandr --noconfirm
                ;;
                mc)
                    pacman -S mc --noconfirm
                    mkdir -p $HOME/.config/mc
                    mkdir -p $HOME/.local/share/mc/skins
                    cp $HOME/repo/linux_stuff/config-files/midnight-commander/mc.ext $HOME/.config/mc/mc.ext
                    cp $HOME/repo/linux_stuff/config-files/midnight-commander/darkcourses_green.ini $HOME/.local/share/mc/skins/
                ;;
                moc)
                    pacman -S moc --noconfirm
                    mkdir -p $HOME/.moc
                    mkdir -p $HOME/.moc/themes
                    cp $HOME/repo/linux_stuff/config-files/moc/arch-config $HOME/.moc/config
                    cp $HOME/repo/linux_stuff/config-files/moc/solarized $HOME/.moc/themes/
                ;;
                mpv)
                    pacman -S mpv --noconfirm
                ;;
                mutt)
                    pacman -S mutt abook --noconfirm
                    cp $HOME/repo/linux_stuff/config-files/mutt/hide.muttrc $HOME/.muttrc
                    touch $HOME/.mutt-alias
                ;;
                ncurses)
                    pacman -S ncurses --noconfirm
                ;;
                nethack)
                    pacman -S nethack--noconfirm
                ;;
                newsbeuter)
                    pacman -S newsbeuter --noconfirm
                    mkdir -p $HOME/.config/newsbeuter
                    cp $HOME/repo/linux_stuff/config-files/newsbeuter/arch-urls $HOME/.config/newsbeuter/urls
                    cp $HOME/repo/linux_stuff/config-files/newsbeuter/arch-config $HOME/.config/newsbeuter/config
                ;;
                unpacking)
                    pacman -S p7zip unrar unzip zip --noconfirm
                ;;
                pavucontrol)
                    pacman -S pavucontrol --noconfirm
                ;;
                pinta)
                    pacman -S pinta --noconfirm
                ;;
                scrot)
                    pacman -S scrot --noconfirm
                ;;
                tor)
                    pacman -S tor torbrowser-launcher --noconfirm
                ;;
                ranger)
                    pacman -S w3m w3m-img ranger --noconfirm
                    mkdir -p $HOME/.config/ranger
                    mkdir -p $HOME/.config/ranger/colorschemes
                    cp $HOME/repo/linux_stuff/config-files/ranger/solarized.py $HOME/.config/ranger/colorschemes/
                    cp $HOME/repo/linux_stuff/config-files/ranger/arch-rc.conf $HOME/.config/ranger/rc.conf
                ;;
                ufw)
                    pacman -S ufw --noconfirm
                    ufw enable
                ;;
                w3m)
                    pacman -S w3m --noconfirm
                ;;
                weechat)
                    pacman -S weechat --noconfirm
                    mkdir -p $HOME/.weechat
                    cp $HOME/repo/linux_stuff/config-files/weechat/* $HOME/.weechat/
                    rm -f $HOME/.weechat/weechat.log
                    ln -s /dev/null weechat.log
                ;;
                openssh)
                    pacman -S openssh--noconfirm
                    iptables -I INPUT -p tcp --dport 22 -j ACCEPT
                    /etc/init.d/ssh restart
                    export DISPLAY=:0
                ;;
                rtorrent)
                    pacman -S rtorrent --noconfirm
                    mkdir -p $HOME/.rtorrent
                    cp $HOME/repo/linux_stuff/config-files/rtorrent/hide.rtorrent-arch.rc $HOME/.rtorrent.rc
                ;;
                rxvt-unicode)
                    pacman -S rxvt-unicode --noconfirm
                    cp $HOME/repo/linux_stuff/config-files/rxvt/hide.Xresources $HOME/.Xresources
                    xrdb -merge $HOME/.Xresources 
                ;;
                uzbl)
                    pacman -S uzbl-browser --noconfirm
                    cp $HOME/repo/linux_stuff/config-files/uzbl/config $HOME/.config/uzbl/config
                    cp $HOME/repo/linux_stuff/config-files/dwb/bookmarks $HOME/.local/share/uzbl/bookmarks
                ;;
                vifm)
                    pacman -S vifm --noconfirm
                    mkdir -p $HOME/.vifm
                    mkdir -p $HOME/.vifm/colors
                    cp $HOME/repo/linux_stuff/config-files/vifm/vifmrc $HOME/.vifm/
                    cp $HOME/repo/linux_stuff/config-files/vifm/solarized.vifm $HOME/.vifm/colors/
                ;;
                virtualbox)
                    pacman -S virtualbox virtualbox-host-modules virtualbox-guest-iso --noconfirm
                ;;
                youtube-dl)
                    pacman -S youtube-dl --noconfirm
                ;;
                xboxdrv)
                    pacman -S xboxdrv --noconfirm
                    sh -c "echo 'blacklist xpad' >> /etc/modprobe.d/blacklist"
                    rmmod xpad
                ;;
                xcalib)
                    yaourt -S xcalib --noconfirm
                ;;
                xorg)
                    pacman -S xorg-server xorg-xinit --noconfirm
                ;;
                zathura)
                    pacman -S zathura --noconfirm
                ;;
                zsh)
                    SHELL="ZSH"

                    pacman -S colordiff zsh inconsolata --noconfirm
                    cp $HOME/repo/linux_stuff/config-files/zsh/hide.zshrc $HOME/.zshrc
                    chsh -s /bin/zsh
                ;;
                *vim-minimal*)
                    #==============================================================
                    # Plugin list:
                    #	Pathogen
                    #	Nerdtree
                    #	Syntastic
                    #	Tagbar / Taglist
                    #	GitGutter
                    # 	Vim-airline
                    #	Auto-pairs
                    # 	Supertab
                    #	Neosnippet
                    #   indentLine
                    #   SingleCompile
                    #   Vim-commentary
                    #	Solarized theme
                    #==============================================================

                    pacman -S vim-minimal curl ctags ttf-inconsolata 

                    # Making dirs
                    mkdir -p $HOME/tmp $HOME/.vim/autoload $HOME/.vim/bundle $HOME/.vim/colors $HOME/tmp/tagbar

                    # Pathogen
                    curl -LSso $HOME/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

                    # Supertab
                    git clone git://github.com/ervandew/supertab.git

                    # Vim-airline
                    cd $HOME/.vim/bundle && \
                    git clone https://github.com/bling/vim-airline $HOME/.vim/bundle/vim-airline

                    # Syntastic
                    cd $HOME/.vim/bundle && \
                    git clone https://github.com/scrooloose/syntastic.git

                    # Nerdtree
                    cd $HOME/.vim/bundle && \
                    git clone https://github.com/scrooloose/nerdtree.git

                    # Taglist
                    cd $HOME/.vim/bundle && \
                    git clone git://github.com/vim-scripts/taglist.vim.git

                    # Git-gutter
                    cd $HOME/.vim/bundle && \
                    git clone git://github.com/airblade/vim-gitgutter.git

                    # Auto-pairs
                    cd $HOME/.vim/bundle && \
                    git clone git://github.com/jiangmiao/auto-pairs.git

                    # Neosnippet
                    cd $HOME/.vim/bundle
                    git clone https://github.com/Shougo/neosnippet.vim
                    git clone https://github.com/Shougo/neosnippet-snippets
                    cp $HOME/repo/linux_stuff/config-files/vim/python.snip $HOME/.vim/bundle/neosnippet-snippets/neosnippets/python.snip

                    # Indent-line
                    cd $HOME/.vim/bundle
                    git clone https://github.com/Yggdroot/indentLine.git

                    # Single-compile
                    cd $HOME/.vim/bundle
                    git clone https://github.com/xuhdev/SingleCompile.git

                    # Vim-commentary
                    cd $HOME/.vim/bundle
                    git clone https://github.com/tpope/vim-commentary.git

                    # Copying solarized theme
                    cp $HOME/repo/linux_stuff/config-files/vim/solarized.vim $HOME/.vim/colors/

                    # Copying .vimrc
                    cp $HOME/repo/linux_stuff/config-files/vim/hide.vimrc $HOME/.vimrc
                    
                ;;
                *vim*)
                    #==============================================================
                    # Plugin list:
                    #	Pathogen
                    #	Nerdtree
                    #	Syntastic
                    #	Tagbar / Taglist
                    #	GitGutter
                    # 	Vim-airline
                    #	Auto-pairs
                    # 	Supertab
                    #	Neosnippet
                    #   indentLine
                    #   SingleCompile
                    #   Vim-commentary
                    #   YouCompleteMe
                    #	Solarized theme
                    #==============================================================

                    pacman -S vim cmake curl ctags ttf-inconsolata 

                    # Making dirs
                    mkdir -p $HOME/tmp $HOME/.vim/autoload $HOME/.vim/bundle $HOME/.vim/colors $HOME/tmp/tagbar

                    # Pathogen
                    curl -LSso $HOME/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

                    # Supertab
                    git clone git://github.com/ervandew/supertab.git

                    # Vim-airline
                    cd $HOME/.vim/bundle && \
                    git clone https://github.com/bling/vim-airline $HOME/.vim/bundle/vim-airline

                    # Syntastic
                    cd $HOME/.vim/bundle && \
                    git clone https://github.com/scrooloose/syntastic.git

                    # Nerdtree
                    cd $HOME/.vim/bundle && \
                    git clone https://github.com/scrooloose/nerdtree.git

                    # Git-gutter
                    cd $HOME/.vim/bundle && \
                    git clone git://github.com/airblade/vim-gitgutter.git

                    # Taglist
                    cd $HOME/.vim/bundle && \
                    git clone git://github.com/vim-scripts/taglist.vim.git

                    # Auto-pairs
                    cd $HOME/.vim/bundle && \
                    git clone git://github.com/jiangmiao/auto-pairs.git

                    # Neosnippet
                    cd $HOME/.vim/bundle
                    git clone https://github.com/Shougo/neosnippet.vim
                    git clone https://github.com/Shougo/neosnippet-snippets
                    cp $HOME/repo/linux_stuff/config-files/vim/python.snip $HOME/.vim/bundle/neosnippet-snippets/neosnippets/python.snip

                    # Indent-line
                    cd $HOME/.vim/bundle
                    git clone https://github.com/Yggdroot/indentLine.git

                    # Single-compile
                    cd $HOME/.vim/bundle
                    git clone https://github.com/xuhdev/SingleCompile.git

                    # Vim-commentary
                    cd $HOME/.vim/bundle
                    git clone https://github.com/tpope/vim-commentary.git

                    # YouCompleteMe
                    pacman -S cmake
                    cd $HOME/.vim/bundle/
                    git clone https://github.com/Valloric/YouCompleteMe.git
                    cd YouCompleteMe/
                    git submodule update --init --recursive
                    ./install.sh

                    # Copying solarized theme
                    cp $HOME/repo/linux_stuff/config-files/vim/solarized.vim $HOME/.vim/colors/

                    # Copying .vimrc
                    cp $HOME/repo/linux_stuff/config-files/vim/hide.vimrc $HOME/.vimrc
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
                    pacman -S fuse ntfs-3g --noconfirm
                    cp $HOME/repo/linux_stuff/config-files/scripts/m /usr/local/bin/
                    chmod +x /usr/local/bin/m
                ;;
                um)
                    pacman -S fuse ntfs-3g --noconfirm
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

    (whiptail --title "Additional settings" --checklist --separate-output \
    "Choose your desired software\nSpacebar - check/uncheck \nEnter - finished:" 20 78 15 \
    "Beep" "Disable bepp sound" OFF \
    "Touchpad" "Enable touchpad" OFF \
    "Microphone" "Enable Lenovo G580 microphone" OFF \
    "CS:GO" "Global Offensive config file" OFF \
    "Grub" "Boot loader configuration" OFF \
    "Lid" "Don't suspend laptop when lid closed" off 2>results)

    while read choice
    do
        case $choice in
            Beep)
                rmmod pcspkr
                sh -c "echo 'blacklist pcspkr' >> /etc/modprobe.d/blacklist"
            ;;
            Touchpad)
                mkdir -p /etc/X11/xorg.conf.d
                cp $HOME/repo/linux_stuff/config-files/other/50-synaptics.conf /etc/X11/xorg.conf.d/50-synaptics.conf
            ;;
            Microphone)
                cp $HOME/repo/linux_stuff/config-files/other/alsa-base.conf /etc/modprobe.d/alsa-base.conf
            ;;
            CS:GO)
                if [[ -d $HOME/.steam/steam/steamapps/common/Counter-Strike\ Global\ Offensive/csgo/cfg ]]; then
                    cp $HOME/repo/linux_stuff/config-files/CS:GO/autoexec.cfg $HOME/.steam/steam/steamapps/common/Counter-Strike\ Global\ Offensive/csgo/cfg/
                else
                    whiptail --title "Arch config" --msgbox "Counter-Strike Global Offensive isn't installed" 20 70
                fi
            ;;
            Grub)
                vim /etc/default/grub
                grub-mkconfig -o /boot/grub/grub.cfg
            ;;
            Lid)
                cp $HOME/repo/linux_stuff/config-files/lid/logind.conf /etc/systemd/logind.conf
            ;;

        esac

    done < results

    fi 

    chown $USER $HOME -R

    whiptail --title "Arch config" --msgbox "System configured." 20 70
    exit 0
}

main_menu() 
{
	menu_item=$(whiptail --nocancel --title "Arch config" --menu "Menu Items:" 20 70 10 \
		"Clone repo"            "-" \
		"Config pacman"         "-" \
		"Install GUI"           "-" \
		"Install packages"      "-" \
		"Copy scripts"          "-" \
		"Config PC things"      "-" \
		"Exit"                  "-" 3>&1 1>&2 2>&3)

	case "$menu_item" in
	"Clone repo")
        repo_dirs
    ;;
	"Config pacman")
        config_pacman
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
	"Config PC things")
        config_pc
    ;;
	"Reboot System") 
        reboot
    ;;
	"Exit")
        whiptail --title "Arch config" --msgbox "System configured." 20 70
        exit 0
    ;;

	esac
}

info

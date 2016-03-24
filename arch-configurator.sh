#!/usr/bin/env bash

#==============================================================================
# Title             arch-configurator
# Description       This script will config installed Arch GNU/Linux system 
# Author            Michal Dudek 
# Notes             Run as a user
# License           GNU General Public License v3.0
#==============================================================================

#==============================================================================
# Global variables
ROOT_UID=0
GPU=""
DE=""
REPO="$HOME/repo/linux_stuff"   # Path to repository
CONF="$REPO/config-files"       # Path to config files
#==============================================================================

info()
{
    if [[ "$UID" == "$ROOT_UID"  ]]; then
        whiptail --title "Arch config" --msgbox \
        "Please run this script as a user" 20 70
        exit 126
    else
        if [[ ! -d $HOME/documents ]]; then
        if (whiptail --title "Creating directories" --yes-button "Yes" \
            --no-button "No" --yesno \
            "Create basic directories in your home?" 20 70)  then
        mkdir -p $HOME/repo
        mkdir -p $HOME/tmp
        mkdir -p $HOME/documents
        mkdir -p $HOME/music
        mkdir -p $HOME/movies
        mkdir -p $HOME/downloads
        mkdir -p $HOME/pictures
        fi
        fi

        main_menu
    fi
}

repo_dirs() 
{
    if [[ ! -d $REPO ]]; then
        if (whiptail --title "Cloning repository" --yes-button "Yes" \
            --no-button "No" --yesno \
            "Do you want to clone repo?\n \
            There are important files for this program\n\n \
            Repository: \ngithub.com/qeni/linux_stuff.git" 20 70) then

            # Creating repo dir and cloning repository
            if [[ ! -d $REPO ]]; then
                cd $HOME/repo
                sudo pacman -S git --noconfirm
                git clone https://github.com/qeni/linux_stuff.git
            fi
        fi
    else
        whiptail --title "Arch config" --msgbox "OK, $REPO exists already" 20 70
    fi

    config_pacman
}

config_pacman() 
{
    if (whiptail --title "Pacman config" --yes-button "Yes" --no-button "No" --yesno \
        "Do you want to edit pacman.conf?" 20 70) then
    
        sudo nano /etc/pacman.conf

        sudo pacman -Syu --noconfirm

    fi

    if (whiptail --title "Pacman config" --yes-button "Yes" --no-button "No" --yesno \
    "Do you want to install yaourt?" 20 70) then

        YAOURT_VER=$(whiptail --title  "Arch config" --menu "Select drivers:" 20 70 10 \
        "64bit"                 "" \
        "32bit"                 ""   3>&1 1>&2 2>&3)

        case "$YAOURT_VER" in
            "64bit")
                sudo sh -c "echo '[archlinuxfr]' >> /etc/pacman.conf"
                sudo sh -c "echo 'SigLevel = Never' >> /etc/pacman.conf"
                sudo sh -c "echo 'Server = http://repo.archlinux.fr/x86_64' >> /etc/pacman.conf"
            ;;
            "32bit")
                sudo sh -c "echo '[archlinuxfr]' >> /etc/pacman.conf"
                sudo sh -c "echo 'SigLevel = Never' >> /etc/pacman.conf"
                sudo sh -c "echo 'Server = http://repo.archlinux.fr/i686' >> /etc/pacman.conf"
            ;;
        esac

        sudo pacman -Syu --noconfirm
        sudo pacman -S yaourt --noconfirm

    fi


    config_gui
}

config_gui() 
{
    if (whiptail --title "Arch config" --yes-button "Yes" --no-button "No" --yesno \
        "Install graphics drivers now? \nDrivers for Intel, and Virtual Box guests" 20 70) then

        sudo pacman -S xorg-server xorg-server-utils mesa mesa-libgl xorg-xinit

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
                sudo pacman -S xf86-video-intel
            ;;
            "intel-multilib")
                sudo pacman -S xf86-video-intel lib32-mesa-libgl
            ;;
            "amd")
                sudo pacman -S xf86-video-ati 
            ;;
            "amd-multilib")
                sudo pacman -S xf86-video-ati lib32-mesa-libgl
            ;;
            "nvidia")
                sudo pacman -S nvidia nvidia-libgl nvidia-utils 
            ;;
            "nvidia-multilib")
                sudo pacman -S nvidia nvidia-libgl lib32-nvidia-libgl nvidia-utils lib32-nvidia-utils
            ;;
            "vbox")
                sudo pacman -S virtualbox-guest-utils virtualbox-guest-modules
                sudo cp $CONF/virtualbox/vbox.conf /etc/modules-load.d/vbox.conf
            ;;
        esac
    fi

    if (whiptail --title "Arch config" --yes-button "Yes" --no-button "No" --yesno \
        "Do you want to install a DE or WM?" 20 70) then

        DE=$(whiptail --title  "Arch config" --menu "Select environment:" 20 70 10 \
        "i3"                "" \
        "xfce"              "" \
        "gnome"             "" \
        "lxde"              ""   3>&1 1>&2 2>&3)

        case "$DE" in
        "i3")
            sudo pacman -S i3-wm i3status dmenu terminus-font \
            tamsyn-font alsa-utils feh rxvt-unicode udiskie --noconfirm
            yaourt -S ttf-font-awesome xcalib --noconfirm
            mkdir -p $HOME/.i3
            mkdir -p $HOME/.config/i3status
            mkdir -p $HOME/.config/i3/
            cp $CONF/i3/hide.i3status.conf $HOME/.i3status.conf
            cp $CONF/i3/arch-config $HOME/.i3/config
            # cp $CONF/i3/workspace* $HOME/.i3/
            # cp $CONF/i3/load_workspaces.sh $HOME/.i3/
            # chmod +x $HOME/.i3/load_workspaces.sh

            cp $CONF/i3/i3lock-arch.png $HOME/Pictures/i3lock-arch.png
            cp $CONF/wallpapers/arch-wallpaper.jpg $HOME/Pictures/wallpaper.png
            cp $CONF/xinit/hide.xinitrc $HOME/.xinitrc
            nano $HOME/.xinitrc
        ;;
        "lxde")
            sudo pacman -S lxde faenza-icon-theme --noconfirm
            cp $CONF/openbox/rc.xml $HOME/.config/openbox/lxde-rc.xml
            cp $CONF/lxde/panel $HOME/.config/lxpanel/LXDE/panels/panel
            sudo cp $CONF/scripts/run-cmus /usr/local/bin/
            cp $CONF/xinit/hide.xinitrc $HOME/.xinitrc
            nano $HOME/.xinitrc
            cp $CONF/xterm/hide.Xresources $HOME/.Xresources
            xrdb -merge $HOME/.Xresources 
        ;;
        "xfce")
            sudo pacman -S xfwm4 --noconfirm
            cp $CONF/xinit/hide.xinitrc $HOME/.xinitrc
            nano $HOME/.xinitrc
        ;;
        "gnome")
            sudo pacman -S gnome --noconfirm
            cp $CONF/xinit/hide.xinitrc $HOME/.xinitrc
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
        "alsi"                          "System Info" OFF \
        "bash"                          "Shell" OFF \
        "brasero"                       "Burning app" OFF \
        "calcurse"                      "Text-based organizer" OFF \
        "cmus"                          "Music player" OFF \
        "conky"                         "System Info" OFF \
        "emacs-nox"                     "GNU Editor" OFF \
        "faenza-icon-theme"             "Icon Theme" OFF \
        "feh"                           "Image Viewer" OFF \
        "firefox"                       "Web Browser" OFF \
        "fuck"                          "Command correcting" OFF \
        "git"                           "Content tracker" OFF \
        "htop"                          "Process Info" OFF \
        "libreoffice"                   "Libre Office" OFF \
        "lightdm"                       "Login Manager" OFF \
        "links"                         "Web Browser" OFF \
        "lxrandr"                       "Output manager" OFF \
        "mc"                            "Midnight Commander" OFF \
        "moc"                           "Music Player" OFF \
        "mps-youtube"                   "Youtube in console" OFF \
        "mpv"                           "Video Player" OFF \
        "mutt"                          "Mail Client" OFF \
        "ncurses"                       "ncurses library" OFF \
        "nethack"                       "Roguelike game" OFF \
        "newsbeuter"                    "RSS feed reader" OFF \
        "nmap"                          "Network Mapper" OFF \
        "openssh"                       "Secure Shell" OFF \
        "pavucontrol"                   "Sound output" OFF \
        "pinta"                         "Image Editor" OFF \
        "ranger"                        "File manager" OFF \
        "rtorrent"                      "Torrent Client" OFF \
        "rxvt-unicode"                  "Terminal emulator" OFF \
        "scrot"                         "Screenshots" OFF \
        "texmaker"                      "LaTeX Editor" OFF \
        "tor"                           "Communication System" OFF \
        "tree"                          "Tree of dirs" OFF \
        "udiskie"                       "Automounting devices" OFF \
        "ufw"                           "Firewall" OFF \
        "unpacking"                     "Archive tools" OFF \
        "uzbl"                          "Web Browser" OFF \
        "vim"                           "Vim with scripts support" OFF \
        "virtualbox"                    "Virtual Machines" OFF \
        "weechat"                       "IRC Client" OFF \
        "xcalib"                        "Screen brightness" OFF \
        "xboxdrv"                       "Xbox pad driver" OFF \
        "xf86-input"                    "Touchpad driver" OFF \
        "xorg"                          "X Server" OFF \
        "youtube-dl"                    "YT Downloader" OFF \
        "zathura"                       "PDF Viewer" OFF \
        "zsh"                           "Z-shell" OFF 2>results)

        while read choice
        do
        case $choice in
        alsi)
            sudo pacman -S alsi --noconfirm
        ;;
        alsa-utils)
            sudo pacman -S alsa-utils --noconfirm
        ;;
        bash)
            SHELL="BASH"

            sudo pacman -S colordiff bash --noconfirm
            cp $CONF/bash/arch-bashrc $HOME/.bashrc
            chsh -s /bin/bash
        ;;
        brasero)
            sudo pacman -S brasero --noconfirm
        ;;
        calcurse)
            sudo pacman -S calcurse --noconfirm
        ;;
        cmus)
            sudo pacman -S cmus --noconfirm
            mkdir -p $HOME/.cmus
            cp $CONF/cmus/zenburn.theme $HOME/.cmus/
            cp $CONF/cmus/solarized.theme $HOME/.cmus/
        ;;
        conky)
            sudo pacman -S conky --noconfirm

            CONKY=$(whiptail --title  "Arch config" --menu "Select conky file:" 20 70 10 \
            "red"               "all informations" \
            "binary"            "binary clock" \
            "indicator"         "desktop indicator" 3>&1 1>&2 2>&3)

            case "$CONKY" in
                "red")
                    cp $CONF/conky/hide.conkyrc $HOME/.conkyrc
                    sudo cp $CONF/conky/hoog0555_cyr2.ttf /usr/share/fonts/truetype/ 
                ;;
                "binary")
                    cp $CONF/conky/binary-clock $HOME/.conkyrc
                ;;
                "indicator")
                    pacman -S bc --noconfirm
                    cp $CONF/conky/workspace-indicator $HOME/.conkyrc
                ;;
            esac
        ;;
        emacs-nox)
            sudo pacman -S emacs-nox --noconfirm
            mkdir -p $HOME/.emacs.d/src
            cp $CONF/emacs/init.el $HOME/.emacs.d/
            cp -r $CONF/emacs/src/* $HOME/.emacs.d/src/
        ;;
        faenza-icon-theme)
            sudo pacman -S faenza-icon-theme --noconfirm
        ;;
        feh)
            sudo pacman -S feh --noconfirm
        ;;
        firefox)
            sudo pacman -S firefox --noconfirm
        ;;
        fuck)
            sudo pacman -S thefuck
        ;;
        git)
            sudo pacman -S git --noconfirm
            name=$(whiptail --nocancel --inputbox "Set git username:" 20 70 "<name>" 3>&1 1>&2 2>&3)
            git config --global user.name "$name"
            mail=$(whiptail --nocancel --inputbox "Set git usermail:" 20 70 "<mail>" 3>&1 1>&2 2>&3)
            git config --global user.email $mail
            edit=$(whiptail --nocancel --inputbox "Set git text editor:" 20 70 "vim" 3>&1 1>&2 2>&3)
            git config --global core.editor $edit
        ;;
        htop)
            sudo pacman -S htop --noconfirm
        ;;
        libreoffice)
            sudo pacman -S libreoffice-still --noconfirm
        ;;
        lightdm)
            sudo pacman -S lightdm --noconfirm
        ;;
        links)
            sudo pacman -S links --noconfirm
            mkdir -p $HOME/.links
            cp $CONF/links/* $HOME/.links/
        ;;
        lxrandr)
            sudo pacman -S lxrandr --noconfirm
        ;;
        mc)
            sudo pacman -S mc --noconfirm
            mkdir -p $HOME/.config/mc
            mkdir -p $HOME/.local/share/mc/skins
            cp $CONF/midnight-commander/mc.ext $HOME/.config/mc/mc.ext
            cp $CONF/midnight-commander/darkcourses_green.ini $HOME/.local/share/mc/skins/
        ;;
        moc)
            sudo pacman -S moc --noconfirm
            mkdir -p $HOME/.moc
            mkdir -p $HOME/.moc/themes
            cp $CONF/moc/arch-config $HOME/.moc/config
            cp $CONF/moc/* $HOME/.moc/themes/
        ;;
        mps-youtube)
            sudo pacman -S aalib libcaca mpv --noconfirm
            sudo yaourt -S mps-youtube
        ;;
        mpv)
            sudo pacman -S mpv --noconfirm
        ;;
        mutt)
            sudo pacman -S mutt abook --noconfirm
            cp $CONF/mutt/hide.muttrc $HOME/.muttrc
            mkdir -p $HOME/.mutt
            cp $CONF/mutt/account* $HOME/.mutt/
        ;;
        ncurses)
            sudo pacman -S ncurses --noconfirm
        ;;
        nethack)
            sudo pacman -S nethack --noconfirm
            sudo mkdir -p /var/games/nethack
            cp $CONF/nethack/hide.nethackrc $HOME/.nethackrc
            sudo cp $CONF/nethack/record /var/games/nethack/record
        ;;
        newsbeuter)
            sudo pacman -S newsbeuter --noconfirm
            mkdir -p $HOME/.config/newsbeuter
            cp $CONF/newsbeuter/arch-urls $HOME/.config/newsbeuter/urls
            cp $CONF/newsbeuter/arch-config $HOME/.config/newsbeuter/config
        ;;
        nmap)
            sudo pacman -S nmap --noconfirm
        ;;
        unpacking)
            sudo pacman -S p7zip unrar unzip zip --noconfirm
        ;;
        pavucontrol)
            sudo pacman -S pavucontrol --noconfirm
        ;;
        pinta)
            sudo pacman -S pinta --noconfirm
        ;;
        scrot)
            sudo pacman -S scrot --noconfirm
        ;;
        texmaker)
            sudo pacman -S texmaker texlive-core texlive-lang --noconfirm
        ;;
        tor)
            sudo pacman -S tor torbrowser-launcher --noconfirm
        ;;
        ranger)
            sudo pacman -S w3m w3m-img ranger --noconfirm
            mkdir -p $HOME/.config/ranger
            mkdir -p $HOME/.config/ranger/colorschemes
            cp $CONF/ranger/solarized.py $HOME/.config/ranger/colorschemes/
            cp $CONF/ranger/arch-rc.conf $HOME/.config/ranger/rc.conf
        ;;
        ufw)
            sudo pacman -S ufw --noconfirm
            sudo ufw enable
        ;;
        weechat)
            sudo pacman -S weechat --noconfirm
            mkdir -p $HOME/.weechat
            cp $CONF/weechat/* $HOME/.weechat/
            rm -f $HOME/.weechat/weechat.log
            ln -s /dev/null weechat.log
        ;;
        openssh)
            sudo pacman -S openssh--noconfirm
            sudo iptables -I INPUT -p tcp --dport 22 -j ACCEPT
            sudo /etc/init.d/ssh restart
            sudo export DISPLAY=:0
        ;;
        rtorrent)
            sudo pacman -S rtorrent --noconfirm
            mkdir -p $HOME/.rtorrent
            cp $CONF/rtorrent/hide.rtorrent-arch.rc $HOME/.rtorrent.rc
        ;;
        rxvt-unicode)
            sudo pacman -S rxvt-unicode --noconfirm
            cp $CONF/rxvt/hide.Xresources $HOME/.Xresources
            xrdb -merge $HOME/.Xresources 
        ;;
        uzbl)
            sudo pacman -S uzbl-browser --noconfirm
            cp $CONF/uzbl/config $HOME/.config/uzbl/config
            cp $CONF/dwb/bookmarks $HOME/.local/share/uzbl/bookmarks
        ;;
        virtualbox)
            sudo pacman -S virtualbox virtualbox-host-modules virtualbox-guest-iso --noconfirm
        ;;
        youtube-dl)
            sudo pacman -S youtube-dl --noconfirm
        ;;
        xboxdrv)
            yaourt -S xboxdrv --noconfirm
            sudo sh -c "echo 'blacklist xpad' >> /etc/modprobe.d/blacklist"
            sudo rmmod xpad
        ;;
        xcalib)
            yaourt -S xcalib --noconfirm
        ;;
        xf86-input)
            sudo pacman -S xf86-input-synaptics --noconfirm
        ;;
        xorg)
            sudo pacman -S xorg-server xorg-xinit --noconfirm
        ;;
        zathura)
            sudo pacman -S zathura zathura-pdf-poppler --noconfirm
        ;;
        zsh)
            SHELL="ZSH"

            sudo pacman -S colordiff zsh acpi alsi --noconfirm
            cp $CONF/zsh/arch-zshrc $HOME/.zshrc
            chsh -s /bin/zsh
        ;;
        vim)
            #==============================================================
            # Plugin list:
            #   Pathogen
            #   Nerdtree
            #   Syntastic
            #   Tagbar
            #   GitGutter
            #   Vim-airline
            #   Auto-pairs
            #   Supertab
            #   Neosnippet
            #   indentLine
            #   CtrlP
            #   Vim-commentary
            #   neocomplete
            #==============================================================

            sudo pacman -S vim cmake curl ctags lua

            # Making dirs
            mkdir -p $HOME/tmp $HOME/.vim/autoload $HOME/.vim/bundle $HOME/.vim/colors

            # Pathogen
            curl -LSso $HOME/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

            # Supertab
            cd $HOME/.vim/bundle && \
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

            # Tagbar
            cd $HOME/.vim/bundle && \
            git clone https://github.com/majutsushi/tagbar

            # Auto-pairs
            cd $HOME/.vim/bundle && \
            git clone git://github.com/jiangmiao/auto-pairs.git

            # Neosnippet
            cd $HOME/.vim/bundle
            git clone https://github.com/Shougo/neosnippet.vim
            git clone https://github.com/Shougo/neosnippet-snippets
            cp $CONF/vim/python.snip $HOME/.vim/bundle/neosnippet-snippets/neosnippets/python.snip

            # Indent-line
            cd $HOME/.vim/bundle
            git clone https://github.com/Yggdroot/indentLine.git

            # CtrlP
            cd $HOME/.vim/bundle
            git clone https://github.com/kien/ctrlp.vim.git

            # Vim-commentary
            cd $HOME/.vim/bundle
            git clone https://github.com/tpope/vim-commentary.git

            # neocomplete
            cd $HOME/.vim/bundle/
            git clone https://github.com/Shougo/neocomplete.vim

            # Copying themes
            cp $CONF/vim/colors/* $HOME/.vim/colors/

            # Copying .vimrc
            cp $CONF/vim/hide.vimrc $HOME/.vimrc
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
        "live-usb" 			"Make bootable usb" OFF \
		"run-mc" 			"Running midnight commander" OFF \
        "take-screenshot" 	"Easier screenshots" OFF \
        "run-wicd" 	        "Run wicd daemon and app" OFF \
        "run-emacs" 		"Running Emacs" OFF 2>results)

        while read choice
        do
            case $choice in
            live-usb)
                sudo cp $CONF/scripts/live-usb /usr/local/bin/
                sudo chmod +x /usr/local/bin/live-usb
            ;;
            run-mc)
                sudo cp $CONF/scripts/run-mc /usr/local/bin/
                sudo chmod +x /usr/local/bin/run-mc
            ;;
            take-screenshot)
                sudo cp $CONF/scripts/take-screenshot /usr/local/bin/
                sudo cp $CONF/scripts/take-screenshot-s /usr/local/bin/
                sudo chmod +x /usr/local/bin/take-screenshot
                sudo chmod +x /usr/local/bin/take-screenshot-s
            ;;
            run-wicd)
                sudo cp $CONF/scripts/run-wicd /usr/local/bin/
                sudo chmod +x /usr/local/bin/run-wicd
            ;;
            run-emacs)
                sudo cp $CONF/scripts/run-emacs /usr/local/bin/
                sudo chmod +x /usr/local/bin/run-emacs
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
    "Font" "Set TTY font to Terminus" OFF \
    "Lid" "Don't suspend laptop when lid closed" off 2>results)

    while read choice
    do
    case $choice in
        Beep)
            sudo rmmod pcspkr
            sudo sh -c "echo 'blacklist pcspkr' >> /etc/modprobe.d/blacklist"
        ;;
        Touchpad)
            sudo pacman -S xf86-input-synaptics --noconfirm
            sudo mkdir -p /etc/X11/xorg.conf.d
            sudo cp $CONF/other/50-synaptics.conf /etc/X11/xorg.conf.d/50-synaptics.conf
        ;;
        Microphone)
            sudo cp $CONF/other/alsa-base.conf /etc/modprobe.d/alsa-base.conf
        ;;
        Font)
            sudo pacman -S terminus-font
            sudo cp $CONF/other/vconsole.conf /etc/vconsole.conf
            setfont /usr/share/kbd/consolefonts/ter-v12n.psf.gz
        ;;
        Lid)
            sudo cp $CONF/lid/logind.conf /etc/systemd/logind.conf
        ;;

    esac

    done < results

    fi 

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

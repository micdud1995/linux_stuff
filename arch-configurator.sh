#!/usr/bin/env bash

#==============================================================================
# Title             arch-configurator
# Description       This script will config installed Arch GNU/Linux system 
# Notes             Run as a user
# License           GNU General Public License v3.0
#==============================================================================

#==============================================================================
# Global variables
ROOT_UID=0
REPO="$HOME/repo/linux_stuff"       # Path to repository
CONF="$REPO/config-files"           # Path to config files
FLAGS_PACMAN="--noconfirm --needed" # Flags for pacman
LOG_FILE="history.log"              # File with logs
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
            mkdir -p $HOME/pictures/screenshots
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
                sudo pacman -S git $FLAGS_PACMAN
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
    if (whiptail --title "Pacman config" --yes-button "Yes" --no-button "No" \
    --yesno "Do you want to edit pacman.conf?" 20 70) then
    
        sudo nano /etc/pacman.conf
        sudo pacman -Syu $FLAGS_PACMAN
    fi

    if (whiptail --title "Pacman config" \
    --yes-button "Yes" --no-button "No" --yesno \
    "Do you want to install yaourt?" 20 70) then

        YAOURT_VER=$(whiptail --title  "Arch config" \
        --menu "Select drivers:" 20 70 10 \
        "64bit"     "" \
        "32bit"     ""   3>&1 1>&2 2>&3)

        case "$YAOURT_VER" in
            "64bit")
                sudo sh -c "echo '[archlinuxfr]' >> /etc/pacman.conf"
                sudo sh -c "echo 'SigLevel = Never' >> /etc/pacman.conf"
                sudo sh -c "echo \
                'Server = http://repo.archlinux.fr/x86_64' >> /etc/pacman.conf"
            ;;
            "32bit")
                sudo sh -c "echo '[archlinuxfr]' >> /etc/pacman.conf"
                sudo sh -c "echo 'SigLevel = Never' >> /etc/pacman.conf"
                sudo sh -c "echo \
                'Server = http://repo.archlinux.fr/i686' >> /etc/pacman.conf"
            ;;
        esac

        sudo pacman -Syu $FLAGS_PACMAN
        sudo pacman -S yaourt $FLAGS_PACMAN

    fi

    config_gui
}

config_gui() 
{
    if (whiptail --title "Arch config" \
    --yes-button "Yes" --no-button "No" --yesno \
    "Install graphics drivers now? \n \
    Drivers for Intel, and Virtual Box guests" 20 70) then

        sudo pacman -S xorg-server xorg-server-utils mesa mesa-libgl \
        xorg-xinit $FLAGS_PACMAN

        DRIVERS=$(whiptail --title  "Arch config" --menu \
        "Select drivers:" 20 70 10 \
        "intel"                 "" \
        "intel-multilib"        "" \
        "amd"                   "" \
        "amd-multilib"          "" \
        "nvidia"                "" \
        "nvidia-multilib"       "" \
        "vbox"                  ""   3>&1 1>&2 2>&3)

        case "$DRIVERS" in
            "intel")
                sudo pacman -S xf86-video-intel $FLAGS_PACMAN
            ;;
            "intel-multilib")
                sudo pacman -S xf86-video-intel lib32-mesa-libgl $FLAGS_PACMAN
            ;;
            "amd")
                sudo pacman -S xf86-video-ati $FLAGS_PACMAN
            ;;
            "amd-multilib")
                sudo pacman -S xf86-video-ati lib32-mesa-libgl $FLAGS_PACMAN
            ;;
            "nvidia")
                sudo pacman -S nvidia nvidia-libgl nvidia-utils $FLAGS_PACMAN
            ;;
            "nvidia-multilib")
                sudo pacman -S nvidia nvidia-libgl lib32-nvidia-libgl \
                nvidia-utils lib32-nvidia-utils $FLAGS_PACMAN
            ;;
            "vbox")
                sudo pacman -S virtualbox-guest-utils \
                virtualbox-guest-modules $FLAGS_PACMAN
                sudo cp $CONF/virtualbox/vbox.conf /etc/modules-load.d/vbox.conf
            ;;
        esac
    fi

    if (whiptail --title "Arch config" \
    --yes-button "Yes" --no-button "No" --yesno \
    "Do you want to install a DE or WM?" 20 70) then

        DE=$(whiptail --title  "Arch config" \
        --menu "Select environment:" 20 70 10 \
        "awesome"           "" \
        "i3"                "" \
        "xfce"              "" \
        "gnome"             "" \
        "lxde"              ""   3>&1 1>&2 2>&3)

        case "$DE" in
        "awesome")
            mkdir -p $HOME/.config/awesome
            mkdir -p $HOME/pictures
            sudo pacman -S awesome terminus-font alsa-utils xterm faenza-icon-theme feh $FLAGS_PACMAN
            yaourt -S xcalib ttf-font-awesome $FLAGS_PACMAN
            cp $CONF/awesome/* $HOME/.config/awesome/
            cp $CONF/xinit/hide.xinitrc $HOME/.xinitrc
            cp $CONF/wallpapers/arch-wallpaper.png $HOME/pictures/wallpaper.png
        ;;
        "i3")
            sudo pacman -S i3-wm i3status dmenu terminus-font \
            alsa-utils feh udiskie xterm $FLAGS_PACMAN
            yaourt -S ttf-font-awesome xcalib $FLAGS_PACMAN
            mkdir -p $HOME/.i3
            mkdir -p $HOME/.config/i3/
            cp $CONF/i3/hide.i3status.conf $HOME/.i3status.conf
            cp $CONF/i3/arch-config $HOME/.i3/config

            cp $CONF/i3/i3lock-arch.png $HOME/pictures/i3lock-arch.png
            cp $CONF/wallpapers/arch-wallpaper.png $HOME/pictures/wallpaper.png
            cp $CONF/xinit/hide.xinitrc $HOME/.xinitrc
            nano $HOME/.xinitrc
        ;;
        "lxde")
            sudo pacman -S lxde faenza-icon-theme $FLAGS_PACMAN
            cp $CONF/lxde/lxde-rc.xml $HOME/.config/openbox/lxde-rc.xml
            cp $CONF/lxde/panel $HOME/.config/lxpanel/LXDE/panels/panel
            sudo cp -R $CONF/lxde/Onyx /usr/share/themes/
            sudo cp -R $CONF/lxde/Flat-Adapta-OSX /usr/share/themes/
            sudo cp -R $CONF/lxde/Ardoise_shadow_100 /usr/share/icons/
            sudo cp $CONF/scripts/run-st /usr/local/bin/
            cp $CONF/xinit/hide.xinitrc $HOME/.xinitrc
            nano $HOME/.xinitrc
        ;;
        "xfce")
            sudo pacman -S xfwm4 $FLAGS_PACMAN
            cp $CONF/xinit/hide.xinitrc $HOME/.xinitrc
            nano $HOME/.xinitrc
        ;;
        "gnome")
            sudo pacman -S gnome $FLAGS_PACMAN
            cp $CONF/xinit/hide.xinitrc $HOME/.xinitrc
            nano $HOME/.xinitrc
        ;;
        esac
    fi

    config_packages
}

config_packages() 
{
    if (whiptail --title "Arch config" \
    --yes-button "Yes" --no-button "No" --yesno \
    "Do you want to install/config some common software?" 20 70) then

    (whiptail --title "Additional software" --separate-output --checklist \
    "Choose your desired software \nUse spacebar to check/uncheck \npress enter when finished" 20 70 14 \
    "alpine"                "Mail client" OFF \
    "alsa-utils"            "Sound" OFF \
    "alsi"                  "System Info" OFF \
    "artha"                 "Thesaurus" OFF \
    "bash"                  "Shell" OFF \
    "brasero"               "Burning app" OFF \
    "conky"                 "System Info" OFF \
    "emacs-nox"             "GNU Editor" OFF \
    "feh"                   "Image Viewer" OFF \
    "firefox"               "Web Browser" OFF \
    "fprintd"               "Fingerprint reader" OFF \
    "fuck"                  "Command correcting" OFF \
    "hexchat"               "IRC client" OFF \
    "git"                   "Content tracker" OFF \
    "htop"                  "Process Info" OFF \
    "libreoffice"           "Libre Office" OFF \
    "links"                 "Web Browser" OFF \
    "lxrandr"               "Output manager" OFF \
    "mc"                    "Midnight Commander" OFF \
    "moc"                   "Music Player" OFF \
    "mps-youtube"           "Youtube in console" OFF \
    "mpv"                   "Video Player" OFF \
    "mutt"                  "Mail Client" OFF \
    "ncurses"               "ncurses library" OFF \
    "nethack"               "Roguelike game" OFF \
    "newsbeuter"            "RSS feed reader" OFF \
    "openssh"               "Secure Shell" OFF \
    "pavucontrol"           "Sound output" OFF \
    "pinta"                 "Image Editor" OFF \
    "ranger"                "File manager" OFF \
    "rtorrent"              "Torrent Client" OFF \
    "scrot"                 "Screenshots" OFF \
    "st"                    "simple terminal" OFF \
    "texmaker"              "LaTeX Editor" OFF \
    "tor"                   "Communication System" OFF \
    "udiskie"               "Automounting devices" OFF \
    "ufw"                   "Firewall" OFF \
    "unpacking"             "Archive tools" OFF \
    "uzbl"                  "Web Browser" OFF \
    "vim"                   "Vim with scripts support" OFF \
    "vim-minimal"           "Vim config without plugins" OFF \
    "virtualbox"            "Virtual Machines" OFF \
    "vrms-arch"             "Virtual RMS" OFF \
    "weechat"               "IRC Client" OFF \
    "xf86-input"            "Touchpad driver" OFF \
    "xorg"                  "X Server" OFF \
    "xterm"                 "Terminal Emulator" OFF \
    "youtube-dl"            "YT Downloader" OFF \
    "zathura"               "PDF Viewer" OFF \
    "zsh"                   "Z-shell" OFF 2>$LOG_FILE)

    while read choice
    do
    case $choice in
    alpine)
        yaourt -S alpine $FLAGS_PACMAN
        cp $CONF/alpine/hide.pinerc $HOME/.pinerc
    ;;
    alsa-utils)
        sudo pacman -S alsa-utils $FLAGS_PACMAN
    ;;
    alsi)
        sudo pacman -S alsi $FLAGS_PACMAN
    ;;
    artha)
        yaourt -S artha $FLAGS_PACMAN
    ;;
    bash)
        sudo pacman -S colordiff bash $FLAGS_PACMAN
        cp $CONF/bash/arch-bashrc $HOME/.bashrc
        chsh -s /bin/bash
    ;;
    brasero)
        sudo pacman -S brasero $FLAGS_PACMAN
    ;;
    conky)
        sudo pacman -S conky $FLAGS_PACMAN

        CONKY=$(whiptail --title  "Arch config" --menu \
        "Select conky file:" 20 70 10 \
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
                pacman -S bc $FLAGS_PACMAN
                cp $CONF/conky/workspace-indicator $HOME/.conkyrc
            ;;
        esac
    ;;
    emacs-nox)
        sudo pacman -S emacs-nox $FLAGS_PACMAN
        mkdir -p $HOME/.emacs.d/src
        cp $CONF/emacs/init.el $HOME/.emacs.d/
        cp -r $CONF/emacs/src/* $HOME/.emacs.d/src/
    ;;
    feh)
        sudo pacman -S feh $FLAGS_PACMAN
    ;;
    firefox)
        sudo pacman -S firefox $FLAGS_PACMAN
    ;;
    fprintd)
        sudo pacman -S fprintd $FLAGS_PACMAN
        sudo cp $CONF/other/system-local-login /etc/pam.d/system-local-login
        fprintd-enroll
    ;;
    fuck)
        sudo pacman -S thefuck $FLAGS_PACMAN
    ;;
    hexchat)
        sudo pacman -S hexchat $FLAGS_PACMAN
        mkdir $HOME/.config/hexchat
        cp $CONF/hexchat/* $HOME/.config/hexchat/
    ;;
    git)
        sudo pacman -S git $FLAGS_PACMAN
        name=$(whiptail --nocancel --inputbox "Set git username:" 20 70 "<name>" 3>&1 1>&2 2>&3)
        git config --global user.name "$name"
        mail=$(whiptail --nocancel --inputbox "Set git usermail:" 20 70 "<mail>" 3>&1 1>&2 2>&3)
        git config --global user.email $mail
        edit=$(whiptail --nocancel --inputbox "Set git text editor:" 20 70 "vim" 3>&1 1>&2 2>&3)
        git config --global core.editor $edit
    ;;
    htop)
        sudo pacman -S htop $FLAGS_PACMAN
    ;;
    libreoffice)
        sudo pacman -S libreoffice-still $FLAGS_PACMAN
    ;;
    links)
        sudo pacman -S links $FLAGS_PACMAN
        mkdir -p $HOME/.links
        cp $CONF/links/* $HOME/.links/
    ;;
    lxrandr)
        sudo pacman -S lxrandr $FLAGS_PACMAN
    ;;
    mc)
        sudo pacman -S mc $FLAGS_PACMAN
        mkdir -p $HOME/.config/mc
        mkdir -p $HOME/.local/share/mc/skins
        cp $CONF/midnight-commander/mc.ext $HOME/.config/mc/mc.ext
        cp $CONF/midnight-commander/darkcourses_green.ini $HOME/.local/share/mc/skins/
        cp $CONF/midnight-commander/cyan_love.ini $HOME/.local/share/mc/skins/
    ;;
    moc)
        sudo pacman -S moc $FLAGS_PACMAN
        mkdir -p $HOME/.moc
        mkdir -p $HOME/.moc/themes
        cp $CONF/moc/arch-config $HOME/.moc/config
        cp $CONF/moc/* $HOME/.moc/themes/
    ;;
    mps-youtube)
        sudo pacman -S aalib libcaca mpv $FLAGS_PACMAN
        yaourt -S mps-youtube-git
    ;;
    mpv)
        sudo pacman -S mpv $FLAGS_PACMAN
    ;;
    mutt)
        sudo pacman -S mutt abook $FLAGS_PACMAN
        cp $CONF/mutt/hide.muttrc $HOME/.muttrc
        mkdir -p $HOME/.mutt
        cp $CONF/mutt/account* $HOME/.mutt/
    ;;
    ncurses)
        sudo pacman -S ncurses $FLAGS_PACMAN
    ;;
    nethack)
        sudo pacman -S nethack $FLAGS_PACMAN
        sudo mkdir -p /var/games/nethack
        cp $CONF/nethack/hide.nethackrc $HOME/.nethackrc
        sudo cp $CONF/nethack/record /var/games/nethack/record
    ;;
    newsbeuter)
        sudo pacman -S newsbeuter $FLAGS_PACMAN
        mkdir -p $HOME/.config/newsbeuter
        cp $CONF/newsbeuter/arch-urls $HOME/.config/newsbeuter/urls
        cp $CONF/newsbeuter/arch-config $HOME/.config/newsbeuter/config
    ;;
    unpacking)
        sudo pacman -S p7zip unrar unzip zip $FLAGS_PACMAN
    ;;
    pavucontrol)
        sudo pacman -S pavucontrol $FLAGS_PACMAN
    ;;
    pinta)
        sudo pacman -S pinta $FLAGS_PACMAN
    ;;
    scrot)
        sudo pacman -S scrot $FLAGS_PACMAN
    ;;
    st)
        sudo pacman -S pkg-config terminus-font $FLAGS_PACMAN
        cd $HOME/repo 
        git clone git://git.suckless.org/st
        cd $HOME/repo/st
        cp $CONF/st/config.h $HOME/repo/st
        sudo make clean install
    ;;
    texmaker)
        sudo pacman -S texmaker texlive-core texlive-lang $FLAGS_PACMAN
    ;;
    tor)
        sudo pacman -S tor proxychains-ng $FLAGS_PACMAN
        sudo systemctl enable tor.service
        sudo systemctl start tor.service
    ;;
    ranger)
        sudo pacman -S w3m ranger $FLAGS_PACMAN
        mkdir -p $HOME/.config/ranger
        mkdir -p $HOME/.config/ranger/colorschemes
        cp $CONF/ranger/arch-rc.conf $HOME/.config/ranger/rc.conf
    ;;
    ufw)
        sudo pacman -S ufw $FLAGS_PACMAN
        sudo ufw enable
    ;;
    weechat)
        sudo pacman -S weechat $FLAGS_PACMAN
        mkdir -p $HOME/.weechat
        cp $CONF/weechat/* $HOME/.weechat/
    ;;
    openssh)
        sudo pacman -S openssh $FLAGS_PACMAN
        sudo iptables -I INPUT -p tcp --dport 22 -j ACCEPT
        sudo export DISPLAY=:0
    ;;
    rtorrent)
        sudo pacman -S rtorrent $FLAGS_PACMAN
        mkdir -p $HOME/.rtorrent
        cp $CONF/rtorrent/hide.rtorrent-arch.rc $HOME/.rtorrent.rc
    ;;
    uzbl)
        sudo pacman -S uzbl-browser $FLAGS_PACMAN
        cp $CONF/uzbl/config $HOME/.config/uzbl/config
        cp $CONF/uzbl/bookmarks $HOME/.local/share/uzbl/bookmarks
    ;;
    virtualbox)
        sudo pacman -S virtualbox virtualbox-host-modules virtualbox-guest-iso $FLAGS_PACMAN
    ;;
    vrms-arch)
        yaourt -S vrms-arch $FLAGS_PACMAN
    ;;
    youtube-dl)
        sudo pacman -S youtube-dl $FLAGS_PACMAN
    ;;
    xf86-input)
        sudo pacman -S xf86-input-synaptics $FLAGS_PACMAN
    ;;
    xorg)
        sudo pacman -S xorg-server xorg-xinit $FLAGS_PACMAN
    ;;
    xterm)
        sudo pacman -S xterm $FLAGS_PACMAN
        cp $HOME/repo/linux_stuff/config-files/xterm/hide.Xresources $HOME/.Xresources
        xrdb -merge $HOME/.Xresources 
    ;;
    zathura)
        sudo pacman -S zathura zathura-pdf-poppler $FLAGS_PACMAN
        mkdir -p $HOME/.config/zathura
        cp $CONF/zathura/zathurarc $HOME/.config/zathura/ 
    ;;
    zsh)
        sudo pacman -S colordiff zsh acpi alsi $FLAGS_PACMAN
        cp $CONF/zsh/arch-zshrc $HOME/.zshrc
        chsh -s /bin/zsh $USER
    ;;
    vim-minimal)
        sudo pacman -S vim $FLAGS_PACMAN
        cp $CONF/vim/hide.vimrc-minimal $HOME/.vimrc
    ;;
    vim)
        #==============================================================
        # Plugin list:
        #   Pathogen
        #   Nerdtree
        #   Syntastic
        #   Tagbar
        #   Auto-pairs
        #   Neosnippet
        #   Vim-commentary
        #   neocomplete
        #   undotree 
        #==============================================================

        sudo pacman -S vim cmake curl ctags lua $FLAGS_PACMAN

        # Making dirs
        mkdir -p $HOME/tmp $HOME/.vim/autoload $HOME/.vim/bundle $HOME/.vim/colors

        # Pathogen
        curl -LSso $HOME/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

        # Syntastic
        cd $HOME/.vim/bundle && \
        git clone https://github.com/scrooloose/syntastic.git

        # Nerdtree
        cd $HOME/.vim/bundle && \
        git clone https://github.com/scrooloose/nerdtree.git

        # Tagbar
        cd $HOME/.vim/bundle && \
        git clone https://github.com/majutsushi/tagbar

        # Auto-pairs
        cd $HOME/.vim/bundle && \
        git clone git://github.com/jiangmiao/auto-pairs.git

        # Neosnippet
        # cd $HOME/.vim/bundle && \
        # git clone https://github.com/Shougo/neosnippet.vim
        # git clone https://github.com/Shougo/neosnippet-snippets
        # cp $CONF/vim/python.snip $HOME/.vim/bundle/neosnippet-snippets/neosnippets/python.snip

        # Vim-commentary
        cd $HOME/.vim/bundle && \
        git clone https://github.com/tpope/vim-commentary.git

        # neocomplete
        cd $HOME/.vim/bundle && \
        git clone https://github.com/Shougo/neocomplete.vim

        # undotree
        cd $HOME/.vim/bundle && \
        git clone https://github.com/mbbill/undotree

        # Copying theme
        cp $CONF/vim/colors/256_noir.vim $HOME/.vim/colors/

        # Copying .vimrc
        cp $CONF/vim/hide.vimrc $HOME/.vimrc
        cp $CONF/vim/hide.vimrc-minimal $HOME/.vimrc-minimal
    ;;
    esac
    done < $LOG_FILE

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
		"run-st" 			"Running simple terminal" OFF \
        "take-screenshot" 	"Easier screenshots" OFF \
        "run-wicd" 	        "Run wicd daemon and app" OFF \
        "run-emacs" 		"Running Emacs" OFF 2>$LOG_FILE)

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
            run-st)
                sudo cp $CONF/scripts/run-st /usr/local/bin/
                sudo chmod +x /usr/local/bin/run-st
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
        done < $LOG_FILE
    fi 

    config_pc
}

config_pc() 
{
    if (whiptail --title "Additional settings" \
    --yes-button "Yes" --no-button "No" --yesno \
    "Do you want to configure computer options?\n \
    You can set here things depending on your computer \
    and personal preferences." 20 70) then

    (whiptail --title "Additional settings" --checklist --separate-output \
    "Choose your desired software\nSpacebar - check/uncheck \nEnter - finished:" 20 78 15 \
    "Beep" "Disable bepp sound" OFF \
    "Touchpad" "Enable touchpad" OFF \
    "PL_Font" "Set TTY font to Terminus" OFF \
    "Lid" "Don't suspend laptop when lid closed" off 2>$LOG_FILE)

    while read choice
    do
    case $choice in
        Beep)
            sudo rmmod pcspkr
            sudo sh -c "echo 'blacklist pcspkr' >> /etc/modprobe.d/blacklist"
        ;;
        Touchpad)
            sudo pacman -S xf86-input-synaptics $FLAGS_PACMAN
            sudo mkdir -p /etc/X11/xorg.conf.d
            sudo cp $CONF/other/50-synaptics.conf /etc/X11/xorg.conf.d/50-synaptics.conf
        ;;
        Microphone)
            sudo cp $CONF/other/alsa-base.conf /etc/modprobe.d/alsa-base.conf
        ;;
        PL_Font)
            sudo pacman -S terminus-font $FLAGS_PACMAN
            sudo cp $CONF/other/vconsole.conf /etc/vconsole.conf
            sudo cp $CONF/other/locale.gen /etc/locale.gen
            sudo locale-gen
            sudo export LANG=pl_PL.UTF-8
            sudo cp $CONF/other/locale.conf /etc/locale.conf
            setfont /usr/share/kbd/consolefonts/Lat2-Terminus16.psfu.gz
        ;;
        Lid)
            sudo cp $CONF/other/logind.conf /etc/systemd/logind.conf
        ;;

    esac

    done < $LOG_FILE

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

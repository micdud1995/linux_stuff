#!/usr/bin/env bash

#==============================================================================
# Title             gentoo-configurator.sh
# Description       This script will config installed Gentoo  GNU/Linux system 
# Notes             Run with sudo only
#                   Program can change some file permissions (exiting function)
# License           GNU General Public License v3.0
#==============================================================================

#==============================================================================
# Global variables
ROOT_UID=0   # Root ID
LOG_FILE=""  # File main logs
LOG_FILE2="" # File with dictd logs
LOG_FILE3="" # File with libreoffice logs
LOG_FILE4="" # File with scripts logs
LOG_FILE5="" # File with additional settings logs
HOME=""      # Path to home directory
REPO=""      # Path to repository
CONF=""      # Path to config files
USER=""      # User name
#==============================================================================

info()
{
    if [[ "$UID" != "$ROOT_UID"  ]]; then
        whiptail --title "Gentoo config" --msgbox \
        "Please run this script with sudo only" 20 70
        exit 126
    else
        HOME=$(whiptail --nocancel --inputbox "Type your home folder: " 20 70 \
        "/home/qeni" 3>&1 1>&2 2>&3)

        mkdir -p $HOME/repo
        mkdir -p $HOME/tmp
        mkdir -p $HOME/src
        mkdir -p $HOME/music
        mkdir -p $HOME/movies
        mkdir -p /var/log/gentoo-configurator

        REPO="$HOME/repo/linux_stuff"   # Path to repository
        CONF="$REPO/config-files"       # Path to config files
        LOG_FILE="/var/log/gentoo-configurator/gentoo-configurator.log"
        LOG_FILE2="/var/log/gentoo-configurator/dictd.log"
        LOG_FILE4="/var/log/gentoo-configurator/scripts.log"
        LOG_FILE5="/var/log/gentoo-configurator/additional.log"
        USER="${HOME///\home\/}"
        main_menu
    fi
}

repo_dirs() 
{
    if [[ ! -d $REPO ]]; then
        if (whiptail --title "Cloning repository" --yes-button \
        "Yes" --no-button "No" --yesno \
        "Do you want to clone repo?\nThere are important files for this program\n\n \
        Repository: \ngithub.com/qeni/linux_stuff.git" 20 70) then


        # Creating repo dir and cloning repository
        if [[ ! -d $REPO ]]; then
            cd $HOME/repo
            emerge dev-vcs/git
            git clone https://github.com/qeni/linux_stuff.git
        fi
        fi
    else
        whiptail --title "Gentoo config" --msgbox "OK, $REPO exists already" 20 70
    fi

    config_gui
}

config_gui() 
{
    if (whiptail --title "Gentoo config" --yes-button "Yes" --no-button "No" --yesno \
    "Do you want to install a DE or WM?" 20 70) then

    DE=$(whiptail --title  "Gentoo config" --menu "Select environment:" 20 70 10 \
    "i3"    "tiling WM" 3>&1 1>&2 2>&3)

    case "$DE" in
    "i3")
        emerge xorg-x11 i3 dmenu feh xterm
        mkdir -p $HOME/.i3
        cp $CONF/i3/hide.i3status.conf $HOME/.i3status.conf
        cp $CONF/i3/gentoo-config $HOME/.i3/config
        cp $CONF/xinit/hide.xinitrc $HOME/.xinitrc
    esac
    fi

    config_packages
}

config_packages() 
{
    if (whiptail --title "Gentoo config" --yes-button "Yes" --no-button "No" --yesno \
    "Do you want to install some common software?" 20 70) then

    (whiptail --title "Additional software" --separate-output --checklist "" 20 70 14 \
    "alpine"            "Mail client" OFF \
    "alsa-utils"        "Sound" OFF \
    "feh"               "Image Viewer" OFF \
    "firefox"           "Web Browser" OFF \
    "git"               "Content tracker" OFF \
    "htop"              "Process Info" OFF \
    "irssi"             "IRC Client" OFF \
    "jumanji"           "Web Browser" OFF \
    "libreoffice"       "Libre Office" OFF \
    "links"             "Web Browser" OFF \
    "lxrandr"           "Output manager" OFF \
    "mc"                "Midnight Commander" OFF \
    "moc"               "Music Player" OFF \
    "mplayer"           "Video Player" OFF \
    "nethack"           "Roguelike game" OFF \
    "networkmanager"   "Network Manager" OFF \
    "newsbeuter"        "RSS feed reader" OFF \
    "pinta"             "Image Editor" OFF \
    "rtorrent"          "Torrent Client" OFF \
    "scrot"             "Screenshots" OFF \
    "texmaker"          "LaTeX Editor" OFF \
    "thunderbird"       "Mail Client" OFF \
    "unpacking"         "Archive tools" OFF \
    "vim-core"          "Text Editor" OFF \
    "vim"               "Vim with scripts support" OFF \
    "weechat"           "IRC Client" OFF \
    "wifite"            "Wireless attack tool" OFF \
    "xterm"             "Terminal Emulator" OFF \
    "youtube-dl"        "YT Downloader" OFF \
    "zathura"           "PDF Viewer" OFF \
    "zsh"               "Z-shell" OFF 2>$LOG_FILE)

    while read choice
    do
    case $choice in
    alpine)
        emerge alpine
        cp $CONF/alpine/hide.pinerc $HOME/.pinerc
    ;;
    alsa-utils)
        emerge alsa-utils
    ;;
    feh)
        emerge feh
    ;;
    firefox)
        emerge firefox
    ;;
    git)
        emerge git
        name=$(whiptail --nocancel --inputbox "Set git username:" 20 70 "<name>" 3>&1 1>&2 2>&3)
        git config --global user.name "$name"
        mail=$(whiptail --nocancel --inputbox "Set git usermail:" 20 70 "<mail>" 3>&1 1>&2 2>&3)
        git config --global user.email $mail
        edit=$(whiptail --nocancel --inputbox "Set git text editor:" 20 70 "vim" 3>&1 1>&2 2>&3)
        git config --global core.editor $edit
    ;;
    htop)
        emerge htop
    ;;
    irssi)
        emerge irssi
        mkdir $HOME/.irssi
        cp -R $CONF/irssi/* $HOME/.irssi/
    ;;
    jumanji)
        emerge jumanji
    ;;
    libreoffice)
        emerge libreoffice
    ;;
    links)
        emerge links
        mkdir -p $HOME/.links2
        cp $CONF/links/links.cfg $HOME/.links2/
    ;;
    lxrandr)
        emerge lxrandr
    ;;
    mplayer)
        emerge mplayer
    ;;
    nethack)
        emerge nethack
        cp $CONF/nethack/hide.nethackrc $HOME/.nethackrc
        cp $CONF/nethack/record /var/games/nethack/record
    ;;
    network-manager)
        emerge networkmanager
    ;;
    unpacking)
        emerge p7zip unzip zip
    ;;
    pinta)
        emerge pinta
    ;;
    scrot)
        emerge scrot
    ;;
    thunderbird)
        emerge thunderbird
    ;;
    texmaker)
        emerge texmaker texlive
    ;;
    newsbeuter)
        emerge newsbeuter
        mkdir -p $HOME/.config/newsbeuter
        cp $CONF/newsbeuter/gentoo-urls $HOME/.config/newsbeuter/urls
        cp $CONF/newsbeuter/gentoo-config $HOME/.config/newsbeuter/config
    ;;
    mc)
        emerge app-misc/mc
        mkdir -p $HOME/.config/mc
        mkdir -p $HOME/.local/share/mc/skins
        cp $CONF/midnight-commander/mc.ext $HOME/.config/mc/mc.ext
        cp $CONF/midnight-commander/purple.ini $HOME/.local/share/mc/skins/
    ;;
    moc)
        emerge media-sound/moc
        mkdir -p $HOME/.moc/themes
        cp $CONF/moc/gentoo-config $HOME/.moc/config
        cp $CONF/moc/purple_theme $HOME/.moc/themes/
    ;;
    rtorrent)
        emerge rtorrent
        mkdir -p $HOME/.rtorrent
        cp $CONF/rtorrent/hide.rtorrent.rc $HOME/.rtorrent.rc
    ;;
    youtube-dl)
        emerge youtube-dl
    ;;
    wifite)
        emerge aircrack-ng
        cd $HOME/src
        wget https://raw.github.com/derv82/wifite/master/wifite.py
        chmod +x wifite.py
    ;;
    xterm)
        emerge xterm
        cp $CONF/xterm/hide.Xresources $HOME/.Xresources
        xrdb -merge $HOME/.Xresources 
    ;;
    zathura)
        emerge zathura
        mkdir -p $HOME/.config/zathura
        cp $CONF/zathura/zathurarc $HOME/.config/zathura/ 
    ;;
    zsh)
        emerge zsh
        mkdir -p $HOME/.config/zsh
        cp $CONF/zsh/aliases $HOME/.config/zsh/
        cp $CONF/zsh/functions $HOME/.config/zsh/
        cp $CONF/scripts/welcomer /usr/local/bin/
        cp $CONF/zsh/gentoo-zshrc $HOME/.zshrc
        chsh -s /bin/zsh ${HOME///\home\/}
    ;;
    vim-core)
        #==============================================================
        # Plugin list:
        #   Pathogen
        #   Nerdtree
        #   Syntastic
        #   Tagbar
        #   Auto-pairs
        #   Supertab
        #   Neosnippet
        #   Vim-commentary
        #   undotree 
        #==============================================================

        emerge vim-core net-misc/curl dev-util/ctags

        # Making dirs
        mkdir -p $HOME/.vim/autoload $HOME/.vim/bundle $HOME/.vim/colors

        # Pathogen
        curl -LSso $HOME/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

        # Nerdtree
        cd $HOME/.vim/bundle && \
        git clone https://github.com/scrooloose/nerdtree.git

        # Syntastic
        cd $HOME/.vim/bundle && \
        git clone https://github.com/scrooloose/syntastic.git

        # Tagbar
        cd $HOME/.vim/bundle && \
        git clone https://github.com/majutsushi/tagbar

        # Auto-pairs
        cd $HOME/.vim/bundle && \
        git clone git://github.com/jiangmiao/auto-pairs.git

        # Supertab
        git clone git://github.com/ervandew/supertab.git

        # Neosnippet
        cd $HOME/.vim/bundle
        git clone https://github.com/Shougo/neosnippet.vim
        git clone https://github.com/Shougo/neosnippet-snippets

        # Vim-commentary
        cd $HOME/.vim/bundle
        git clone https://github.com/tpope/vim-commentary.git

        # Themes
        cp $CONF/vim/colors/*.vim $HOME/.vim/colors/

        # undotree
        cd $HOME/.vim/bundle && \
        git clone https://github.com/mbbill/undotree

        # Copying .vimrc
        cp $CONF/vim/hide.vimrc $HOME/.vimrc
        cp $CONF/vim/hide.vimrc-minimal $HOME/.vimrc-minimal

        # Copying NERDTree bookmarks
        if [[ "$USER" == "michal"  ]]; then
            cp $CONF/vim/hide.NERDTreeBookmarks $HOME/.NERDTreeBookmarks
        fi
    ;;
    vim)
        #==============================================================
        # Plugin list:
        #   Pathogen
        #   Nerdtree
        #   Syntastic
        #   Tagbar
        #   Auto-pairs
        #   Supertab
        #   Neosnippet
        #   Vim-commentary
        #   neocomplete
        #   undotree 
        #==============================================================

        emerge vim dev-util/cmake net-misc/curl dev-util/ctags

        # Making dirs
        mkdir -p $HOME/.vim/autoload $HOME/.vim/bundle $HOME/.vim/colors

        # Pathogen
        curl -LSso $HOME/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

        # Nerdtree
        cd $HOME/.vim/bundle && \
        git clone https://github.com/scrooloose/nerdtree.git

        # Syntastic
        cd $HOME/.vim/bundle && \
        git clone https://github.com/scrooloose/syntastic.git

        # Tagbar
        cd $HOME/.vim/bundle && \
        git clone https://github.com/majutsushi/tagbar

        # Auto-pairs
        cd $HOME/.vim/bundle && \
        git clone git://github.com/jiangmiao/auto-pairs.git

        # Neosnippet
        # cd $HOME/.vim/bundle
        # git clone https://github.com/Shougo/neosnippet.vim
        # git clone https://github.com/Shougo/neosnippet-snippets
        # cp $CONF/vim/python.snip $HOME/.vim/bundle/neosnippet-snippets/neosnippets/python.snip

        # Vim-commentary
        cd $HOME/.vim/bundle
        git clone https://github.com/tpope/vim-commentary.git

        # Themes
        cp $CONF/vim/colors/*.vim $HOME/.vim/colors/

        # undotree
        cd $HOME/.vim/bundle && \
        git clone https://github.com/mbbill/undotree

        # neocomplete
        cd $HOME/.vim/bundle/
        git clone https://github.com/Shougo/neocomplete.vim

        # Copying .vimrc
        cp $CONF/vim/hide.vimrc $HOME/.vimrc
        cp $CONF/vim/hide.vimrc-minimal $HOME/.vimrc-minimal

        # Copying NERDTree bookmarks
        if [[ "$USER" == "michal"  ]]; then
            cp $CONF/vim/hide.NERDTreeBookmarks $HOME/.NERDTreeBookmarks
        fi
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
        "take-screenshot" 	"Easier screenshots" OFF \
        "mountpoint" 	    "Create mountpoint" OFF \
        "yt" 	            "Download YT playlist" OFF \
        "run-emacs" 		"Running Emacs" OFF 2>$LOG_FILE4)

        while read choice
        do
            case $choice in
            live-usb)
                cp $CONF/scripts/live-usb /usr/local/bin/
                chmod +x /usr/local/bin/live-usb
            ;;
            run-mc)
                cp $CONF/scripts/run-mc /usr/local/bin/
                chmod +x /usr/local/bin/run-mc
            ;;
            take-screenshot)
                cp $CONF/scripts/take-screenshot /usr/local/bin/
                cp $CONF/scripts/take-screenshot-s /usr/local/bin/
                chmod +x /usr/local/bin/take-screenshot
                chmod +x /usr/local/bin/take-screenshot-s
            ;;
            yt)
                cp $CONF/scripts/yt /usr/local/bin/
                chmod +x /usr/local/bin/yt
            ;;
            mountpoint)
                emerge ntfs-3g
                mkdir /mnt/mountpoint
                chown $USER /mnt/mountpoint
            ;;
            run-emacs)
                cp $CONF/scripts/run-emacs /usr/local/bin/
                chmod +x /usr/local/bin/run-emacs
            ;;
            esac
        done < $LOG_FILE4
    fi 

    config_pc
}

config_pc() 
{
    if (whiptail --title "Additional settings" --yes-button "Yes" --no-button \
    "No" --yesno "Do you want to configure computer options?" 20 70) then

    (whiptail --title "Additional settings" --checklist --separate-output "Choose \
    your desired software\nSpacebar - check/uncheck \nEnter - finished:" 20 78 15 \
    "Beep"      "Disable bepp sound" OFF \
    "Touchpad"  "Enable touchpad" OFF \
    "T61_wifi"  "Copy iwlwifi-4965-2.ucode" OFF \
    "Wallpaper" "Copy wallpaper to pictures" OFF 2>$LOG_FILE5)

    while read choice
    do
        case $choice in
        Beep)
            rmmod pcspkr
            sh -c "echo 'blacklist pcspkr' >> /etc/modprobe.d/blacklist"
        ;;
        Touchpad)
            mkdir -p /etc/X11/xorg.conf.d
            cp $CONF/other/50-synaptics.conf /etc/X11/xorg.conf.d/50-synaptics.conf
        ;;
        T61_wifi)
            mkdir -p /lib/firmware
            cp $CONF/other/iwlwifi-4965-2.ucode /lib/firmware/
        ;;
        # Font)
        # ;;
        Wallpaper)

            WALL=$(whiptail --title  "Gentoo config" --menu "Select wallpaper:" 20 70 10 \
            "A"     "gen_think_1280x800" 3>&1 1>&2 2>&3)

            case "$WALL" in
            "A")
                cp $CONF/wallpapers/gen_think_1280x800.png $HOME/pictures/wallpaper.png
            ;;
            esac
        ;;
        esac
    done < $LOG_FILE5

    fi 

    exiting
}

exiting()
{
    chown -R $USER $HOME
    whiptail --title "Gentoo config" --msgbox "System configured." 20 70
    exit 0
}

main_menu() 
{
    menu_item=$(whiptail --nocancel --title "Gentoo config" --menu "Menu Items:" 20 70 10 \
    "Clone repo"        "-" \
    "Config sources"    "-" \
    "Install GUI"       "-" \
    "Install packages"  "-" \
    "Copy scripts"      "-" \
    "Config PC things"  "-" \
    "Exit"              "-" 3>&1 1>&2 2>&3)

    case "$menu_item" in
    "Clone repo")
        repo_dirs
    ;;
    "Config sources")
        config_sources
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
        exiting
    ;;
    esac
}

info

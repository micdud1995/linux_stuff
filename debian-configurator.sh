#!/usr/bin/env bash

#==============================================================================
# Title             debian-configurator.sh
# Description       This script will config installed Debian GNU/Linux system 
#                   in version 8.x
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
        whiptail --title "Debian config" --msgbox \
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
        mkdir -p $HOME/pictures/scrots
        mkdir -p /var/log/debian-configurator

        REPO="$HOME/repo/linux_stuff"   # Path to repository
        CONF="$REPO/config-files"       # Path to config files
        LOG_FILE="/var/log/debian-configurator/debian-configurator.log"
        LOG_FILE2="/var/log/debian-configurator/dictd.log"
        LOG_FILE3="/var/log/debian-configurator/libreoffice.log"
        LOG_FILE4="/var/log/debian-configurator/scripts.log"
        LOG_FILE5="/var/log/debian-configurator/additional.log"
        USER="${HOME///\home\/}"
        main_menu
    fi
}

select_system() 
{
    OS=$(whiptail --nocancel --title "Select OS" --menu "Select your OS" 20 70 10 \
    "Debian"    ""  \
    "Raspbian"  ""  3>&1 1>&2 2>&3)

    case "$OS" in
        "Debian")
            repo_dirs
        ;;
        "Raspbian")
            raspbian_config
        ;;
    esac
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
            aptitude install git tree -y
            git clone https://github.com/qeni/linux_stuff.git
        fi
        fi
    else
        whiptail --title "Debian config" --msgbox "OK, $REPO exists already" 20 70
    fi

    config_sources
}

config_sources() 
{
    if (whiptail --title "Updating sources" --yes-button "Yes" --no-button "No" --yesno \
    "Do you want to update sources.list file?\n\nYou can choose between different versions of sources." 20 70) then

    VERSION=$(whiptail --nocancel --title "Edit sources.list" \
    --menu "Select version of repositories" 20 70 10 \
    "Stable"                    ""  \
    "Testing"                   ""  \
    "Sid"                       ""  \
    "Stable contrib non-free"   ""  \
    "Testing contrib non-free"  ""  \
    "Sid contrib non-free"      ""  3>&1 1>&2 2>&3)

    case "$VERSION" in
    "Stable")
        sh -c "cat $CONF/sources.list/stable.txt > /etc/apt/sources.list"
    ;;
    "Testing")
        sh -c "cat $CONF/sources.list/testing.txt > /etc/apt/sources.list"
    ;;
    "Sid")
        sh -c "cat $CONF/sources.list/unstable.txt > /etc/apt/sources.list"
    ;;
    "Stable contrib non-free")
        sh -c "cat $CONF/sources.list/stable-nonfree.txt > /etc/apt/sources.list"
    ;;
    "Testing contrib non-free")
        sh -c "cat $CONF/sources.list/testing-nonfree.txt > /etc/apt/sources.list"
    ;;
    "Sid contrib non-free")
        sh -c "cat $CONF/sources.list/unstable-nonfree.txt > /etc/apt/sources.list"
    ;;
    esac

    aptitude update 
    aptitude dist-upgrade -y
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
        aptitude install dkms build-essential linux-headers-amd64 virtualbox-guest-x11 \
        virtualbox-dkms virtualbox-guest-utils -y
    ;;
    esac
    fi

    if (whiptail --title "Debian config" --yes-button "Yes" --no-button "No" --yesno \
    "Do you want to install a DE or WM?" 20 70) then

    DE=$(whiptail --title  "Debian config" --menu "Select environment:" 20 70 10 \
    "i3"                "tiling WM" \
    "openbox"           "WM" \
    "xfce"              "DE" \
    "gnome"             "DE" \
    "kde"               "DE" \
    "lxde-core"         "DE"   3>&1 1>&2 2>&3)

    case "$DE" in
    "i3")
        aptitude install xorg xinit i3 dmenu fonts-inconsolata \
        fonts-font-awesome feh xterm -y
        mkdir -p $HOME/.i3
        mkdir -p $HOME/Pictures
        cp $CONF/i3/hide.i3status.conf $HOME/.i3status.conf
        cp $CONF/i3/debian-config $HOME/.i3/config

        cp $CONF/i3/i3lock-deb.png $HOME/pictures/i3lock-deb.png
        cp $CONF/xinit/hide.xinitrc $HOME/.xinitrc
    ;;
    "openbox")
        aptitude install openbox tint2 fonts-inconsolata colordiff xterm xorg \
        alsa-utils feh  xfonts-terminus xbacklight -y

        mkdir -p $HOME/.config/openbox
        mkdir -p $HOME/.config/tint2
        cp -p $CONF/openbox/{rc.xml,menu.xml,environment,autostart} $HOME/.config/openbox/
        chmod +x $HOME/.config/openbox/{autostart,environment}
        cp $CONF/tint2/tint2rc $HOME/.config/tint2/tint2rc

        cp $CONF/xinit/hide.xinitrc $HOME/.xinitrc
    ;;
    "lxde-core")
        mkdir -p $HOME/.config/lxpanel/LXDE/panels
        aptitude install xorg xinit lxde-core lxpanel lxappearance \
        lxappearance-obconf lxrandr fonts-inconsolata faenza-icon-theme -y
        cp $CONF/lxde/lxde-rc.xml $HOME/.config/openbox/
        cp $CONF/lxde/panel $HOME/.config/lxpanel/LXDE/panels/panel
        cp $CONF/xinit/hide.xinitrc $HOME/.xinitrc
    ;;
    "xfce")
        aptitude install xorg xinit xfce4 -y
    ;;
    "gnome")
        aptitude install xorg xinit gnome -y
    ;;
    "kde")
        aptitude install xorg xinit kde-standard -y
    ;;
    esac
    fi

    config_packages
}

config_packages() 
{
    if (whiptail --title "Debian config" --yes-button "Yes" --no-button "No" --yesno \
    "Do you want to install/config some common software?" 20 70) then

    (whiptail --title "Additional software" --separate-output --checklist "" 20 70 14 \
    "alpine"            "Mail client" OFF \
    "alsa-utils"        "Sound" OFF \
    "bash"              "Shell" OFF \
    "calcurse"          "Text-based organizer" OFF \
    "conky"             "System Info" OFF \
    "dictd"             "Offline dictionary" OFF \
    "emacs-nox"         "GNU Editor" OFF \
    "feh"               "Image Viewer" OFF \
    "git"               "Content tracker" OFF \
    "htop"              "Process Info" OFF \
    "icedove"           "Mail Client" OFF \
    "iceweasel"         "Web Browser" OFF \
    "irssi"             "IRC Client" OFF \
    "jumanji"           "Web Browser" OFF \
    "libreoffice"       "Libre Office" OFF \
    "links"             "Web Browser" OFF \
    "livestreamer"      "Stream Tool" OFF \
    "lxrandr"           "Output manager" OFF \
    "mc"                "Midnight Commander" OFF \
    "moc"               "Music Player" OFF \
    "mps-youtube"       "Youtube Player" OFF \
    "mplayer"           "Video Player" OFF \
    "mutt"              "Mail Client" OFF \
    "nethack"           "Roguelike game" OFF \
    "network-manager"   "Network Manager" OFF \
    "newsbeuter"        "RSS feed reader" OFF \
    "pinta"             "Image Editor" OFF \
    "ranger"            "File manager" OFF \
    "rtorrent"          "Torrent Client" OFF \
    "scrot"             "Screenshots" OFF \
    "texmaker"          "LaTeX Editor" OFF \
    "tor"               "Communication System" OFF \
    "unpacking"         "Archive tools" OFF \
    "uzbl"              "Web Browser" OFF \
    "vifm"              "File Manager" OFF \
    "vim-clear"         "Text Editor" OFF \
    "vim-nox"           "Vim with scripts support" OFF \
    "vrms"              "Virtual RMS" OFF \
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
        aptitude install alpine -y
        cp $CONF/alpine/hide.pinerc $HOME/.pinerc
    ;;
    alsa-utils)
        aptitude install alsa-utils -y
    ;;
    bash)
        aptitude install colordiff bash -y
        cp $CONF/bash/debian-bashrc $HOME/.bashrc
        chsh -s /bin/bash ${HOME///\home\/}
    ;;
    calcurse)
        aptitude install calcurse -y
    ;;
    conky)
        aptitude install conky alsa-utils xfonts-terminus -y

        CONKY=$(whiptail --title  "Debian config" --menu "Select conky file:" 20 70 10 \
        "top"               "vertical red bar" \
        "red"               "all informations" \
        "binary"            "binary clock" \
        "indicator"         "desktop indicator" 3>&1 1>&2 2>&3)

        case "$CONKY" in
        "top")
            cp $CONF/conky/red-top $HOME/.conkyrc
        ;;
        "red")
            cp $CONF/conky/hide.conkyrc $HOME/.conkyrc
            cp $CONF/conky/hoog0555_cyr2.ttf /usr/share/fonts/truetype/ 
        ;;
        "binary")
            cp $CONF/conky/binary-clock $HOME/.conkyrc
        ;;
        "indicator")
            cp $CONF/conky/workspace-indicator $HOME/.conkyrc
        ;;
        esac
    ;;
    dictd)
        aptitude install dictd -y
        whiptail --title "Test" --checklist --separate-output "Choose:" 20 78 15 \
        "eng-pol" "" OFF \
        "eng-deu" "" OFF \
        "eng-fra" "" OFF \
        "eng-rus" "" OFF \
        "eng-spa" "" off 2>$LOG_FILE2

        while read choice
        do
        case $choice in
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
        done < $LOG_FILE2
    ;;
    emacs-nox)
        aptitude install emacs-nox -y
        mkdir -p $HOME/.emacs.d/
        cp -R $CONF/emacs/* $HOME/.emacs.d/
    ;;
    feh)
        aptitude install feh -y
    ;;
    git)
        aptitude install git -y
        name=$(whiptail --nocancel --inputbox "Set git username:" 20 70 "<name>" 3>&1 1>&2 2>&3)
        git config --global user.name "$name"
        mail=$(whiptail --nocancel --inputbox "Set git usermail:" 20 70 "<mail>" 3>&1 1>&2 2>&3)
        git config --global user.email $mail
        edit=$(whiptail --nocancel --inputbox "Set git text editor:" 20 70 "vim" 3>&1 1>&2 2>&3)
        git config --global core.editor $edit
    ;;
    htop)
        aptitude install htop -y
    ;;
    icedove)
        aptitude install icedove -y
    ;;
    iceweasel)
        aptitude install iceweasel -y
    ;;
    irssi)
        aptitude install irssi -y
        mkdir $HOME/.irssi
        cp -R $CONF/irssi/* $HOME/.irssi/
    ;;
    jumanji)
        aptitude install cmake pkg-config libgtk-3-0 libgirara-dev \
        libwebkitgtk-3.0-dev libsoup2.4-1 libsoup2.4-dev -y
        cd $HOME/src
        git clone https://git.pwmt.org/pwmt/jumanji.git
        cd jumanji
        make
        make install
        cd ..
        rm -rf jumanji
        mkdir -p $HOME/.config/jumanji
        cp $CONF/jumanji/jumanjirc $HOME/.config/jumanji/
    ;;
    libreoffice)
        aptitude install libreoffice -y
        (whiptail --title "Libre office language" --menu "Choose your language" 20 70 11 \
        "Polski"        "Polish" \
        "Deutsch"       "German" \
        "British"       "English_british" \
        "American"      "English_american" \
        "Espanol"       "Spanish" 2>$LOG_FILE3)

        while read choice
        do
        case $choice in
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
        done < $LOG_FILE3
    ;;
    links)
        aptitude install links -y
        mkdir -p $HOME/.links2
        cp $CONF/links/links.cfg $HOME/.links2/
    ;;
    livestreamer)
        aptitude install python python-requests python-setuptools python-singledispatch -y
        cd $HOME/src
        git clone https://github.com/chrippa/livestreamer.git
        cd $HOME/src/livestreamer
        python setup.py install
        rm -rf $HOME/src/livestreamer
    ;;
    lxrandr)
        aptitude install lxrandr -y
    ;;
    mps-youtube)
        aptitude install mplayer python3-pip -y
        pip3 install mps-youtube
    ;;
    mplayer)
        aptitude install mplayer -y
    ;;
    nethack)
        aptitude install nethack-console -y
        cp $CONF/nethack/hide.nethackrc $HOME/.nethackrc
        cp $CONF/nethack/record /var/games/nethack/record
    ;;
    network-manager)
        aptitude install network-manager -y
        systemctl disable NetworkManager.service
        systemctl stop NetworkManager.service
    ;;
    unpacking)
        aptitude install p7zip unzip zip unrar-free -y
    ;;
    pinta)
        aptitude install pinta -y
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
        cp $CONF/ranger/red.py $HOME/.config/ranger/colorschemes/
        cp $CONF/ranger/debian-rc.conf $HOME/.config/ranger/rc.conf
    ;;
    texmaker)
        aptitude install texmaker texlive-full texlive-lang-polish texlive-doc-pl texlive-math-extra texlive-latex-extra-doc -y
    ;;
    vrms)
        aptitude install vrms -y
    ;;
    weechat)
        aptitude install weechat -y
        mkdir -p $HOME/.weechat
        cp $CONF/weechat/* $HOME/.weechat/
        rm -f $HOME/.weechat/weechat.log
    ;;
    newsbeuter)
        aptitude install newsbeuter -y
        mkdir -p $HOME/.config/newsbeuter
        cp $CONF/newsbeuter/debian-urls $HOME/.config/newsbeuter/urls
        cp $CONF/newsbeuter/debian-config $HOME/.config/newsbeuter/config
    ;;
    mc)
        aptitude install mc -y
        mkdir -p $HOME/.config/mc
        mkdir -p $HOME/.local/share/mc/skins
        cp $CONF/midnight-commander/mc.ext $HOME/.config/mc/mc.ext
        cp $CONF/midnight-commander/ini $HOME/.config/mc/ini
        cp $CONF/midnight-commander/darkcourses_green.ini $HOME/.local/share/mc/skins/
        cp $CONF/midnight-commander/red.ini $HOME/.local/share/mc/skins/
    ;;
    moc)
        aptitude install moc -y
        mkdir -p $HOME/.moc/themes
        cp $CONF/moc/debian-config $HOME/.moc/config
        cp $CONF/moc/red_theme $HOME/.moc/themes/
        cp $CONF/moc/green_theme $HOME/.moc/themes/
    ;;
    mutt)
        aptitude install mutt -y
        cp $CONF/mutt/hide.muttrc $HOME/.muttrc
    ;;
    rtorrent)
        aptitude install rtorrent -y
        mkdir -p $HOME/.rtorrent
        cp $CONF/rtorrent/hide.rtorrent.rc $HOME/.rtorrent.rc
    ;;
    uzbl)
        aptitude install uzbl -y
        mkdir -p $HOME/.config/uzbl
        mkdir -p $HOME/.local/share/uzbl/
        cp $CONF/uzbl/config $HOME/.config/uzbl/config
        cp $CONF/uzbl/bookmarks $HOME/.local/share/uzbl/bookmarks
    ;;
    vifm)
        aptitude install vifm -y
        mkdir -p $HOME/.vifm/colors
        cp $CONF/vifm/vifmrc $HOME/.vifm/
        cp $CONF/vifm/solarized.vifm $HOME/.vifm/colors/
    ;;
    youtube-dl)
        wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
        chmod a+rx /usr/local/bin/youtube-dl
    ;;
    wifite)
        aptitude install aircrack-ng -y
        cd $HOME/src
        wget https://raw.github.com/derv82/wifite/master/wifite.py
        chmod +x wifite.py
    ;;
    xterm)
        aptitude install xterm -y
        cp $CONF/xterm/hide.Xresources $HOME/.Xresources
        xrdb -merge $HOME/.Xresources 
    ;;
    zathura)
        aptitude install zathura -y
        mkdir -p $HOME/.config/zathura
        cp $CONF/zathura/zathurarc $HOME/.config/zathura/ 
    ;;
    zsh)
        aptitude install zsh -y
        mkdir -p $HOME/.config/zsh
        cp $CONF/zsh/aliases $HOME/.config/zsh/
        cp $CONF/zsh/functions $HOME/.config/zsh/
        cp $CONF/scripts/welcomer /usr/local/bin/
        chmod +x /usr/local/bin/welcomer
        cp $CONF/zsh/debian-zshrc $HOME/.zshrc
        chsh -s /bin/zsh ${HOME///\home\/}
    ;;
    vim-clear)
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

        aptitude install vim curl exuberant-ctags fonts-inconsolata -y

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
    vim-nox)
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

        aptitude install vim-nox build-essential cmake python-dev curl exuberant-ctags fonts-inconsolata -y

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
        "mountpoint" 	            "Create mountpoint" OFF \
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
            m)
                aptitude install ntfs-3g -y
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
    "Caps"      "Making Esc from Caps Lock key" OFF \
    "Touchpad"  "Enable touchpad" OFF \
    "T61_wifi"  "Copy iwlwifi-4965-2.ucode" OFF \
    "Font"      "Set console font" OFF \
    "Wallpaper" "Copy wallpaper to pictures" OFF \
    "Grub"      "Boot loader configuration" OFF \
    "Lid"       "Don't suspend laptop when lid closed" off 2>$LOG_FILE5)

    while read choice
    do
        case $choice in
        Beep)
            rmmod pcspkr
            sh -c "echo 'blacklist pcspkr' >> /etc/modprobe.d/blacklist"
        ;;
        Caps)
            setxkbmap -option caps:escape &
        ;;
        Touchpad)
            mkdir -p /etc/X11/xorg.conf.d
            cp $CONF/other/50-synaptics.conf /etc/X11/xorg.conf.d/50-synaptics.conf
        ;;
        T61_wifi)
            mkdir -p /lib/firmware
            cp $CONF/other/iwlwifi-4965-2.ucode
        ;;
        Font)
            aptitude install xfonts-terminus console-terminus -y
            sudo dpkg-reconfigure console-setup
        ;;
        Wallpaper)

            WALL=$(whiptail --title  "Debian config" --menu "Select wallpaper:" 20 70 10 \
            "A"     "deb_think_1280x800" \
            "B"     "deb_white_1366x768" 3>&1 1>&2 2>&3)

            case "$WALL" in
            "A")
                cp $CONF/wallpapers/deb_think_1280x800.png $HOME/pictures/wallpaper.png
            ;;
            "B")
                cp $CONF/wallpapers/deb_white_1366x768.png $HOME/pictures/wallpaper.png
            esac
        ;;
        Grub)
            nano /etc/default/grub
            update-grub
        ;;
        Lid)
            cp $CONF/other/logind.conf /etc/systemd/logind.conf
        ;;
        esac
    done < $LOG_FILE5

    fi 

    exiting
}

exiting()
{
    chown -R $USER $HOME
    whiptail --title "Debian config" --msgbox "System configured." 20 70
    exit 0
}

main_menu() 
{
    menu_item=$(whiptail --nocancel --title "Debian config" --menu "Menu Items:" 20 70 10 \
    "Clone repo"        "-" \
    "Config sources"    "-" \
    "Config shell"      "-" \
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

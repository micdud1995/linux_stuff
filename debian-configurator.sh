#!/usr/bin/env bash

#==============================================================================
# Title             debian-configurator.sh
# Description       This script will config installed Debian GNU/Linux system 
#                   in version 8.x
# Author            Michal Dudek 
# Notes             Run with sudo only
# License           GNU General Public License v3.0
#==============================================================================

#==============================================================================
# Global variables
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
    if [[ "$UID" != "$ROOT_UID"  ]]; then
        whiptail --title "Debian config" --msgbox \
        "Please run this script with sudo only" 20 70
        exit 126
    else
        HOME=$(whiptail --nocancel --inputbox "Type your home folder: " 20 70 "/home/michal" 3>&1 1>&2 2>&3)
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
    if [[ ! -d $HOME/repo/linux_stuff ]]; then
        if (whiptail --title "Cloning repository" --yes-button "Yes" --no-button "No" --yesno \
            "Do you want to clone repo?\nThere are important files for this program\n\n \
            Repository: \ngithub.com/micdud1995/linux_stuff.git" 20 70) then

            mkdir -p $HOME/repo
            mkdir -p $HOME/tmp

            # Creating repo dir and cloning repository
            if [[ ! -d $HOME/repo/linux_stuff ]]; then
                cd $HOME/repo
                aptitude install git tree -y
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
        "Do you want to update sources.list file?\n\nYou can choose between different versions of sources.\n\n
        \n\nContrib software requires non-free depedencies.\nNon-free section contains non-free software." 20 70) then

        VERSION=$(whiptail --nocancel --title "Edit sources.list" --menu "Select version of repositories" 20 70 10 \
        "Stable"                    ""  \
        "Testing"                   ""  \
        "Sid"                       ""  \
        "Stable contrib non-free"   ""  \
        "Testing contrib non-free"  ""  \
        "Sid contrib non-free"      ""  3>&1 1>&2 2>&3)

        case "$VERSION" in
            "Stable")
                sh -c "cat $HOME/repo/linux_stuff/config-files/sources.list/stable.txt > /etc/apt/sources.list"
            ;;
            "Testing")
                sh -c "cat $HOME/repo/linux_stuff/config-files/sources.list/testing.txt > /etc/apt/sources.list"
            ;;
            "Sid")
                sh -c "cat $HOME/repo/linux_stuff/config-files/sources.list/unstable.txt > /etc/apt/sources.list"
            ;;
            "Stable contrib non-free")
                sh -c "cat $HOME/repo/linux_stuff/config-files/sources.list/stable-nonfree.txt > /etc/apt/sources.list"
            ;;
            "Testing contrib non-free")
                sh -c "cat $HOME/repo/linux_stuff/config-files/sources.list/testing-nonfree.txt > /etc/apt/sources.list"
            ;;
            "Sid contrib non-free")
                sh -c "cat $HOME/repo/linux_stuff/config-files/sources.list/unstable-nonfree.txt > /etc/apt/sources.list"
            ;;
            "*")
                whiptail --title "Debian config" --msgbox "Wrong version" 20 70
                main_menu
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
                aptitude install dkms build-essential linux-headers-amd64 virtualbox-guest-x11 virtualbox-dkms virtualbox-guest-utils -y
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
                aptitude install xorg xinit i3 dmenu fonts-inconsolata fonts-font-awesome feh weechat xterm ranger moc -y
                mkdir -p $HOME/.i3
                mkdir -p $HOME/Pictures
                cp $HOME/repo/linux_stuff/config-files/i3/hide.i3status.conf $HOME/.i3status.conf
                cp $HOME/repo/linux_stuff/config-files/i3/debian-config $HOME/.i3/config
                # cp $HOME/repo/linux_stuff/config-files/i3/workspace* ~/.i3/
                # cp $HOME/repo/linux_stuff/config-files/i3/load_workspaces.sh ~/.i3/
                # chmod +x $HOME/.i3/load_workspaces.sh

                cp -R $HOME/repo/linux_stuff/config-files/fonts/tamsyn-font-1.11/ /usr/share/fonts/truetype/
                cp $HOME/repo/linux_stuff/config-files/i3/i3lock-deb.png $HOME/Pictures/i3lock-deb.png
                cp $HOME/repo/linux_stuff/config-files/xinit/hide.xinitrc $HOME/.xinitrc

                WALLPAPER=$(whiptail --title "Debian config" --menu "Select your wallpaper" 20 70 10 \
                    "Black Debian"  "" \
                    "Grey Space"    "" 3>&1 1>&2 2>&3)

                case "$WALLPAPER" in
                    "Black Debian")
                        cp $HOME/repo/linux_stuff/config-files/wallpapers/debian-wallpaper.jpg $HOME/Pictures/wallpaper.jpg
                    ;;
                    "Debian Ascii")
                        cp $HOME/repo/linux_stuff/config-files/wallpapers/debian-ascii.jpg $HOME/Pictures/wallpaper.jpg
                    ;;
                    "Grey Space")
                        cp $HOME/repo/linux_stuff/config-files/wallpapers/space.jpg $HOME/Pictures/wallpaper.jpg
                    ;;
                esac
            ;;
            "openbox")
                aptitude install openbox tint2 fonts-inconsolata colordiff bash xterm xorg mc conky alsa-utils faenza-icon-theme feh htop lxrandr p7zip unrar unzip zip scrot newsbeuter uzbl git weechat xfonts-terminus moc xbacklight -y

                mkdir -p $HOME/.weechat
                mkdir -p $HOME/.local/share/uzbl
                cp $HOME/repo/linux_stuff/config-files/weechat/* $HOME/.weechat/
                rm -f $HOME/.weechat/weechat.log

                name=$(whiptail --nocancel --inputbox "Set git username:" 20 70 "<name>" 3>&1 1>&2 2>&3)
                git config --global user.name "$name"
                mail=$(whiptail --nocancel --inputbox "Set git usermail:" 20 70 "<mail>" 3>&1 1>&2 2>&3)
                git config --global user.email $mail
                edit=$(whiptail --nocancel --inputbox "Set git text editor:" 20 70 "vim" 3>&1 1>&2 2>&3)
                git config --global core.editor $edit

                cp -R $HOME/repo/linux_stuff/config-files/fonts/tamsyn-font-1.11/ /usr/share/fonts/truetype/

                cp $HOME/repo/linux_stuff/config-files/uzbl/config $HOME/.config/uzbl/config
                cp $HOME/repo/linux_stuff/config-files/uzbl/bookmarks $HOME/.local/share/uzbl/bookmarks

                mkdir -p $HOME/.config/newsbeuter
                cp $HOME/repo/linux_stuff/config-files/newsbeuter/debian-urls $HOME/.config/newsbeuter/urls
                cp $HOME/repo/linux_stuff/config-files/newsbeuter/debian-config $HOME/.config/newsbeuter/config

                cp $HOME/repo/linux_stuff/config-files/conky/green-top $HOME/.conkyrc
                cp $HOME/repo/linux_stuff/config-files/conky/hoog0555_cyr2.ttf /usr/share/fonts/truetype/ 

                mkdir -p $HOME/.moc/themes
                cp $HOME/repo/linux_stuff/config-files/moc/debian-config $HOME/.moc/config
                cp $HOME/repo/linux_stuff/config-files/moc/green_theme $HOME/.moc/themes/

                mkdir -p $HOME/.config/mc
                mkdir -p $HOME/.local/share/mc/skins
                cp $HOME/repo/linux_stuff/config-files/midnight-commander/mc.ext $HOME/.config/mc/mc.ext
                cp $HOME/repo/linux_stuff/config-files/midnight-commander/darkcourses_green.ini $HOME/.local/share/mc/skins/
                cp $HOME/repo/linux_stuff/config-files/midnight-commander/red.ini $HOME/.local/share/mc/skins/

                SHELL="BASH"
                cp $HOME/repo/linux_stuff/config-files/bash/debian-bashrc $HOME/.bashrc
                chsh -s /bin/bash

                cp $HOME/repo/linux_stuff/config-files/xterm/hide.Xresources $HOME/.Xresources
                xrdb -merge $HOME/.Xresources 

                mkdir -p $HOME/.config/openbox
                mkdir -p $HOME/.config/tint2
                cp -p $HOME/repo/linux_stuff/config-files/openbox/{rc.xml,menu.xml,environment,autostart} $HOME/.config/openbox/
                chmod +x $HOME/.config/openbox/{autostart,environment}
                cp $HOME/repo/linux_stuff/config-files/tint2/tint2rc $HOME/.config/tint2/tint2rc
                cp $HOME/repo/linux_stuff/config-files/scripts/run-mc /usr/local/bin/
                cp $HOME/repo/linux_stuff/config-files/scripts/take-screenshot /usr/local/bin/
                cp $HOME/repo/linux_stuff/config-files/scripts/take-screenshot-s /usr/local/bin/
                chmod +x /usr/local/bin/run-mc
                chmod +x /usr/local/bin/take-screenshot
                chmod +x /usr/local/bin/take-screenshot-s

                cp $HOME/repo/linux_stuff/config-files/xinit/hide.xinitrc $HOME/.xinitrc
            ;;
            "lxde-core")
                mkdir -p $HOME/.config/lxpanel/LXDE/panels
                aptitude install xorg xinit lxde-core lxpanel lxappearance lxappearance-obconf lxrandr fonts-inconsolata faenza-icon-theme -y
                cp $HOME/repo/linux_stuff/config-files/lxde/lxde-rc.xml $HOME/.config/openbox/
                cp $HOME/repo/linux_stuff/config-files/lxde/panel $HOME/.config/lxpanel/LXDE/panels/panel
                cp $HOME/repo/linux_stuff/config-files/scripts/run-cmus /usr/local/bin/
                chmod +x /usr/local/bin/run-cmus
                cp $HOME/repo/linux_stuff/config-files/xinit/hide.xinitrc $HOME/.xinitrc
            ;;
            "xfce")
                aptitude install xorg xinit xfce4 -y
                cp $HOME/repo/linux_stuff/config-files/xinit/hide.xinitrc $HOME/.xinitrc
            ;;
            "gnome")
                aptitude install xorg xinit gnome -y
                cp $HOME/repo/linux_stuff/config-files/xinit/hide.xinitrc $HOME/.xinitrc
            ;;
            "kde")
                aptitude install xorg xinit kde-standard -y
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
        "bash"                          "Shell" OFF \
        "brasero"                       "Burning app" OFF \
        "calcurse"                      "Text-based organizer" OFF \
        "cmus"                          "Music player" OFF \
        "conky"                         "System Info" OFF \
        "crawl-tiles"                   "Roguelike game" OFF \
        "dictd"                         "Offline dictionary" OFF \
        "faenza-icon-theme"             "Icon Theme" OFF \
        "feh"                           "Image Viewer" OFF \
        "git"                           "Content tracker" OFF \
        "htop"                          "Process Info" OFF \
        "icedove"                       "Mail Client" OFF \
        "iceweasel"                     "Web Browser" OFF \
        "libreoffice"                   "Libre Office" OFF \
        "links"                         "Web Browser" OFF \
        "livestreamer"                  "Stream Tool" OFF \
        "lxrandr"                       "Output manager" OFF \
        "mc"                            "Midnight Commander" OFF \
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
        "scrot"                         "Screenshots" OFF \
        "texmaker"                      "LaTeX Editor" OFF \
        "tor"                           "Communication System" OFF \
        "ufw"                           "Firewall" OFF \
        "unpacking"                     "Archive tools" OFF \
        "uzbl"                          "Web Browser" OFF \
        "vifm"                          "File Manager" OFF \
        "vim-clear" 	  	            "Text Editor" OFF \
        "vim-nox" 	  	                "Vim with scripts support" OFF \
        "virtualbox"                    "Virtual Machines" OFF \
        "weechat"                       "IRC Client" OFF \
        "xboxdrv"                       "Xbox pad driver" OFF \
        "xorg" 	  	                    "X Server" OFF \
        "xterm"                         "Terminal Emulator" OFF \
        "xserver-xorg-input-synaptics"  "Touchpad" OFF \
        "youtube-dl"                    "YT Downloader" OFF \
        "zathura"                       "PDF Viewer" OFF \
        "zsh"     	                    "Z-shell" OFF 2>results)

        while read choice
        do
            case $choice in
                alsa-utils)
                    aptitude install alsa-utils -y
                ;;
                bash)
                    SHELL="BASH"

                    aptitude install colordiff bash -y
                    cp $HOME/repo/linux_stuff/config-files/bash/debian-bashrc $HOME/.bashrc
                    chsh -s /bin/bash
                ;;
                brasero)
                    aptitude install brasero -y
                ;;
                calcurse)
                    aptitude install calcurse -y
                ;;
                cmus)
                    aptitude install cmus -y
                    mkdir -p $HOME/.cmus
                    cp $HOME/repo/linux_stuff/config-files/cmus/zenburn.theme $HOME/.cmus/
                    cp $HOME/repo/linux_stuff/config-files/cmus/solarized.theme $HOME/.cmus/
                    cp $HOME/repo/linux_stuff/config-files/cmus/red.theme $HOME/.cmus/
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
                            cp $HOME/repo/linux_stuff/config-files/conky/red-top $HOME/.conkyrc
                        ;;
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
                crawl-tiles)
                    aptitude install crawl-tiles -y
                    mkdir -p $HOME/.crawl
                    cp -R $HOME/repo/linux_stuff/config-files/crawl-tiles/* $HOME/.crawl/
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
                faenza-icon-theme)
                    aptitude install faenza-icon-theme -y
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
                mpv)
                    aptitude install mpv -y
                ;;
                nethack)
                    aptitude install nethack-console -y
                    cp $HOME/repo/linux_stuff/config-files/nethack/hide.nethackrc $HOME/.nethackrc
                    cp $HOME/repo/linux_stuff/config-files/nethack/record /var/games/nethack/record
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
                texmaker)
                    aptitude install texmaker texlive-full texlive-lang-polish texlive-doc-pl texlive-math-extra texlive-latex-extra-doc -y
                ;;
                ufw)
                    aptitude install ufw -y
                    ufw enable
                ;;
                weechat)
                    aptitude install weechat -y
                    mkdir -p $HOME/.weechat
                    cp $HOME/repo/linux_stuff/config-files/weechat/* $HOME/.weechat/
                    rm -f $HOME/.weechat/weechat.log
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
                    cp $HOME/repo/linux_stuff/config-files/midnight-commander/red.ini $HOME/.local/share/mc/skins/
                ;;
                moc)
                    aptitude install moc -y
                    mkdir -p $HOME/.moc/themes
                    cp $HOME/repo/linux_stuff/config-files/moc/debian-config $HOME/.moc/config
                    cp $HOME/repo/linux_stuff/config-files/moc/red_theme $HOME/.moc/themes/
                    cp $HOME/repo/linux_stuff/config-files/moc/green_theme $HOME/.moc/themes/
                ;;
                mutt)
                    aptitude install mutt -y
                    cp $HOME/repo/linux_stuff/config-files/mutt/hide.muttrc $HOME/.muttrc
                ;;
                rtorrent)
                    aptitude install rtorrent -y
                    mkdir -p $HOME/.rtorrent
                    cp $HOME/repo/linux_stuff/config-files/rtorrent/hide.rtorrent.rc $HOME/.rtorrent.rc
                ;;
                uzbl)
                    aptitude install uzbl -y
                    cp $HOME/repo/linux_stuff/config-files/uzbl/config $HOME/.config/uzbl/config
                    cp $HOME/repo/linux_stuff/config-files/uzbl/bookmarks $HOME/.local/share/uzbl/bookmarks
                ;;
                vifm)
                    aptitude install vifm -y
                    mkdir -p $HOME/.vifm
                    mkdir -p $HOME/.vifm/colors
                    cp $HOME/repo/linux_stuff/config-files/vifm/vifmrc $HOME/.vifm/
                    cp $HOME/repo/linux_stuff/config-files/vifm/solarized.vifm $HOME/.vifm/colors/
                ;;
                virtualbox)
                    aptitude install dkms build-essential linux-headers-amd64 virtualbox-guest-x11 virtualbox-dkms virtualbox-guest-utils -y
                ;;
                youtube-dl)
                    wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
                    chmod a+rx /usr/local/bin/youtube-dl
                ;;
                xboxdrv)
                    aptitude install xboxdrv -y
                    sh -c "echo 'blacklist xpad' >> /etc/modprobe.d/blacklist"
                    rmmod xpad
                ;;
                xorg)
                    aptitude install xorg -y
                ;;
                xterm)
                    aptitude install xterm fonts-inconsolata -y
                    cp $HOME/repo/linux_stuff/config-files/xterm/hide.Xresources $HOME/.Xresources
                    xrdb -merge $HOME/.Xresources 
                ;;
                xserver-xorg-input-synaptics)
                    aptitude install xserver-xorg-input-synaptics -y
                ;;
                zathura)
                    aptitude install zathura -y
                ;;
                zsh)
                    SHELL="ZSH"

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
                    #	Tagbar
                    #	GitGutter
                    #   CtrlP
                    # 	Vim-airline
                    #	Auto-pairs
                    # 	Supertab
                    #	Neosnippet
                    #   indentLine
                    #   Vim-commentary
                    #==============================================================

                    aptitude install vim curl exuberant-ctags fonts-inconsolata -y

                    # Making dirs
                    mkdir -p $HOME/tmp $HOME/.vim/autoload $HOME/.vim/bundle $HOME/.vim/colors

                    # Pathogen
                    curl -LSso $HOME/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

                    # CtrlP
                    cd $HOME/.vim/bundle
                    git clone https://github.com/kien/ctrlp.vim.git

                    # Nerdtree
                    cd $HOME/.vim/bundle && \
                    git clone https://github.com/scrooloose/nerdtree.git

                    # Syntastic
                    cd $HOME/.vim/bundle && \
                    git clone https://github.com/scrooloose/syntastic.git

                    # Tagbar
                    cd $HOME/.vim/bundle && \
                    git clone https://github.com/majutsushi/tagbar

                    # Git-gutter
                    cd $HOME/.vim/bundle && \
                    git clone git://github.com/airblade/vim-gitgutter.git

                    # Vim-airline
                    cd $HOME/.vim/bundle && \
                    git clone https://github.com/bling/vim-airline $HOME/.vim/bundle/vim-airline

                    # Auto-pairs
                    cd $HOME/.vim/bundle && \
                    git clone git://github.com/jiangmiao/auto-pairs.git

                    # Supertab
                    git clone git://github.com/ervandew/supertab.git

                    # Neosnippet
                    cd $HOME/.vim/bundle
                    git clone https://github.com/Shougo/neosnippet.vim
                    git clone https://github.com/Shougo/neosnippet-snippets
                    cp $HOME/repo/linux_stuff/config-files/vim/python.snip $HOME/.vim/bundle/neosnippet-snippets/neosnippets/python.snip

                    # Indent-line
                    cd $HOME/.vim/bundle
                    git clone https://github.com/Yggdroot/indentLine.git

                    # Vim-commentary
                    cd $HOME/.vim/bundle
                    git clone https://github.com/tpope/vim-commentary.git

                    # Themes
                    cp $HOME/repo/linux_stuff/config-files/vim/colors/*.vim $HOME/.vim/colors/

                    # Copying .vimrc
                    cp $HOME/repo/linux_stuff/config-files/vim/hide.vimrc $HOME/.vimrc

                    # Copying NERDTree bookmarks
                    if [[ "$USER" == "michal"  ]]; then
                        cp $HOME/repo/linux_stuff/config-files/vim/hide.NERDTreeBookmarks $HOME/.NERDTreeBookmarks
                    fi
                ;;
                vim-nox)
                    #==============================================================
                    # Plugin list:
                    #	Pathogen
                    #	Nerdtree
                    #	Syntastic
                    #	Tagbar
                    #	GitGutter
                    # 	Vim-airline
                    #	Auto-pairs
                    # 	Supertab
                    #	Neosnippet
                    #   indentLine
                    #   Vim-commentary
                    #   neocomplete
                    #==============================================================

                    aptitude install vim-nox build-essential cmake python-dev curl exuberant-ctags fonts-inconsolata -y

                    # Making dirs
                    mkdir -p $HOME/tmp $HOME/.vim/autoload $HOME/.vim/bundle $HOME/.vim/colors

                    # Pathogen
                    curl -LSso $HOME/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

                    # CtrlP
                    cd $HOME/.vim/bundle
                    git clone https://github.com/kien/ctrlp.vim.git

                    # Nerdtree
                    cd $HOME/.vim/bundle && \
                    git clone https://github.com/scrooloose/nerdtree.git

                    # Syntastic
                    cd $HOME/.vim/bundle && \
                    git clone https://github.com/scrooloose/syntastic.git

                    # Tagbar
                    cd $HOME/.vim/bundle && \
                    git clone https://github.com/majutsushi/tagbar

                    # Git-gutter
                    cd $HOME/.vim/bundle && \
                    git clone git://github.com/airblade/vim-gitgutter.git

                    # Vim-airline
                    cd $HOME/.vim/bundle && \
                    git clone https://github.com/bling/vim-airline $HOME/.vim/bundle/vim-airline

                    # Auto-pairs
                    cd $HOME/.vim/bundle && \
                    git clone git://github.com/jiangmiao/auto-pairs.git

                    # Supertab
                    git clone git://github.com/ervandew/supertab.git

                    # Neosnippet
                    cd $HOME/.vim/bundle
                    git clone https://github.com/Shougo/neosnippet.vim
                    git clone https://github.com/Shougo/neosnippet-snippets
                    cp $HOME/repo/linux_stuff/config-files/vim/python.snip $HOME/.vim/bundle/neosnippet-snippets/neosnippets/python.snip

                    # Indent-line
                    cd $HOME/.vim/bundle
                    git clone https://github.com/Yggdroot/indentLine.git

                    # Vim-commentary
                    cd $HOME/.vim/bundle
                    git clone https://github.com/tpope/vim-commentary.git

                    # Themes
                    cp $HOME/repo/linux_stuff/config-files/vim/colors/*.vim $HOME/.vim/colors/

                    # neocomplete
                    cd $HOME/.vim/bundle/
                    git clone https://github.com/Shougo/neocomplete.vim

                    # Copying .vimrc
                    cp $HOME/repo/linux_stuff/config-files/vim/hide.vimrc $HOME/.vimrc

                    # Copying NERDTree bookmarks
                    if [[ "$USER" == "michal"  ]]; then
                        cp $HOME/repo/linux_stuff/config-files/vim/hide.NERDTreeBookmarks $HOME/.NERDTreeBookmarks
                    fi
                ;;
            esac
        done < results

    fi
    config_scripts
} 

config_scripts() 
{
    if (whiptail --title "Scripts" --yes-button "Yes" --no-button "No" --yesno \
        "Do you want to install automount packages?" 20 70) then

        mkdir -p /mnt/sdb1
        aptitude install fuse ntfs-3g udisks2 -y
    fi 

    config_pc
}

config_pc() 
{
    if (whiptail --title "Additional settings" --yes-button "Yes" --no-button "No" --yesno \
        "Do you want to configure computer options?\n\nYou can set here things depending on your computer and personal preferences." 20 70) then

    (whiptail --title "Additional settings" --checklist --separate-output "Choose your desired software\nSpacebar - check/uncheck \nEnter - finished:" 20 78 15 \
    "Beep" "Disable bepp sound" OFF \
    "Caps" "Making Esc from Caps Lock key" OFF \
    "Touchpad" "Enable touchpad" OFF \
    "WiFi" "Enable Lenovo G580 net. card" OFF \
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
            Caps)
                setxkbmap -option caps:escape &
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

    exiting
}

exiting()
{
    chown -R "${HOME///\home\/}" $HOME
    whiptail --title "Debian config" --msgbox "System configured." 20 70
    exit 0
}

main_menu() 
{
	menu_item=$(whiptail --nocancel --title "Debian config" --menu "Menu Items:" 20 70 10 \
		"Clone repo"            "-" \
		"Config sources"        "-" \
		"Config shell"          "-" \
		"Install GUI"           "-" \
		"Install packages"      "-" \
		"Copy scripts"          "-" \
		"Disable beep"          "-" \
		"Config PC things"      "-" \
		"Exit"                  "-" 3>&1 1>&2 2>&3)

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
		"Disable beep")
            config_beep
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

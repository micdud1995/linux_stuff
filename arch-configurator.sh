#!/bin/bash

#==============================================================================
# Title             arch-configurator.sh
# Description       This script will config installed Arch GNU/Linux system 
# Author            Michał Dudek 
# Date              01-10-2015
# Version           1.0
# Notes             Run as a user 
# License           GNU General Public License v3.0
#==============================================================================

info(){
    if [[ $UID == 0  ]]; then
        whiptail --title "Arch config" --msgbox \
        "Please run this script as a user" 20 70
    else
        main_menu
    fi
}

repo_dirs() {
    if [[ ! -d $HOME/repo/linux_stuff ]]; then
        if (whiptail --title "Cloning repository" --yes-button "Yes" --no-button "No" --yesno \
            "Do you want to clone repo?\nThere are important files for this program\n\nRepository: \ngithub.com/micdud1995/linux_stuff.git" 20 70) then

            mkdir -p $HOME/repo
            mkdir -p $HOME/tmp
            mkdir -p $HOME/Documents
            mkdir -p $HOME/Downloads
            mkdir -p $HOME/Music
            mkdir -p $HOME/Pictures
            mkdir -p $HOME/Video

            # Creating repo dir and cloning repository
            if [[ ! -d $HOME/repo/linux_stuff ]]; then
                cd $HOME/repo
                sudo pacman -S git
                git clone https://github.com/micdud1995/linux_stuff.git
            fi
        fi
    else
        whiptail --title "Arch config" --msgbox "OK, $HOME/repo/linux_stuff exists already" 20 70
    fi

    config_pacman
}

config_pacman() {
    if (whiptail --title "Updating pacman.conf" --yes-button "Yes" --no-button "No" --yesno \
        "Do you want to copy pacman.conf?\n\n1) Adds multilib\n2) Adds AUR\n3) Blocks autoupdate kernel" 20 70) then

        sudo cp $HOME/repo/linux_stuff/config-files/pacman/pacman.conf /etc/pacman.conf

        sudo pacman -Syu
        sudo pacman -S yaourt 
        yaourt -S ttf-font-awesome
        yaourt -S xcalib
    fi

    config_shell
}

config_shell() {
    if (whiptail --title "Shell" --yes-button "Yes" --no-button "No" --yesno \
        "Do you want to config shell?\n\nYou can choose between zsh and bash.\nScript will unpack fancy config file for it." 20 70) then

        sudo pacman -S ttf-inconsolata

        SHELL=$(whiptail --nocancel --title "Select shell" --menu "Select your shell:" 20 70 10 \
        "Bash"  "" \
        "Zsh"   "" 3>&1 1>&2 2>&3)

        case "$SHELL" in
            "Bash")
                sudo pacman -S colordiff bash
                cp $HOME/repo/linux_stuff/config-files/bash/hide.bashrc $HOME/.bashrc
                sudo chsh -s /bin/bash
            ;;
            "Zsh")
                sudo pacman -S colordiff zsh
                cp $HOME/repo/linux_stuff/config-files/zsh/hide.zshrc $HOME/.zshrc
                sudo chsh -s /bin/zsh
            ;;
        esac
    fi

    config_drivers
}

config_drivers() {
    if (whiptail --title "Drivers" --yes-button "Yes" --no-button "No" --yesno \
        "Do you want to install xorg with graphic drivers?" 20 70) then

        sudo pacman -S xorg-server xorg-server-utils mesa xorg-xinit xterm

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
                sudo cp $HOME/repo/linux_stuff/config-files/virtualbox/vbox.conf /etc/modules-load.d/vbox.conf
            ;;
        esac

    fi

    config_gui
}

config_gui() {
    if (whiptail --title "Arch config" --yes-button "Yes" --no-button "No" --yesno \
        "Do you want to install a DE or WM?\n\n\n\n*awesome is configurable tiling wm\n\n*i3 is an improved dynamic, tiling window manager \n\n*LXDE is an extremely fast-performing desktop environment" 20 70) then

        DE=$(whiptail --title  "Arch config" --menu "Select environment:" 20 70 10 \
        "awesome"           "configurable tiling WM" \
        "i3"                "i3 tiling WM" \
        "xfce"              "lightweight DE" \
        "lxde"         "fast DE"   3>&1 1>&2 2>&3)

        case "$DE" in
            "awesome")
                sudo pacman -S awesome
                mkdir -p $HOME/.config/awesome
                mkdir -p ~/.config/awesome/themes/
                mkdir -p ~/.config/awesome/themes/my
                cp $HOME/repo/linux_stuff/config-files/rc.lua $HOME/.config/awesome/rc.lua
                echo "exec awesome" > ~/.xinitrc
            ;;
            "i3")
                sudo pacman -S lxterminal i3 dmenu i3status feh screenfetch weechat htop moc ranger w3m
                mkdir -p $HOME/.i3
                mkdir -p $HOME/Obrazy
                cp $HOME/repo/linux_stuff/i3/hide.i3status.conf ~/.i3status.conf
                cp $HOME/repo/linux_stuff/i3/config ~/.i3/config
                cp $HOME/repo/linux_stuff/i3/workspace* ~/.i3/
                cp $HOME/repo/linux_stuff/i3/load_workspaces.sh ~/.i3/
                chmod +x $HOME/.i3/load_workspaces.sh
                cp $HOME/repo/linux_stuff/i3/i3lock-deb.png ~/Obrazy/i3lock-deb.png
                echo "exec i3" > ~/.xinitrc
            ;;
            "lxde")
                sudo pacman -S lxde-common openbox lxterminal lxrandr lxpanel
                echo "startlxde" > ~/.xinitrc
            ;;
            "xfce")
                sudo pacman -S xfce4
                echo "startxfce4" > ~/.xinitrc
            ;;
        esac
    fi

    if (whiptail --title "Making Esc from Caps Lock" --yes-button "Yes" --no-button "No" --yesno \
        "Do you want to use Caps Lock as a additional Escape?" 20 70) then
        sudo setxkbmap -option caps:escape &
    fi

    config_packages
}

config_packages() {
    if (whiptail --title "Arch config" --yes-button "Yes" --no-button "No" --yesno \
        "Do you want to install some common software?\n\nPackages demanding configuration will be configured automatically." 20 70) then

        software=$(whiptail --title "Additional software" --checklist "Choose your desired software \nUse spacebar to check/uncheck \npress enter when finished" 20 70 14 \
            "alsa-utils"                    "Sound" OFF \
            "apache"  	                    "Web Server" OFF \
            "bash"                          "Shell" OFF \
            "brasero"                       "Burning app" OFF \
            "cmus"                          "Music player" OFF \
            "conky"                         "System Info" OFF \
            "dictd"                         "Offline dictionary" OFF \
            "dwb"                           "Web Browser" OFF \
            "faenza-icon-theme"             "Icon Theme" OFF \
            "feh"                           "Image Viewer" OFF \
            "git"                           "Content tracker" OFF \
            "htop"                          "Process Info" OFF \
            "irssi"                         "IRC Client" OFF \
            "libncurses5-dev"               "ncurses" OFF \
            "libreoffice-still"             "Libre Office" OFF \
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
            "p7zip"                         "File archiver" OFF \
            "pavucontrol"                   "Sound output" OFF \
            "pcmanfm"                       "File manager" OFF \
            "pinta"                         "Image Editor" OFF \
            "ranger"                        "File manager" OFF \
            "rtorrent"                      "Torrent Client" OFF \
            "screenfetch"                   "System Info" OFF \
            "slim"                          "Login Manager" OFF \
            "scrot"                         "Screenshots" OFF \
            "steam"                         "Steam Client" OFF \
            "thefuck"                       "Command correcting" OFF \
            "tor"                           "Communication System" OFF \
            "tree"                          "Tree of dirs" OFF \
            "ufw"                           "Firewall" OFF \
            "unrar"                         "File archiver" OFF \
            "unzip"                         "Unpack zip archives" OFF \
            "vim-minimal" 	  	            "Text Editor" OFF \
            "vim" 	  	                    "Vim with script support" OFF \
            "virtualbox"                    "Virtual Machines" OFF \
            "weechat"                       "IRC Client" OFF \
            "xfburn"                        "Burning tool" OFF \
            "xorg-xbacklight"               "Screen brightness" OFF \
            "xterm"                         "Terminal emulator" OFF \
            "youtube-dl"                    "YT Download" OFF \
            "zathura"                       "PDF Viewer" OFF \
            "zip"                           "Files archiver" OFF \
            "zsh"     	                    "Z-shell" OFF 3>&1 1>&2 2>&3)

        download=$(echo "$software" | sed 's/\"//g')
        sudo pacman -S $download

	case "$download" in 
		*zathura*)
            sudo pacman -S zathura-pdf-poppler
        ;;
		*alsa-utils*)
            sudo pacman -S alsa-firmware alsa-lib alsa-plugins alsa-utils pulseaudio pulseaudio-alsa libcanberra libcanberra-pulse
        ;;
		*dictd*)
		    language=$(whiptail --title "Dictionary languages" --menu "Choose your dictionary" 20 70 11 \
		    "eng-deu" \
		    "eng-fra" \
		    "eng-spa" 3>&1 1>&2 2>&3)

		    case "$language" in
			"eng-deu")
			    yaourt -S dict-freedict-eng-deu
			;;
			"eng-fra")
			    yaourt -S dict-freedict-eng-fra
			;;
			"eng-spa")
			    yaourt -S dict-freedict-eng-spa
			;;
		    esac
		;;
        *ranger*)
            sudo pacman -S w3m
            mkdir -p $HOME/.config/ranger
            mkdir -p $HOME/.config/ranger/colorschemes
            cp $HOME/repo/linux_stuff/config-files/ranger/solarized.py $HOME/.config/ranger/colorschemes/
            cp $HOME/repo/linux_stuff/config-files/ranger/rc.conf $HOME/.config/ranger/
        ;;
		*cmus*)
		    sudo cp $HOME/repo/linux_stuff/config-files/cmus/zenburn.theme /usr/share/cmus/
		;;
		*weechat*)
		    mkdir -p $HOME/.weechat
		    cp $HOME/repo/linux_stuff/config-files/weechat/* $HOME/.weechat/
		    rm -f $HOME/.weechat/weechat.log
		    ln -s /dev/null weechat.log
		;;
		*newsbeuter*)
		    mkdir -p $HOME/.config/newsbeuter
		    cp $HOME/repo/linux_stuff/config-files/newsbeuter/urls $HOME/.config/newsbeuter/urls
		    cp $HOME/repo/linux_stuff/config-files/newsbeuter/config $HOME/.config/newsbeuter/config
		;;
		*conky*)
		    cp ~/repo/linux_stuff/conky/conky.conf ~/.conkyrc
		    cp ~/repo/linux_stuff/conky/hoog0555_cyr2.ttf /usr/share/fonts/truetype/ 
		;;
		*dwb*)
		    cp ~/repo/linux_stuff/config-files/dwb/bookmarks ~/.config/dwb/default/bookmarks
		;;
		*git*)
		    name=$(whiptail --nocancel --inputbox "Set git username:" 20 70 "Michał Dudek" 3>&1 1>&2 2>&3)
		    git config --global user.name "$name"
		    mail=$(whiptail --nocancel --inputbox "Set git usermail:" 20 70 "dud95@gmx.us" 3>&1 1>&2 2>&3)
		    git config --global user.email $mail
		;;
		*openssh*)
		    sudo pacman -S openssh
		    sudo iptables -I INPUT -p tcp --dport 22 -j ACCEPT
            sudo systemctl restart sshd
		;;
		*mc*)
		    mkdir -p $HOME/.config/mc
		    mkdir -p $HOME/.local/share/mc/skins
		    cp $HOME/repo/linux_stuff/config-files/midnight-commander/mc.ext $HOME/.config/mc/mc.ext
		    cp $HOME/repo/linux_stuff/config-files/midnight-commander/darkcourses_green.ini $HOME/.local/share/mc/skins/
		;;
		*moc*)
		    mkdir -p $HOME/.moc
		    cp $HOME/repo/linux_stuff/config-files/moc/arch-config $HOME/.moc/config
		    cp $HOME/repo/linux_stuff/config-files/moc/cyanic_theme /usr/share/moc/themes/
		;;
		*libreoffice-still*)
		    language=$(whiptail --title "Libre office language" --menu "Choose your language" 20 70 11 \
		    "Polski"        "Polish" \
		    "Deutsch"       "German" \
		    "British"       "English_british" \
		    "Espanol"       "Spanish" 3>&1 1>&2 2>&3)

		    case "$language" in
			"Polski")
			    sudo pacman -S libreoffice-still-pl
			;;
			"Deutsch")
			    sudo pacman -S libreoffice-still-de
			;;
			"British")
			    sudo pacman -S libreoffice-still-en-GB
			;;
			"Espanol")
			    sudo pacman -S libreoffice-still-es 
			;;
		    esac
		;;
		*mutt*)
		    cp $HOME/repo/linux_stuff/config-files/mutt/hide.muttrc $HOME/.muttrc
		;;
		*irssi*)
		    mkdir $HOME/.irssi
		    if (whiptail --title "Irssi channels" --yes-button "Yes" --no-button "No" --yesno \
			"Do you want to add channels to autostart?\n\n#debian\n#debian-offtopic\n#listekklonu\n#plug\n#error" 20 70) then

			cp $HOME/repo/linux_stuff/config-files/irssi/config $HOME/.irssi/config
			cp $HOME/repo/linux_stuff/config-files/cyanic.theme $HOME/.irssi/
		    fi
		;;
		*rtorrent*)
		    mkdir -p $HOME/.rtorrent
		    cp ~/repo/linux_stuff/config-files/rtorrent/hide.rtorrent-arch.rc ~/.rtorrent.rc
		;;
		*virtualbox*)
            sudo pacman -S virtualbox virtualbox-host-modules virtualbox-guest-iso
            sudo modprobe vboxdrv
            sudo cp $HOME/repo/linux_stuff/config-files/virtualbox/virtualbox.conf /etc/modules-load.d/virtualbox.conf
            sudo gpasswd -a $USER vboxusers
		;;
		*steam*)
		    sudo pacman -S curl zenity steam 
		;;
		*slim*)
            sudo pacman -S archlinux-themes-slim
            sudo systemctl enable slim.service
		    cp $HOME/repo/linux_stuff/config-files/slim/slim.conf /etc/slim.conf
		;;
		*lightdm*)
            sudo systemctl enable lightdm.service 
		    cp $HOME/repo/linux_stuff/config-files/lightdm/lightdm.conf /etc/ligthdm/lightdm.conf
		;;
		*vim-minimal*)
		    #==============================================================
		    # Plugin list:
		    #	Pathogen
		    #	Nerdtree
		    #	Syntastic
		    #	Tagbar / Taglist
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

		    sudo pacman -S vim-minimal curl ctags ttf-inconsolata 
            sudo pacman -S vim-nerdtree vim-syntastic vim-taglist vim-airline vim-supertab vim-jellybeans vim-ctrlp

		    # Making dirs
		    mkdir -p ~/tmp ~/.vim/autoload ~/.vim/bundle ~/.vim/colors ~/tmp/tagbar

		    # Pathogen
		    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

		    # Git-gutter
		    cd ~/.vim/bundle && \
		    git clone git://github.com/airblade/vim-gitgutter.git

		    # Auto-pairs
		    cd ~/.vim/bundle && \
		    git clone git://github.com/jiangmiao/auto-pairs.git

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

		    # Copying .vimrc
		    cp ~/repo/linux_stuff/vim/hide.vimrc ~/.vimrc
		    
		;;
		*vim*)
		    #==============================================================
		    # Plugin list:
		    #	Pathogen
		    #	Nerdtree
		    #	Syntastic
		    #	Tagbar / Taglist
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

		    sudo pacman -S vim cmake curl ctags ttf-inconsolata 
            sudo pacman -S vim-nerdtree vim-syntastic vim-taglist vim-airline vim-supertab vim-jellybeans vim-ctrlp

		    # Making dirs
		    mkdir -p ~/tmp ~/.vim/autoload ~/.vim/bundle ~/.vim/colors ~/tmp/tagbar

		    # Pathogen
		    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

		    # Git-gutter
		    cd ~/.vim/bundle && \
		    git clone git://github.com/airblade/vim-gitgutter.git

		    # Auto-pairs
		    cd ~/.vim/bundle && \
		    git clone git://github.com/jiangmiao/auto-pairs.git

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

		    # YouCompleteMe
            sudo pacman -S cmake
		    cd ~/.vim/bundle/
		    git clone https://github.com/Valloric/YouCompleteMe.git
		    cd YouCompleteMe/
		    git submodule update --init --recursive
		    ./install.sh

		    # Copying .vimrc
		    cp ~/repo/linux_stuff/vim/hide.vimrc ~/.vimrc
		;;

	esac
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
            sudo pacman -S fuse ntfs-3g udisks2
            cp $HOME/repo/linux_stuff/config-files/scripts/m /usr/local/bin/
            sudo chmod +x /usr/local/bin/m
        fi

        if [[ $scripts == *" um "* ]] ; then
            sudo pacman -S fuse ntfs-3g udisks2
            cp $HOME/repo/linux_stuff/config-files/scripts/um /usr/local/bin/
            chmod +x /usr/local/bin/um
        fi

        if [[ $scripts == *" live-usb "* ]] ; then
            cp $HOME/repo/linux_stuff/config-files/scripts/live-usb /usr/local/bin/
            sudo chmod +x /usr/local/bin/live-usb
        fi
    fi 

    config_beep
}

config_beep() {
    if (whiptail --title "Beep sound" --yes-button "Yes" --no-button "No" --yesno \
        "Do you want to disable beep sound in your system?\n\nA beep is a short, single tone, typically high-pitched, generally made by a computer." 20 70) then

        sudo rmmod pcspkr
        sudo echo "blacklist pcspkr" > /etc/modprobe.d/nobeep.conf
    fi

    config_pc
}

config_pc() {
    if (whiptail --title "Additional settings" --yes-button "Yes" --no-button "No" --yesno \
        "Do you want to configure computer options?\n\nYou can set here things depending on your computer and personal preferences." 20 70) then

        scripts=$(whiptail --title "Additional scripts" --checklist "Choose your desired software\nSpacebar - check/uncheck \nEnter - finished" 20 70 10 \
            "Wallpaper"     "Set wallpaper" OFF \
            "Touchpad"      "Enable touchpad" OFF \
            "CS:GO config"  "Global Offensive config file" OFF \
            "Lid"     	    "Don't suspend laptop when lid closed" OFF 3>&1 1>&2 2>&3)

        if [[ $scripts == *" Wallpaper "* ]] ; then
            sudo pacman -S feh 
            mkdir -p $HOME/Obrazy
            sudo cp $HOME/repo/linux_stuff/config-files/wallpaper.jpg $HOME/Obrazy/wallpaper.jpg
            feh --bg-scale $HOME/Obrazy/wallpaper.jpg
        fi

        if [[ $scripts == *" Touchpad "* ]] ; then
            mkdir -p /etc/X11/xorg.conf.d
            sudo cp $HOME/repo/linux_stuff/config-files/50-synaptics.conf /etc/X11/xorg.conf.d/50-synaptics.conf
        fi

        if [[ $scripts == *" CS:GO config "* ]] ; then
            if [[ -d $HOME/.steam/steam/steamapps/common/Counter-Strike\ Global\ Offensive/csgo/cfg ]]; then
                sudo cp $HOME/repo/linux_stuff/config-files/CS:GO/autoexec.cfg $HOME/.steam/steam/steamapps/common/Counter-Strike\ Global\ Offensive/csgo/cfg/
            else
                whiptail --title "Arch config" --msgbox "Counter-Strike Global Offensive isn't installed" 20 70
            fi
        fi

        if [[ $scripts == *" Lid "* ]] ; then
            sudo cp $HOME/repo/linux_stuff/config-files/logind.conf /etc/systemd/logind.conf
        fi
    fi 

    whiptail --title "Arch config" --msgbox "System configured." 20 70
    exit
}

main_menu() {
	menu_item=$(whiptail --nocancel --title "Arch config" --menu "Menu Items:" 20 70 10 \
		"Clone repo"            "-" \
		"Config sources"        "-" \
		"Config shell"          "-" \
		"Config drivers"          "-" \
		"Install GUI"           "-" \
		"Install packages"      "-" \
		"Copy scripts"          "-" \
		"Disable beep"          "-" \
		"Config PC things"      "-" \
		"Exit Installer"        "-" 3>&1 1>&2 2>&3)

	case "$menu_item" in
		"Clone repo")
            repo_dirs
		;;
		"Config sources")
            config_pacman
		;;
		"Config shell")
            config_shell
		;;
		"Config drivers")
            config_drivers
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
            whiptail --title "Arch config" --msgbox "System configured." 20 70
            exit
		;;
	esac
}

info

language="pl"
session="i3"

setxkbmap $language
xset b off
xset b 0 0 0
xrdb -merge $HOME/.Xresources

# udiskie -t -n --file-manager=pcmanfm &

# Redshift with Wroclaw location
# redshift -l 51.107:17.04 -t 5500:3500 -b 0.9:0.8 &

# Run conky
# conky &

# Run tint2 panel
# tint2 &

# Volume control
amixer sset Master 60%
amixer sset Master unmute

case $session in
    awesome           ) exec awesome;;
    bspwm             ) exec bspwm;;
    catwm             ) exec catwm;;
    cinnamon          ) exec cinnamon-session;;
    dwm               ) exec dwm;;
    enlightenment     ) exec enlightenment_start;;
    ede               ) exec startede;;
    fluxbox           ) exec startfluxbox;;
    gnome             ) exec gnome-session;;
    gnome-classic     ) exec gnome-session --session=gnome-classic;;
    i3|i3wm           ) exec i3;;
    icewm             ) exec icewm-session;;
    jwm               ) exec jwm;;
    kde               ) exec startkde;;
    lxde              ) exec startlxde;;
    mate              ) exec mate-session;;
    monster|monsterwm ) exec monsterwm;;
    notion            ) exec notion;;
    openbox           ) exec openbox-session;;
    unity             ) exec unity;;
    xfce|xfce4        ) exec startxfce4;;
    xmonad            ) exec xmonad;;
esac

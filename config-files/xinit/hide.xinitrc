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
    awesome ) exec awesome;;
    dwm     ) exec dwm;;
    gnome   ) exec gnome-session;;
    i3      ) exec i3;;
    kde     ) exec startkde;;
    lxde    ) exec startlxde;;
    openbox ) exec openbox-session;;
    xfce4   ) exec startxfce4;;
esac

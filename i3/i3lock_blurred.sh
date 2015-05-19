# Script that make blurred lockscreen from the current screen 

scrot /tmp/screen.png
convert /tmp/screen.png -scale 50% -scale 200% /tmp/screen.png
i3lock -u -i /tmp/screen.png

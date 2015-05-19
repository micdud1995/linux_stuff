# Script that make blurred lockscreen from the current screen 

scrot ~/tmp/screen.png

# Making screen blurred
convert ~/tmp/screen.png -scale 50% -scale 200% ~/tmp/screen.png

# Adding a image that will be in the center
# [[ -f path/to/file.png ]] && convert ~/tmp/screen.png path/to/file.png -gravity center -composite -matte ~/tmp/screen.png

# Activating i3lock
i3lock -i ~/tmp/screen.png

# Removing tmp file
rm ~/tmp/screen.png

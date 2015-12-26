Description
=====================

Config files with simple scripts that unpack/install/config all that stuff:
Vim, file managers, shells and many others.


Running
=====================

To run script:

* in Debian:
    
    1) Config visudo


    2) Make script executable

        chmod +x debian-configurator.sh

    3) Run it with sudo

        sudo ./debian-configurator.sh

* in Arch:
    
    1) Make script executable

        chmod +x debian-configurator.sh

    1) Install depedencies

        pacman -S libnewt

    3) Run it as a user

        ./arch-configurator.sh
    

➤ program layout:
=====================
![i3 wm autostart layout](https://raw.github.com/micdud1995/linux_stuff/master/img/screenshot-program.png)

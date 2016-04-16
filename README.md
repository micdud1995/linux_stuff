Description
=====================

Config files with simple scripts that unpack/install/config all that stuff:
Vim, file managers, shells and many others.


Running
=====================


* in Debian:
    
    1) Edit sudoers file with visudo command
        ```
        visudo
        ```

    2) Make script executable
        ```
        chmod +x debian-configurator.sh
        ```

    3) Run it with sudo
        ```
        sudo ./debian-configurator.sh
        ```
        

* in Arch:
    
    1) Make script executable
        ```
        chmod +x debian-configurator.sh
        ```

    2) Install depedencies
        ```
        pacman -S libnewt
        ```

    3) Run it as a user
        ```
        ./arch-configurator.sh
        ```
    

Program layout:
=====================
![program layout](https://raw.github.com/qeni/linux_stuff/master/img/screenshot-program.png)

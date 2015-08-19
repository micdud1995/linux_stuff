#=================================================================
# BASIC
export EDITOR=vim
export BROWSER=google-chrome
#=================================================================

#=================================================================
# PROMPT
color_prompt=yes

if [ "$color_prompt" = yes ]; then
    # Red
    # PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\u]—[\W]  \[$(tput sgr0)\]"
    # Green
    PS1="\[$(tput bold)\]\[$(tput setaf 2)\][\u]—[\W] \[$(tput sgr0)\]"
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

unset color_prompt 
#=================================================================

#=================================================================
# HISTORY
export HISTFILE=$HOME/.bash_history
# ignore commands
export HISTIGNORE='&:ls:l::cd:exit:clear:history'
# bash history will save N commands
HISTSIZE=1024
# bash will remember N commands
HISTFILESIZE=512
# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
# append to the history file, don't overwrite it
shopt -s histappend
#=================================================================

#=================================================================
# FUNCTIONS

#copy and go to dir
cpg (){
  if [ -d "$2" ];then
    cp $1 $2 && cd $2
  else
    cp $1 $2
  fi
}

#move and go to dir
mvg (){
  if [ -d "$2" ];then
    mv $1 $2 && cd $2
  else
    mv $1 $2
  fi
}

# Extract archives
extract () {
    if [ -f $1 ] ; then
      case $1 in
        *.tar.bz2)   tar xjf $1     ;;
        *.tar.gz)    tar xzf $1     ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar e $1     ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xf $1      ;;
        *.tbz2)      tar xjf $1     ;;
        *.tgz)       tar xzf $1     ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *)     echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

# Remind me 
# usage: remindme <time> <text>
# e.g.: remindme 10m "omg, the pizza"
remindme() { sleep $1 && zenity --info --text "$2" & }

# Calculator
# usage: calc <equation>
calc() {
  if which bc &>/dev/null; then
    echo "scale=3; $*" | bc -l
  else
    awk "BEGIN { print $* }"
  fi
}

# Find and removed empty directories
fared() {
    read -p "Delete all empty folders recursively [y/N]: " OPT
    [[ $OPT == y ]] && find . -type d -empty -exec rm -fr {} \; &> /dev/null
}

# ii() - info
function ii()
{
    echo -e "\nSysteminformation:$NC " ; uname -a
    echo -e "\nCurrent date :$NC " ; date
    echo -e "\nMachine stats :$NC " ; uptime
    echo -e "\nMemory stats :$NC " ; free -ht
    echo
}
#=================================================================

#=================================================================
# OTHER

# update the values of LINES and COLUMNS after each command
shopt -s checkwinsize
# correct cd typos
shopt -s cdspell
# apend history instead of overwriting file
shopt -s histappend
# Bash attempts to save all lines of a multiple-line command in the same history entry
shopt -s cmdhist
# Extended pattern
shopt -s extglob

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
#=================================================================

#=================================================================
# Aliases
# clear the screen
	alias c='clear'
# ls with colors
	alias ls='ls --color'
# ls witch colors and screen cleaning
    alias l="ls --color -lg"
# shutdown the system
	alias off='systemctl poweroff'
# show hidden files only
	alias l.='ls -d .* --color=auto'
# list all folders
	alias lf='ls -Gl | grep ^d'
# grep aliases
    alias grep='grep --color=auto'
# other
    alias diff='colordiff'  # requires colordiff package
    alias df='df -kTh'
    alias free='free -ht'
    alias ip='sudo ip addr show'
# system upgrade
	alias upgrade='sudo aptitude update; sudo aptitude upgrade; sudo aptitude clean'
# aptitude aliases
    alias a="aptitude"
	alias ai="sudo aptitude install"
	alias as="aptitude search"
    alias ar="sudo aptitude remove"
# pacman aliases
	alias S="sudo pacman -S" # Install package
	alias Ss="pacman -Ss" # Search packages
	alias Sy="sudo pacman -Sy" # Synchronize the repository databases
	alias Syu="sudo pacman -Syu" # Synchronize the repository databases and update the system's packages
	alias R="sudo pacman -Rs" # Remove package
	alias U="sudo pacman -U" # Upgrade package
	alias V="pacman -V" # Version of package
# Xrandr aliases
	alias hdmi_1366x768="xrandr --output HDMI1 --mode 1366x768"
	alias hdmi_auto="xrandr --output HDMI1 --auto"
	alias hdmi_off="xrandr --off"
# show which commands you use the most
	alias freq='cut -f1 -d" " ~/.zsh_history | sort | uniq -c | sort -nr | head -n 30'
# move aliases	
	alias ..="cd ..;ls"
	alias ...="cd ../..;ls"
	alias ....="cd ../../..;ls"	
	alias repo="cd ~/repo"
# Git aliases
	alias gs="git status -sb"
	alias gd="git diff --word-diff --color"
	alias ga="git add"
	alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
	alias gp="git push"
	alias gpl="git pull"
	alias gcl="git clone"
	alias gc="git commit"
	alias gcm="git commit -m"
	alias gch="git checkout"
	alias gb="git branch"
	alias gr="git reset" # e.g. git reset abc.txt
	alias grc="git reset --hard HEAD~1" # git reset commit
# Programs aliases
    alias config="vim ~/repo/linux_stuff/config.sh"
 	alias r="ranger"
	alias v="vim"
    alias last="expac --timefmt='%Y-%m-%d %T' '%l\t%n' | sort | tail -25"
    alias x="chmod +x"
    alias hist="cat ~/.zshr_history | grep"
    alias y="youtube-dl -f 18"
    alias yhd="youtube-dl -f 22"
    alias pyt="vim ~/.vim/bundle/vim-snippets/snippets/python.snippets"
    # up wired connection
    alias eth="sudo dhclient eth0"
    alias izak="livestreamer -p mpv twitch.tv/izakooo "
    alias pasha="livestreamer -p mpv twitch.tv/pashabiceps "
    alias zdupy="livestreamer -p mpv twitch.tv/zdupy"
    alias taz="livestreamer -p mpv twitch.tv/g5taz"
    alias neo="livestreamer -p mpv twitch.tv/neog5"
#=================================================================

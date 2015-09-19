#=================================================================
autoload -U colors zsh-mime-setup select-word-style
colors
# run everything as if it's an executable
zsh-mime-setup  
# switching to vim mode
bindkey -v 
# Disabling Caps-Lock
setxkbmap -option ctrl:nocaps
#=================================================================

#=================================================================
# Vcs info
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn hg
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' formats "%{$fg[yellow]%}%c%{$fg[green]%}%u%{$reset_color%} [%{$fg[orange]%}%b%{$reset_color%}] %{$fg[yellow]%}%s%{$reset_color%}:%r"
precmd() {  # run before each prompt
  vcs_info
}
#=================================================================

#=================================================================
# Prompt
setopt PROMPT_SUBST     # allow funky stuff in prompt
color="white"
if [ "$USER" = "root" ]; then
    color="red"         
fi;
prompt="%{$fg[$color]%}[%n]──%{$reset_color%}[%U%{$fg[cyan]%}%m]%{$reset_color%}%~
 └──────> "
RPROMPT='${vim_mode} ${vcs_info_msg_0_}'
#=================================================================

#=================================================================
# Completion
autoload -U compinit
compinit
zmodload -i zsh/complist        
setopt hash_list_all            # hash everything before completion
setopt completealiases          # complete aliases
setopt always_to_end            # when completing from the middle of a word, move the cursor to the end of the word    
setopt complete_in_word         # allow completion from within a word/phrase
setopt correct                  # spelling correction for commands
setopt list_ambiguous           # complete as much of a completion until it gets ambiguous.
#=================================================================

#=================================================================
zstyle ':completion::complete:*' use-cache on               # completion caching, use rehash to clear
zstyle ':completion:*' cache-path ~/.zsh/cache              # cache path
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'   # ignore case
zstyle ':completion:*' menu select=2                        # menu if nb items > 2
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}       # colorz !
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate # list of completers to use
#=================================================================

#=================================================================
# sections completion
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format $'\e[00;34m%d'
zstyle ':completion:*:messages' format $'\e[00;31m%d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:manuals' separate-sections true
#=================================================================

#=================================================================
zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=29=34"
zstyle ':completion:*:*:killall:*' menu yes select
zstyle ':completion:*:killall:*' force-list always
users=(jvoisin root)           # because I don't care about others
zstyle ':completion:*' users $users
#=================================================================

#=================================================================
#generic completion with --help
compdef _gnu_generic gcc
compdef _gnu_generic gdb
#=================================================================

#=================================================================
# Pushd
setopt auto_pushd               # make cd push old dir in dir stack
setopt pushd_ignore_dups        # no duplicates in dir stack
setopt pushd_silent             # no dir stack after pushd or popd
setopt pushd_to_home            # `pushd` = `pushd $HOME`
#=================================================================

#=================================================================
# History
HISTFILE=~/.zsh_history         # where to store zsh_history file
HISTSIZE=1024                   # big history
SAVEHIST=1024                   # big history
setopt append_history           # append
setopt hist_ignore_all_dups     # no duplicate
unsetopt hist_ignore_space      # ignore space prefixed commands
setopt hist_reduce_blanks       # trim blanks
setopt hist_verify              # show before executing history commands
setopt inc_append_history       # add commands as they are typed, don't wait until shell exit 
setopt share_history            # share hist between sessions
setopt bang_hist                # !keyword
#=================================================================

#=================================================================
# Various
setopt auto_cd                  # if command is a path, cd into it
setopt auto_remove_slash        # self explicit
setopt chase_links              # resolve symlinks
setopt correct                  # try to correct spelling of commands
setopt extended_glob            # activate complex pattern globbing
setopt glob_dots                # include dotfiles in globbing
setopt print_exit_value         # print return value if non-zero
unsetopt beep                   # no bell on error
unsetopt bg_nice                # no lower prio for background jobs
unsetopt clobber                # must use >| to truncate existing files
unsetopt hist_beep              # no bell on error in history
unsetopt hup                    # no hup signal at shell exit
unsetopt ignore_eof             # do not exit on end-of-file
unsetopt list_beep              # no bell on ambiguous completion
unsetopt rm_star_silent         # ask for confirmation for `rm *' or `rm path/*'
setxkbmap -option compose:ralt  # compose-key
print -Pn "\e]0; %n@%M: %~\a"   # terminal title
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
#=================================================================
#!/bin/sh 

################################################
## Options

shopt -s autocd
shopt -s globstar # For recursive globbing with **/* etc

# Use vi mode
set -o vi


################################################
## History

# Don't put duplicate lines in the history. See bash(1) for more options
# Eternal bash history.
# ---------------------
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE=~/.bash_eternal_history
export HISTCONTROL=ignoredups

shopt -s histappend

################################################
## Prompt

source /usr/share/git/completion/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWCOLORHINTS=
GIT_PS1_DESCRIBE_STYLE="branch"
GIT_PS1_SHOWUPSTREAM="auto git"
# prompt='__git_ps1 "\[\e[31m\]@\u\[\e[34m\] \w\n\[\e[30;43m\]" "\\\$\[\e[0m\] "'
prompt='__git_ps1 "\[\e[40;31m\]\u\[\e[39;40m\]\w \[\e[30;43m\]" "\\\$\[\e[0m\] "'

# Hack to update history on every prompt
PROMPT_COMMAND="history -a; history -n; $prompt"

################################################
# Color 
# export TERM="rxvt-256color"
#
if [ -x /usr/bin/dircolors ]; then
  eval "`dircolors ~/.dircolors`"
  alias ls='ls --color=auto'
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'
#
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
  alias diff='colordiff' # requires colordiff package
  alias pgrep='pgrep'
fi

################################################
## {{{ Aliases

## Dot cd
alias b='cd $OLDPWD'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
alias ........='cd ../../../../../../..'
alias .........='cd ../../../../../../../..'

## Shortcuts 
alias vim='vim -p --servername `date +%s`'
alias vs='vim-server'
alias rc='ranger-cd'
alias rs='ranger --cmd="set column_ratios 0,5,0" --cmd="set draw_borders false" --cmd="set preview_files false" --cmd="set preview_directories false" --cmd="set vcs_aware true"'

# alias xclip="xclip -selection c"
alias rv='ruby -e "print RUBY_VERSION"'

## Modified commands
alias more='less'
alias df='df -h'
alias du='du -c -h'
alias mkdir='mkdir -p -v'
alias ping='ping -c 5'
alias dmesg='dmesg -HL'
alias cp="cp -i"                       # confirm before overwriting something
# alias rm="rm -i"                     # confirm before overwriting something
# alias mv="mv -i"                       # confirm before overwriting something
alias reset="echo -ne '\033c'"
alias hide_cursor='echo -ne "\033[?25l"'
alias show_cursor='echo -ne "\033[?25h"'
alias feh='feh --auto-zoom --geometry 500x375 --sort filename'
alias tmux="TERM=screen-256color tmux"

## New commands
alias da='date "+%A, %B %d, %Y [%T]"'  # print current date
alias du1='du --max-depth=1'           # file size one folder deep
alias du2='du --max-depth=2'           # file size two folders deep
alias h='history | grep'               # requires an argument
alias openports='ss --all --numeric --processes --ipv4 --ipv6'
alias xp='xprop | grep "WM_WINDOW_ROLE\|WM_CLASS" && echo "WM_CLASS(STRING) = \"NAME\", \"CLASS\""'
## pacman
alias pe='expac -HM "%011m\t%-20n\t%10d" $( comm -23 <(pacman -Qqen|sort) <(pacman -Qqg base base-devel|sort) ) | sort -n'
## Keychain
alias chain='eval $(keychain --eval --agents ssh -Q --quiet id_rsa)'

## ls 
alias ll='ls -lh'                      # list detailed with human-readable sizes
alias la='ls -a'                       # list all files
alias lla='ls -lha'                    # list all detailed with human-readable sizes
alias lsd="ls /dev | grep sd"          # list all drives
alias lr='ls -R'                       # recursive ls
alias lx='ll -BX'                      # sort by extension
alias lz='ll -rS'                      # sort by size
alias lt='ll -rt'                      # sort by date
alias lm='la | less'                   # pipe to less

alias q='exit'
alias pacman-disowned-dirs="comm -23 <(sudo find / \( -path '/dev' -o -path '/sys' -o -path '/run' -o -path '/tmp' -o -path '/mnt' -o -path '/srv' -o -path '/proc' -o -path '/boot' -o -path '/home' -o -path '/root' -o -path '/media' -o -path '/var/lib/pacman' -o -path '/var/cache/pacman' \) -prune -o -type d -print | sed 's/\([^/]\)$/\1\//' | sort -u) <(pacman -Qlq | sort -u)"



################################################ }}}
# Handy functions

# Start ranger if its not already open
r() {
    if [ -z "$RANGER_LEVEL" ]
    then
        ranger
    else
        exit
    fi
}

# Dictionary
dic() {
  sdcv $@ | less
}

# Thesaurus
thes() {
  sdcv --data-dir ~/.stardict/thesaurus -u "Moby Thesaurus II" $@ | less
} 

timer() {
  reset
  hide_cursor
  date1=`date +%s`; 
  while true; do 
    echo -ne "\033[2K"; printf "\r"
    echo -ne "$(date -u --date @$((`date +%s` - $date1)) +%H:%M:%S)"; 
    sleep 0.1
  done
  show_cursor 
}

man() {
    LESS_TERMCAP_md=$'\e[34m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[32m' \
    command man "$@"
}

countdown() {
  reset
  hide_cursor
  cmd="clear && echo '$1 Done'"
  while getopts ":m:" opt; do
    case $opt in
      m)
        cmd="vlc ${HOME}/Music/Boredoms/Pop\ Tatari/boredoms\ -\ 03\ -\ hey\ bore\ hey.mp3"
        shift
        ;;
    esac
  done
  IFS=: read -r m s <<<$1
  date1=$((`date +%s` + m * 60 + s)); 
  while [ "$date1" -ne `date +%s` ]; do 
    echo -ne "\033[2K"; printf "\r"
    echo -ne "$(date -u --date @$(($date1 - `date +%s`)) +%M:%S)";
    sleep 1
  done
  eval $cmd
  show_cursor 
}

################################################
## Apps that integrate with the cli

## Rbenv
# eval "$(rbenv init -)"

# Ranger can be used to choose directories.
source /usr/share/doc/ranger/examples/bash_automatic_cd.sh

# Fasd
eval "$(fasd --init auto)"

fasd_cache="$HOME/.fasd-init-bash"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  fasd --init posix-alias bash-hook bash-ccomp bash-ccomp-install >| "$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache


#path to your oh-my-zsh configuration.
ZSH=/usr/share/oh-my-zsh/

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="af-magic"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git vagrant vi-mode cp dircycle git-extras systemd knife gem)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

autoload bashcompinit
bashcompinit

autoload -U compinit && compinit

setopt AUTO_CD
setopt CORRECT_ALL
setopt EXTENDED_GLOB
# History
SAVEHIST=10000
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt NO_HIST_BEEP
setopt SHARE_HISTORY

#################################################
# Set some keybindings.
###############################################
typeset -g -A key
bindkey '^?' backward-delete-char
bindkey '^[[7~' beginning-of-line
bindkey '^[[5~' up-line-or-history
bindkey '^[[3~' delete-char
bindkey '^[[8~' end-of-line
bindkey '^[[6~' down-line-or-history
bindkey '^[[A' up-line-or-search
bindkey '^[[D' backward-char
bindkey '^[[B' down-line-or-search
bindkey '^[[C' forward-char 
bindkey '^[[2~' overwrite-mode
bindkey $terminfo[kri] history-beginning-search-forward #shift up-key 
bindkey $terminfo[kind] history-beginning-search-backward #shift down-key  
#################################################

#################################################
# Set some aliases.
#################################################
alias e='exit'
alias .='cd .'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
alias ........='cd ../../../../../../..'
alias .........='cd ../../../../../../../..'
alias xp='xprop | grep "WM_WINDOW_ROLE\|WM_CLASS" && echo "WM_CLASS(STRING) = \"NAME\", \"CLASS\""'
alias ping='ping -c 3'
alias feh='feh --auto-zoom --geometry 500x375 --sort filename'
alias ll='ls -lh'                           # list detailed with human-readable sizes
alias la='ls -a'                            # list all files
alias lla='ls -lha'                         # list all detailed with human-readable sizes
alias lsd="ls /dev | grep sd; cd /dev"
alias cp="cp -i"                            # confirm before overwriting something
alias rm="rm -i"                            # confirm before overwriting something
alias mv="mv -i"                            # confirm before overwriting something
alias r='ranger'
alias rc='ranger-cd'
alias tmux="TERM=screen-256color tmux"
alias ga='git add'
alias gb='git branch'
alias gc='git commit -m'
alias go='git checkout'
alias gs='git status'
alias gr='git remote -v'
alias gra='git remote add'
alias grr='git remote rm'
alias gro='git remote add origin'
alias gp='git push'
alias gpu='git push --set-upstream origin master'
alias gu='git pull'
alias gl='git log'

#################################################

PATH="${PATH}:/root/.gem/ruby/2.0.0/bin"
PATH="${PATH}:/home/raf/.gem/ruby/2.0.0/bin"
PATH="${PATH}:/opt/vagrant/bin"
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
#TERM="urxvt"
#TERMCMD="urxvtr"
source /opt/bitnami/use_drupal
source /usr/share/doc/ranger/examples/bash_automatic_cd.sh

insert_sudo () { zle beginning-of-line; zle -U "sudo " }
zle -N insert-sudo insert_sudo
bindkey '<ctrl-s>' insert-sudo

export EDITOR="vim"
export BROWSER="google-chrome"
export CORRECT_IGNORE=".git"
export CORRECT_IGNORE=".*"


# added by travis gem
[ ! -s /home/raf/.travis/travis.sh ] || source /home/raf/.travis/travis.sh

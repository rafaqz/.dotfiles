
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

################################################
# Paths

export PATH="$HOME/bin:$PATH"
export PATH="${PATH}:/opt/vagrant/bin"
export PATH="${PATH}:/home/raf/.gem/ruby/2.1.0/bin/"
export PATH="/opt/bitnami/apps/drupal/drush:/opt/bitnami/sqlite/bin:/opt/bitnami/php/bin:/opt/bitnami/mysql/bin:/opt/bitnami/apache2/bin:/opt/bitnami/common/bin:$PATH"

# Variables
export EDITOR="vim"
export BROWSER="google-chrome"

# Rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

################################################
# Bash setup

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind "TAB:menu-complete"
bind "set show-all-if-ambiguous on"
shopt -s autocd
shopt -s globstar # For recursive globbing with **/* etc
# shopt -s expand_aliases
source /usr/share/doc/ranger/examples/bash_automatic_cd.sh
# Use vi mode
# set -o vi

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

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
# if [ -f /etc/bash_completion ]; then
#   . /etc/bash_completion
# fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  eval "`dircolors -b`"
  alias ls='ls --color=auto'
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
  alias pgrep='pgrep --color=auto'
fi


################################################
## Prompt
source /usr/share/git/completion/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWCOLORHINTS=
GIT_PS1_DESCRIBE_STYLE="branch"
GIT_PS1_SHOWUPSTREAM="auto git"
prompt='__git_ps1 "\[\e[40;31m\]\u@\[\e[1;32m\]\h:\[\e[30;44m\] \w \[\e[41m\]" "\\\$\[\e[0m\] "'
# Don't overwrite, append - autojump uses this 
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ;} history -a;history -c;history -r; $prompt"

shopt -s histappend

################################################
# Aliases

# Dot cd
alias back='cd $OLDPWD'
alias .='cd .'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
alias ........='cd ../../../../../../..'
alias .........='cd ../../../../../../../..'

## Shortcuts 
alias r='ranger'
alias rc='ranger-cd'
alias u='urxvtr'
alias v='vim'
alias k='rake'
alias vs='vim-server'
alias g='git'
alias p='grep -lr --exclude{tags,*.log*,*sprockets*}'
alias ga='git add'
alias gb='git branch'
alias gm='git merge'
alias gd='git diff'
alias gc='git commit'
alias go='git checkout'
alias gs='git status'
alias gp='git push'
alias gpu='git push --set-upstream origin master'
alias gu='git pull'
alias gl='git log --show-linear-break'
alias gls='git log --show-linear-break --stat'
alias glo='git log --oneline --graph'
alias gsa='git submodule add'
alias gr='git remote -v'
alias gra='git remote add'
alias grr='git remote rm'
alias gro='git remote add origin'
alias hc='hub create'
alias d='drush'
alias rv='ruby -e "print RUBY_VERSION"'
alias pu='pushd'
alias po='popd'

alias z='zeus start'
alias zr='zeus rake'
alias zu='zeus runner'
alias zc='zeus console'
alias zs='zeus server'
alias zg='zeus generate'
alias zd='zeus dbconsole'
alias zt='zeus test'

## Modified commands
alias diff='colordiff'              # requires colordiff package
alias more='less'
alias df='df -h'
alias du='du -c -h'
alias mkdir='mkdir -p -v'
alias ping='ping -c 5'
alias dmesg='dmesg -HL'
alias feh='feh --auto-zoom --geometry 500x375 --sort filename'
alias tmux="TERM=screen-256color tmux"
alias cp="cp -i"                            # confirm before overwriting something
alias rm="rm -i"                            # confirm before overwriting something
alias mv="mv -i"                            # confirm before overwriting something

## New commands
alias da='date "+%A, %B %d, %Y [%T]"'
alias du1='du --max-depth=1'
alias du2='du --max-depth=2'
alias hist='history | grep'         # requires an argument
alias openports='ss --all --numeric --processes --ipv4 --ipv6'
alias pgg='ps -Af | grep'           # requires an argument
alias xp='xprop | grep "WM_WINDOW_ROLE\|WM_CLASS" && echo "WM_CLASS(STRING) = \"NAME\", \"CLASS\""'
alias n="note"

## ls 
alias ll='ls -lh'                           # list detailed with human-readable sizes
alias la='ls -a'                            # list all files
alias lla='ls -lha'                         # list all detailed with human-readable sizes
alias lsd="ls /dev | grep sd"
alias lr='ls -R'                    # recursive ls
alias lx='ll -BX'                   # sort by extension
alias lz='ll -rS'                   # sort by size
alias lt='ll -rt'                   # sort by date
alias lm='la | more'

## Make Bash error tolerant 
alias :q=' exit'
alias :x=' exit'
alias q=' exit'
alias x=' exit'


################################################
# Handy functions

## cd and ls in one
cl() {
  dir=$1
  if [[ -z "$dir" ]]; then
    dir=$HOME
  fi
  if [[ -d "$dir" ]]; then
    cd "$dir"
    ls
  else
    echo "bash: cl: '$dir': Directory not found"
  fi
}

note() {
  # if file doesn't exist, create it
  if [[ ! -f $HOME/.notes ]]; then
    touch "$HOME/.notes"
  fi

  if ! (($#)); then
    # no arguments, print file
    cat "$HOME/.notes"
  elif [[ "$1" == "-c" ]]; then
    # clear file
    > "$HOME/.notes"
  else
    # add all arguments to file
    printf "%s\n" "$*" >> "$HOME/.notes"
  fi
}

todo() {
  if [[ ! -f $HOME/.todo ]]; then
    touch "$HOME/.todo"
  fi

  if ! (($#)); then
    cat "$HOME/.todo"
  elif [[ "$1" == "-l" ]]; then
    nl -b a "$HOME/.todo"
  elif [[ "$1" == "-c" ]]; then
    > $HOME/.todo
  elif [[ "$1" == "-r" ]]; then
    nl -b a "$HOME/.todo"
    eval printf %.0s- '{1..'"${COLUMNS:-$(tput cols)}"\}; echo
    read -p "Type a number to remove: " number
    sed -i ${number}d $HOME/.todo "$HOME/.todo"
  else
    printf "%s\n" "$*" >> "$HOME/.todo"
  fi
}

# Arch latest news
function news() {
  if [ "$PS1" ] && [[ $(ping -c1 www.google.com 2>&-) ]]; then
    # The characters "£, §" are used as metacharacters. They should not be encountered in a feed...
    echo -e "$(echo $(curl --silent https://www.archlinux.org/feeds/news/ | sed -e ':a;N;$!ba;s/\n/ /g') | \
    sed -e 's/&amp;/\&/g
    s/&lt;\|&#60;/</g
    s/&gt;\|&#62;/>/g
    s/<\/a>/£/g
    s/href\=\"/§/g
    s/<title>/\\n\\n\\n   :: \\e[01;31m/g; s/<\/title>/\\e[00m ::\\n/g
    s/<link>/ [ \\e[01;36m/g; s/<\/link>/\\e[00m ]/g
    s/<description>/\\n\\n\\e[00;37m/g; s/<\/description>/\\e[00m\\n\\n/g
    s/<p\( [^>]*\)\?>\|<br\s*\/\?>/\n/g
    s/<b\( [^>]*\)\?>\|<strong\( [^>]*\)\?>/\\e[01;30m/g; s/<\/b>\|<\/strong>/\\e[00;37m/g
    s/<i\( [^>]*\)\?>\|<em\( [^>]*\)\?>/\\e[41;37m/g; s/<\/i>\|<\/em>/\\e[00;37m/g
    s/<u\( [^>]*\)\?>/\\e[4;37m/g; s/<\/u>/\\e[00;37m/g
    s/<code\( [^>]*\)\?>/\\e[00m/g; s/<\/code>/\\e[00;37m/g
    s/<a[^§|t]*§\([^\"]*\)\"[^>]*>\([^£]*\)[^£]*£/\\e[01;31m\2\\e[00;37m \\e[01;34m[\\e[00;37m \\e[04m\1\\e[00;37m\\e[01;34m ]\\e[00;37m/g
    s/<li\( [^>]*\)\?>/\n \\e[01;34m*\\e[00;37m /g
    s/<!\[CDATA\[\|\]\]>//g
    s/\|>\s*<//g
    s/ *<[^>]\+> */ /g
    s/[<>£§]//g')\n\n";
  fi
}

# Autojump into ranger, ls, vim or urxvtr
jr() { j "$@"; r;}
jl() { j "$@"; ls;}
jll() { j "$@"; ll;}
jlla() { j "$@"; lla;}
jla() { j "$@"; la;}
jv() { j "$@"; v;}
jvs() { j "$@"; vs;}
ju() { j "$@"; u;}


####################################
# Git alias completion
__git_shortcut () {
  # Because cherry-pick has the function _git_cherry_pick
  n2=${2//-/_}
  type _git_${n2}_shortcut &>/dev/null || make-completion-wrapper _git_$n2 _git_${n2}_shortcut $1 git $2
  complete -o bashdefault -o default -o nospace -F _git_${n2}_shortcut $1
}

__apt_cache_shortcut () {
  type _apt_cache_$2_shortcut &>/dev/null || make-completion-wrapper _apt_cache _apt_cache_$2_shortcut $1 apt-cache $2
  # is not executed automatically. Normally only on first apt-cache <tab>
  [ ! -f /usr/share/bash-completion/completions/apt-cache ] || source /usr/share/bash-completion/completions/apt-cache
  complete -F _apt_cache_$2_shortcut $1
}

#make-completion-wrapper _git_checkout _git_checkout_shortcut go git checkout
function make-completion-wrapper () {
	local comp_function_name="$1"
	local function_name="$2"
	local alias_name="$3"
	local arg_count=$(($#-4))
	shift 3
	local args="$*"
	local function="
function $function_name {
	COMP_LINE=\"$@\${COMP_LINE#$alias_name}\"
	let COMP_POINT+=$((${#args}-${#alias_name}))
	((COMP_CWORD+=$arg_count))
	COMP_WORDS=("$@" \"\${COMP_WORDS[@]:1}\")
 
	local cur words cword prev
	_get_comp_words_by_ref -n =: cur words cword prev
	"$comp_function_name"
	return 0
}"
	eval "$function"
}

source /usr/share/git/completion/git-completion.bash
__git_shortcut  ga   add
__git_shortcut  gf   fetch
__git_shortcut  gu   pull
__git_shortcut  gp   push
__git_shortcut  gm   merge
__git_shortcut  gd   diff
__git_shortcut  gb   branch
__git_shortcut  gc   commit
__git_shortcut  go   checkout
__git_shortcut  gcp  cherry-pick
__git_shortcut  gl   log


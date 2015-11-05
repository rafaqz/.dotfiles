
# If not running interactively, don't do anything
[ -z "$PS1" ] && return


################################################
## Paths

PATH="$HOME/bin:$PATH"
PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/.rbenv/bin:$PATH"
# PATH="$HOME/.stack/programs/x86_64-linux/ghc-7.8.4/bin:$PATH"
PATH="$HOME/.cabal/bin:$PATH"
PATH="${PATH}:$HOME/.gem/ruby/2.2.0/bin"
PATH="${PATH}:/opt/vagrant/bin"
export PATH

################################################
## Variables
export EDITOR="vim"
export BROWSER="firefox"

# export LANG=en_AU.UTF-8
# export LC_ALL=en_AU.UTF-8
# export LC_MESSAGES="C"

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
prompt='__git_ps1 "\[\e[40;31m\]@\u\[\e[39;40m\] \w \[\e[30;43m\]" "\\\$\[\e[0m\] "'
# Don't overwrite, append - autojump uses this 
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ;} history -a;history -c;history -r; $prompt"

################################################
# Color 
if [ -x /usr/bin/dircolors ]; then
  eval "`dircolors ~/.dircolors`"
  alias ls='ls --color=auto'
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
  alias pgrep='pgrep --color=auto'
fi

################################################
## Aliases

## Dot cd
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
alias vim='vim -p --servername `openssl rand -hex 12`'
alias v='vim'
alias rc='ranger-cd'
alias u='urxvtr'
alias mu='mupdf'
alias g='git'
alias p='grep -lr --exclude{tags,*.log*,*sprockets*}'
alias ga='git add'
alias gb='git branch'
alias gm='git merge'
alias gd='git diff'
alias gi='git init'
alias gc='git commit'
alias gcl='git clone'
alias go='git checkout'
alias gst='git status'
alias gp='git push'
alias gpu='git push --set-upstream origin master'
alias gu='git pull'
alias gl='git log --show-linear-break'
alias gld='git log -p --show-linear-break'
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
alias be='bundle exec'
alias bi='bundle install'

alias z='zeus'
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
# alias rm="rm -i"                            # confirm before overwriting something
alias mv="mv -i"                            # confirm before overwriting something
alias reset="echo -ne '\033c'"

## New commands
alias da='date "+%A, %B %d, %Y [%T]"'
alias du1='du --max-depth=1'
alias du2='du --max-depth=2'
alias h='history | grep'         # requires an argument
alias openports='ss --all --numeric --processes --ipv4 --ipv6'
alias pgg='ps -Af | grep'           # requires an argument
alias xp='xprop | grep "WM_WINDOW_ROLE\|WM_CLASS" && echo "WM_CLASS(STRING) = \"NAME\", \"CLASS\""'

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

alias t='todotxt-machine'
alias l='reset'

## Make Bash error tolerant 
alias :q=' exit'
alias :x=' exit'
alias q=' exit'
alias x=' exit'

#pacman
alias pe='expac -HM "%011m\t%-20n\t%10d" $( comm -23 <(pacman -Qqen|sort) <(pacman -Qqg base base-devel|sort) ) | sort -n'

################################################
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

# Arch latest news. nice to have when something breaks after an update.
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

# Opens a note
n() {
 vim -c ":Pad new $*" 
}

# Searches Notes
nls() {
 ls -cD ~/Documents/Notes/ | egrep -i "$*"
}


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

function ap() {
  google-chrome --new-window --app=$1
}

function countdown(){
   date1=$((`date +%s` + $1)); 
   while [ "$date1" -ne `date +%s` ]; do 
     echo -ne "$(date -u --date @$(($date1 - `date +%s`)) +%H:%M:%S)\r";
     sleep 0.1
   done
}
function stopwatch(){
  date1=`date +%s`; 
   while true; do 
    echo -ne "$(date -u --date @$((`date +%s` - $date1)) +%H:%M:%S)\r"; 
    sleep 0.1
   done
}

source /usr/share/git/completion/git-completion.bash
__git_shortcut  ga   add
__git_shortcut  gf   fetch
__git_shortcut  gu   pull
__git_shortcut  gr   remote
__git_shortcut  gp   push
__git_shortcut  gm   merge
__git_shortcut  gd   diff
__git_shortcut  gb   branch
__git_shortcut  gc   commit
__git_shortcut  go   checkout
__git_shortcut  gcp  cherry-pick
__git_shortcut  gl   log


################################################
## Apps that integrate with the cli

## Rbenv
eval "$(rbenv init -)"

## Keychain
eval $(keychain --eval --agents ssh -Q --quiet id_ecdsa)

# Ranger can be used to choose directories. Nice inside vim...
source /usr/share/doc/ranger/examples/bash_automatic_cd.sh

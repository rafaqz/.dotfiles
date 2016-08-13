#!/bin/sh 
# Shared environment variables

################################################
## Paths

PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/.rbenv/bin:$PATH"
PATH="$HOME/.cabal/bin:$PATH"
PATH="$HOME/bin:$PATH"
# PATH="${PATH}:$HOME/.gem/ruby/2.2.0/bin"
# PATH="${PATH}:/opt/vagrant/bin"
export PATH

################################################
## Variables
export SHELL="/bin/bash"
export EDITOR="vim -p --servername `openssl rand -hex 12`"
export TERMINAL="urxvtr"
# gtk2 files for qt
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"


if [ -n "$DISPLAY" ]; then
  export BROWSER=firefox
else 
  export BROWSER=w3m
fi

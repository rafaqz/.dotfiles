#!/bin/sh 
# Shared environment variables

################################################
## Paths

PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/.rbenv/bin:$PATH"
# PATH="$HOME/.cabal/bin:$PATH"
PATH="$HOME/bin:$PATH"
PATH="/opt/zotero/Zotero_linux-x86_64/:$PATH"
# PATH="${PATH}:$HOME/.gem/ruby/2.2.0/bin"
export PATH

################################################
## Variables
export SHELL="/bin/bash"
export EDITOR="vim"
export TERMINAL="urxvtr"
# gtk2 files for qt
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

if [ -n "$DISPLAY" ]; then
  export BROWSER=firefox
else 
  export BROWSER=w3m
fi

# Keychain
eval $(keychain --eval --agents ssh -Q --quiet id_rsa)

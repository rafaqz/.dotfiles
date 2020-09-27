#!/bin/sh 
# Shared environment variables

################################################
## Paths

PATH="$HOME/.local/bin:$PATH"
# PATH="$HOME/.rbenv/bin:$PATH"
# PATH="${PATH}:$HOME/.gem/ruby/2.2.0/bin"
PATH="$HOME/.cabal/bin:$PATH"
PATH="$HOME/bin:$PATH"
PATH="$HOME/.node_modules/bin:$PATH"
PATH="/opt/julia/bin:$PATH"
# PATH="$HOME/Uni/Masters/code/julia/:$PATH"
export PATH
export QT_PLUGIN_PATH=/usr/lib/kde4/plugins/
export QT_QPA_PLATFORMTHEME=qt5ct
export CMDSTAN_HOME=/usr/bin/stanc
export R_HISTFILE=~/.Rhistory

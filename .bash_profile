[[ -r ~/.profile ]] && . ~/.profile 
[[ -r ~/.bashrc ]] && . ~/.bashrc 
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx >>~/.xsession-errors 2>&1

# Keychain
eval $(keychain --eval --agents ssh -Q --quiet id_rsa)

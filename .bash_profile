source $HOME/.bashrc
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
# Keychain
eval $(keychain --eval --agents ssh -Q --quiet id_rsa)

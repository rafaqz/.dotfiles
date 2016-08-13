source $HOME/.profile
source $HOME/.bashrc
systemctl --user import-environment PATH
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
# Keychain
eval $(keychain --eval --agents ssh -Q --quiet id_rsa)

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
VIM=/usr/bin/vim
VIMRUNTIME=/home/raf/.vim_runtime/
EDITOR=$VIM
#eval $(keychain --eval --agents ssh -Q --quiet id_ecdsa)

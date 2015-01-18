#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# bind media keys, touchpad disable etc. See .xbindkeysrc file
xbindkeys

# remap capslock and escape keys etc. See .Xmodmap
xmodmap ~/.Xmodmap

# gtk2 files for qt
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

# source .xprofile for autostarting applications
[ -f /etc/xprofile ] && source /etc/xprofile
[ -f ~/.xprofile ] && source ~/.xprofile

exec awesome >> ~/.cache/awesome/stdout 2>> ~/.cache/awesome/stderr
# exec gnome-session
# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice

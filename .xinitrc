#!/bin/sh 
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

################################################################################
# Setup

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# Merge Xresources
[[ -f ~/.Xresources ]] && xrdb -merge -I "$HOME/.Xresources"

################################################################################
# Input 

# Keyboard repeat speed
xset r rate 180 60  &
# Use pointer as cursor (for xmonad)
xsetroot -cursor_name left_ptr &
# Remap capslock and escape keys etc. See .Xmodmap
xmodmap $HOME/.Xmodmap &
# Key commands. See sxhkdrc
sxhkd &

# Disable trackpad while typing. 2 seconds 
# -i 2 sets the idle time to 2 seconds. The idle time specifies how many seconds to 
#  wait after the last key-press before enabling the touchpad again.
# -t tells the daemon not to disable mouse movement when typing and only disable tapping and scrolling.
# -k tells the daemon to ignore modifier keys when monitoring keyboard activity (e.g.: allows Ctrl+Left Click).
# -d starts as a daemon, in the background.
syndaemon -t -k -i 2 -d &

################################################################################
# Bling

compton -f -D 3 -o 0 -m 0.92 & 
background &

# Notifications
dunst -print > /tmp/dunst_recent &

# Tray
stalonetray &
redshift-gtk &
nm-applet &
indicator-kdeconnect &
clipit &
cbatticon &

################################################################################
# WM
exec xmonad

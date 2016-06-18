#!/bin/sh 
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

source $HOME/.environment

# Session
lxsession &

# Remap capslock and escape keys etc. See .Xmodmap
xmodmap ~/.Xmodmap &

# Use pointer as cursor (for xmonad)
xsetroot -cursor_name left_ptr &

# Disable trackpad while typing. 2 seconds 
# -i 2 sets the idle time to 2 seconds. The idle time specifies how many seconds to 
#  wait after the last key-press before enabling the touchpad again.
# -t tells the daemon not to disable mouse movement when typing and only disable tapping and scrolling.
# -k tells the daemon to ignore modifier keys when monitoring keyboard activity (e.g.: allows Ctrl+Left Click).
# -d starts as a daemon, in the background.
syndaemon -t -k -i 2 -d &

# Merge Xresources
[[ -f ~/.Xresources ]] && xrdb -merge -I "$HOME/.Xresources"

# Compositing
hsetroot &
compton -f -D 2 -o 0 & 

# Battery monitor
slimebattery --change-icon &
# Auto mount drives
pcmanfm -d &
# Key commands
sxhkd &
# Notifications
dunst &
# Keyboard repeat speed
xset r rate 180 60  &
# Batterly low notification.
pwrnotify 6 &

# case $WM in
# awesome)
#   exec awesome >> ~/.cache/awesome/stdout 2>> ~/.cache/awesome/stderr 
# 	;;
# xmonad)
#   exec xmonad
# 	;;
# esac
exec xmonad

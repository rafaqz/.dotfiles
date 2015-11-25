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

# Session
lxsession &

# Key bindings
# sxhkd

# Remap capslock and escape keys etc. See .Xmodmap
xmodmap ~/.Xmodmap

# Use pointer as cursor (for xmonad)
xsetroot -cursor_name left_ptr

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
hsetroot
compton -f -D 3 & 

# gtk2 files for qt
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

# Battery monitor
slimebattery &
# Clipboard
runonce clipit &
# Auto mount drives
pcmanfm -d &
# Key commands
sxhkd &

# case $WM in
# awesome)
#   exec awesome >> ~/.cache/awesome/stdout 2>> ~/.cache/awesome/stderr 
# 	;;
# xmonad)
#   exec xmonad
# 	;;
# esac
exec xmonad

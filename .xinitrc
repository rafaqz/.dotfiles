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
# No beeps
xset -b
# Use pointer as cursor (for xmonad)
xsetroot -cursor_name left_ptr &
# Swap capslock and escape keys, menu as super
# setxkbmap -option caps:swapescape -option
xmodmap $HOME/.Xmodmap &
# Key commands. See sxhkdrc
sxhkd &
syndaemon -i 1 -d -t -K

################################################################################
# Bling
compton -f -D 3 -o 0 -m 0.92 &
background &

# Notifications
#dunst -print > /tmp/dunst_recent &

# Tray
stalonetray &
redshift-gtk -l -37.8:145.0 -t 5700:3600 -g 0.8 -m randr -v &
nm-applet &
clipit &
cbatticon &
pcmanfm -d &
kdeconnect-indicator &
blueman-applet &


################################################################################
# WM
exec xmonad

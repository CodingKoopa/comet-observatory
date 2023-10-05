#!/bin/sh

bar &
dunst &
db="$HOME/Documents/Passwords & 2FA/Passwords.kdbx"
keepassxc --pw-stdin "$db" <"$db".pw &
fcitx5 &
_discord &
workrave &
firefox &
if [ "$CO_HOST" = "DESKTOP" ]; then
        steam-runtime -silent &
fi
nm-applet &

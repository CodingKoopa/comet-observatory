#!/bin/bash

# Copyright 2019 Comet Observatory
# Licensed under GPLv3.
# Refer to License.txt file included.

# Source system xinitrc scripts.
if [[ -d /etc/X11/xinit/xinitrc.d ]]; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
    # shellcheck disable=1090
    [[ -x "$f" ]] && . "$f"
  done
  unset f
fi

if [[ $CO_HOST = "DESKTOP" ]]; then
  # Configure Xorg automatically.
  nvidia-settings --load-config-only
fi

# Though I really try to use Xorg configuration files wherever possible, I just could not make it
# work here. I faithfully made an equivalent configuration, and also had systemd-localed confirm
# that I am doing it right, but it simply would not take effect. [1]
#
# I also tried pre-compiling the XKB keymap by using `setxkbmap … -print > xorg.xkb`, and loading
# it here using `xkbcomp xorg.xkb "$DISPLAY"`. But, no matter *how* late in this file I do it, that
# also does not work. If I run it from Konsole after starting dwm, though, then it works just fine.
# In either case, it produces some errors that don't seem to be relevant.
#
# So, we have this: running setxkbmap every time. On the bright side, this is a different beast than
# running `xrandr` at launch: there is no mode setting or anything. Just compiling the keymap and
# applying it to the X server.
#
# [1] https://gist.github.com/CodingKoopa/60464ae2ed13b434c8b6cdfa909e811f

# Set environment variables for graphical programs. Applcations started from dwm inherit its
# environment, so this must be done prior to launching it. Non-graphical environment variables are
# set earlier; see docs/Init.md.
# shellcheck source=scripts/bash/user_graphical_rc.sh
source "$CO"/scripts/bash/user_graphical_rc.sh

# Enable job control. We need this, but it's disabled here because this is a login shell.
set -m

#exec startplasma-x11

first_time=true
while true; do
  dwm &
  if [[ $first_time = true ]]; then
    # shellcheck source=scripts/bash/user_graphical_post_rc.sh
    source "$CO"/scripts/bash/user_graphical_post_rc.sh
    first_time=false
  fi
  setxkbmap \
    -layout "us,us" \
    -variant ",dvp" \
    -option "grp:alts_toggle,compose:lctrl,ctrl:nocaps" &
  fg "$(jobs |
    sed --quiet --regexp-extended "s/^\[([[:digit:]]+)\].+\bdwm\b.+$/\1/p" | head --lines=1)"
done

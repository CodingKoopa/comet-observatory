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

# Set environment variables for graphical programs. Applcations started from dwm inherit its
# environment, so this must be done prior to launching it. Non-graphical environment variables are
# set earlier; see docs/Init.md.
# shellcheck source=scripts/bash/user_graphical_rc.sh
source "$CO"/scripts/bash/user_graphical_rc.sh

# Enable job control. We need this, but it's disabled here because this is a login shell.
set -m

first_time=true
while true; do
  dwm &
  if [[ $first_time = true ]]; then
    # shellcheck source=scripts/bash/user_graphical_post_rc.sh
    source "$CO"/scripts/bash/user_graphical_post_rc.sh
    first_time=false
  fi
  fg "$(jobs |
    sed --quiet --regexp-extended "s/^\[([[:digit:]]+)\].+\bdwm\b.+$/\1/p" | head --lines=1)"
done

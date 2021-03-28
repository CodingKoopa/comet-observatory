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

# shellcheck source=scripts/bash/user_graphical_rc.sh
source "$CO"/scripts/bash/user_graphical_rc.sh

# Start KDE Plasma.
exec startplasma-x11

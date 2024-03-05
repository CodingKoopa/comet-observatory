#!/bin/bash

# Copyright 2019 Comet Observatory
# Licensed under GPLv3.
# Refer to License.txt file included.

# shellcheck source=scripts/bash/co_rc.sh
source /opt/co/scripts/bash/co_rc.sh

# shellcheck source=scripts/bash/user_rc.sh
source "$CO"/scripts/bash/user_rc.sh

# If the systemd graphical target unit is active, the display isn't setup, and the first virtual
# console is active, start X. See /docs/Init.md.
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx -- vt1 &>"$HOME"/.local/share/xorg/startx.log
else
  # shellcheck source=scripts/bash/bash_rc.sh
  source "$CO"/scripts/bash/bash_rc.sh l
fi

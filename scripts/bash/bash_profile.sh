#!/bin/bash

# Copyright 2019 Comet Observatory
# Licensed under GPLv3.
# Refer to License.txt file included.

export CO=$HOME/Documents/Projects/Bash/comet-observatory
# shellcheck source=scripts/bash/user_rc.sh
source "$CO"/scripts/bash/user_rc.sh

# shellcheck source=scripts/bash/bash_rc.sh
"$CO"/scripts/bash/bash_rc.sh

# If the systemd graphical target unit is active, the display isn't setup, and the first virtual
# console is active, start X. See /docs/Init.md.
if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx -- vt1 &>/dev/null
fi

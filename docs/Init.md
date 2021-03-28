# Initialization
This document details how the user portion of the booting process works, particularly focusing in on environment variables. The process of booting up and starting Plasma goes about as follows:
- Systemd starts the Getty service on VTY 1.
- Getty logs us in, using its [configuration](/config/systemd-overrides/getty-autologin.conf).
- Bash runs the [Bash profile](/scripts/bash/bash_profile.sh), which starts X if the conditions are right.
  - If the conditions aren't right, then we opt to treat this as a normal terminal, and run the [Bash RC file](/scripts/bash/bash_rc.sh).
- The Bash profile runs the [user RC script](/scripts/bash/user_rc.sh) which sets environmental variables used by all user programs.
  - This sets `$CO`. The libraries in `scripts` may assume that this variable is set at all times, either by this environment variable, or by a `/bin` script, for scripts ran by root.
- X runs the [X RC file](/scripts/x/x_rc.sh), which runs the [user graphical RC script](/scripts/bash/user_graphical_rc.sh) and starts KDE Plasma.

Further reading:
- https://wiki.archlinux.org/index.php/Arch_boot_process
- https://wiki.archlinux.org/index.php/Getty#Automatic_login_to_virtual_console
- https://wiki.archlinux.org/index.php/Environment_variables#Per_user
- https://wiki.archlinux.org/index.php/Systemd/User#Environment_variables

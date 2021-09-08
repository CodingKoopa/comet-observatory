# Initialization
This document details how the user portion of the booting process works, particularly focusing in on environment variables. The process of booting up and starting Plasma goes about as follows:
- Systemd starts the Getty service on VTY 1.
- Getty logs us in, using its [configuration](/config/systemd-overrides/getty-autologin.conf).
- Bash runs the [Bash profile](/scripts/bash/bash_profile.sh).
- The Bash profile runs the [Comet Observatory RC script](/scripts/bash/co_rc.sh) which sets environmental variables that are used internally.
- The Bash profile runs the [user RC script](/scripts/bash/user_rc.sh) which sets environmental variables used by all user programs.
- If the conditions are right, the Bash profile runs X.
  - X runs the [X RC script](/scripts/x/x_rc.sh).
  - The X RC script runs the [user graphical RC script](/scripts/bash/user_graphical_rc.sh).
  - The X RC script starts KDE Plasma.
- If the conditions aren't right, then we opt to treat this as a normal terminal, and run the [Bash RC file](/scripts/bash/bash_rc.sh).

Further reading:
- https://wiki.archlinux.org/index.php/Arch_boot_process
- https://wiki.archlinux.org/index.php/Getty#Automatic_login_to_virtual_console
- https://wiki.archlinux.org/index.php/Environment_variables#Per_user
- https://wiki.archlinux.org/index.php/Systemd/User#Environment_variables

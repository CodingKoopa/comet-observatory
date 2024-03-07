#!/bin/bash

# Copyright 2019 Comet Observatory
# Licensed under GPLv3.
# Refer to License.txt file included.

# This file does things that can harm the system if done incorrectly, so exit upon error.
set -e

# shellcheck source=scripts/bash/common.sh
source "$CO"/scripts/bash/common.sh
# shellcheck source=scripts/bash/file_utils.sh
source "$CO"/scripts/bash/file_utils.sh
# shellcheck source=scripts/bash/setup_system_utils.sh
source "$CO"/scripts/bash/setup_system_utils.sh
# shellcheck source=scripts/bash/setup_user_utils.sh
source "$CO"/scripts/bash/setup_user_utils.sh
# shellcheck source=scripts/makepkg/repos.sh
source "$CO"/scripts/makepkg/repos.sh
# shellcheck source=scripts/code/extensions.sh
source "$CO"/scripts/code/extensions.sh

# Exports certain constant variables.
# Globals Exported:
#   - INSTALL_HOME: Location of the home directory of the current install user.
#   - CO: Location of this Comet Observatory repository.
#   - GNUPGHOME: Location of the GnuPG home directory of the current install user. Keep this in sync
# with user_rc.sh.
#   - SSH_DIR: Location of the SSH home directory of the current install user.
#   - PACMAN_ARGS: List of Pacman arguments useful for scripts.
# Arguments:
#   - The user that is being installed for, and owns the Comet Observatory.
function export_constants() {
  INSTALL_HOME=$(eval echo "~$INSTALL_USER")
  export INSTALL_HOME

  export TERRACE_DOWNLOADS_DIR=$INSTALL_HOME/Terrace/Downloads
  export FOUNTAIN_DOCUMENTS_DIR=$INSTALL_HOME/Fountain/Documents
  export TERRACE_PICTURES_DIR=$INSTALL_HOME/Terrace/Pictures
  export TERRACE_VIDEOS_DIR=$INSTALL_HOME/Terrace/Videos
  export TERRACE_MUSIC_DIR=$INSTALL_HOME/Terrace/Music
  export GNUPGHOME=$INSTALL_HOME/.local/share/gnupg
  export SSH_DIR=$INSTALL_HOME/.ssh
  export AUR_DIR=$INSTALL_HOME/code/bash

  export PACMAN_ARGS=(--noconfirm --noprogressbar)
}

# Sets up the system components of the system.
# Globals Read:
#   - INSTALL_HOME: See export_constants().
#   - CO: See co_rc.sh.
#   - CO_HOST: See co_rc.sh.
#   - PACMAN_ARGS: See export_constants().
#   - SYNCED_GTK_DIR: See export_constants().
# Globals Exported:
#   - DRY_RUN: Whether to actually perform actions.
#   - INSTALL_USER: The user that is being installed for, and owns the Comet Observatory.
# Outputs:
#   - Installation progress.
# Returns:
#   - 1 if the user couldn't be found.
function setup_system() {
  print_header "System Setup"

  # Customize the setup.
  section "Initializing Setup"

  info "Configuring setup."
  # Dry runs should print messages when action is about to be taken, but must not execute the
  # actions. All functions called here should have dry run support implemented within the function,
  # for consistency.
  config_bool "Is this a dry run? (y/n)?" DRY_RUN "$1"
  config_str "What user owns the Comet Observatory?" INSTALL_USER "$2"
  if ! id "$INSTALL_USER" >/dev/null 2>&1; then
    error "User \"$INSTALL_USER\" doesn't exist."
    exit 1
  fi

  info "Checking permissions."
  check_user true

  info "Setting constants."
  export_constants

  # Package Management
  section "Setting Up Packages"

  # We reference the Chaotic-AUR mirrorlist in our pacman.conf, so we have to install the mirrorlist
  # package first, so that parsing pacman.conf doesn't result in an error.
  info "Configuring Chaotic-AUR"
  if [[ $DRY_RUN = false ]]; then
    if ! pacman-key --list-sigs | grep 3056513887B78AEB &>/dev/null; then
      pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
      pacman-key --lsign-key 3056513887B78AEB
    fi
    install_from_repo chaotic-keyring https://github.com/chaotic-aur/pkgbuild-chaotic-keyring
    install_from_repo chaotic-mirrorlist https://github.com/chaotic-aur/pkgbuild-chaotic-mirrorlist
  fi

  info "Configuring pacman."
  configure_pacman

  info "Installing pikaur."
  install_from_aur pikaur

  info "Syncing packages."
  if [[ $DRY_RUN = false ]]; then
    pacman -Syu "${PACMAN_ARGS[@]}"
  fi

  info "Installing packages."
  if [[ $DRY_RUN = false ]]; then
    # Initially run pikaur as the user, to utilize the pikaur cache in their home directory.
    comm -13 <(pacman -Qqe | sort) <(get_co_package_list) |
      sudo -u "$INSTALL_USER" xargs pikaur -S "${PACMAN_ARGS[@]}" --asexplicit
  fi

  # Kernel & Hardware
  section "Setting Up Kernel & Hardware"

  info "Configuring initial ramdisk."
  cp_for_host "$CO"/config/mkinitcpio.{desktop,p500}.conf /etc/mkinitcpio.conf

  info "Making initial ramdisks."
  if [[ $DRY_RUN = false ]]; then
    mkinitcpio -P || true
  fi

  info "Configuring kernel attributes."
  safe_cp "$CO"/config/sysctl.conf /etc/sysctl.d/99-sysctl.conf

  info "Configuring filesystems."
  cp_for_host "$CO"/config/fstab.{desktop,p500} /etc/fstab

  info "Creating swap memory."
  create_swap 8

  # System Services
  section "Setting Up System Services"

  info "Configuring system systemd services."
  configure_system_units

  info "Enabling system systemd services."
  enable_system_units

  info "Configuring udev."
  configure_udev_rules

  info "Configuring Xorg."
  configure_xorg

  info "Setting XDG user directories."
  cp "$CO"/config/user-dirs.root.dirs /root/.config/user-dirs.dirs

  info "Installing EFI boot entries."
  if [[ $DRY_RUN = false ]]; then
    update-efi
  fi

  # User Management
  section "Setting Up Users"

  # We do not create the main user here; that is done prior to invoking this script.

  info "Configuring sudo."
  configure_sudo

  info "Configuring Docker group."
  add_group docker

  info "Adding user to Docker group."
  add_user_group docker "$INSTALL_USER"

  info "Setup complete!"
}

# Sets up the user components of the system. Strictly only user commands that cannot be ran as
# root.
# Globals Read:
#   - INSTALL_HOME: See export_constants().
#   - CO: See co_rc.sh.
#   - SYNCED_GTK_DIR: See export_constants().
#   - ABS_DIR: See export_constants().
#   - GNUPGHOME: See export_constants().
#   - SSH_DIR: See export_constants().
# Globals Exported:
#   - DRY_RUN: See setup().
#   - INSTALL_USER: See setup().
#   - SYNCED_DOCUMENTS: Whether documents have been synced.
# Outputs:
#   - Installation progress messages.
# Returns:
#   - 1 if the user couldn't be found.
function setup_user() {
  print_header "User Setup"

  # Customize the setup.
  section "Initializing Setup"

  info "Configuring setup."
  # See above.
  config_bool "Is this a dry run? (y/n)?" DRY_RUN "$1"
  local -r INSTALL_USER=$(whoami)
  if ! id "$INSTALL_USER" >/dev/null 2>&1; then
    error "User \"$INSTALL_USER\" doesn't exist."
    exit 1
  fi
  config_bool "Have private documents been synced yet? (y/n)?" SYNCED_DOCUMENTS "$2"

  info "Checking permissions."
  check_user false

  info "Setting constants."
  export_constants

  # File Structure
  section "Setting Up File Structure"

  info "Setting XDG user directories."
  safe_cp "$CO"/config/user-dirs.dirs "$INSTALL_HOME"/.config/user-dirs.dirs

  info "Creating new directories."
  create_directories

  info "Linking directories."
  link_directories

  info "Adding link for deprecated mimeapps.list location."
  safe_ln "$INSTALL_HOME"/.config/mimeapps.list \
    "$INSTALL_HOME"/.local/share/applications/mimeapps.list

  # User Services
  section "Setting Up User Services"

  info "Configuring user systemd services."
  configure_user_units

  info "Enabling user systemd services."
  enable_user_units

  # User Programs
  section "Setting Up User Programs"

  info "Silencing login message."
  if [[ $DRY_RUN = false ]]; then
    touch "$INSTALL_HOME"/.hushlogin
  fi

  info "Configuring GPG."
  configure_gpg

  info "Installing dwm."
  install_local dwm

  info "Setting Up VSCode"
  install_vscode_extensions

  info "Setup complete!"
}

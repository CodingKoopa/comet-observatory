#!/bin/bash

# Copyright 2019 Comet Observatory
# Licensed under GPLv3.
# Refer to License.txt file included.

# shellcheck source=scripts/bash/common.sh
source "$CO"/scripts/bash/common.sh
# shellcheck source=scripts/bash/file_utils.sh
source "$CO"/scripts/bash/file_utils.sh

# Configures Pacman.
# Globals Read:
#   - DRY_RUN: See setup().
# Outputs:
#   - Key import feedback.
function configure_chaoticaur() {
  if [[ $DRY_RUN = false ]]; then
    local -r FINGERPRINT=3056513887B78AEB
    if ! pacman-key --list-sigs | grep $FINGERPRINT &>/dev/null; then
      info "Importing signing key."
      [[ $DRY_RUN = false ]] &&
        pacman-key --recv-key $FINGERPRINT --keyserver keyserver.ubuntu.com &&
        pacman-key --lsign-key $FINGERPRINT
    fi
    if ! pacman -Qi chaotic-{keyring,mirrorlist} &>/dev/null; then
      info "Installing keyring + mirrorlist."
      [[ $DRY_RUN = false ]] &&
        pacman -U \
          https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-{keyring,mirrorlist}.pkg.tar.zst
    fi
  fi
}

# Configures Pacman.
# Globals Read:
#   - DRY_RUN: See setup().
# Outputs:
#   - Copy feedback.
function configure_pacman() {
  safe_cp "$CO"/config/pacman.conf /etc/pacman.conf
  safe_cp "$CO"/config/makepkg.conf /etc/makepkg.conf
  safe_cp "$CO"/config/reflector.conf /etc/xdg/reflector/reflector.conf
}

# Configures systemwide systemd units.
# Globals Read:
#   - DRY_RUN: See setup().
# Outputs:
#   - Copy feedback.
function configure_system_units() {
  local -rA unit_overrides=(
    ["getty@tty1.service"]="getty-autologin.conf"
  )
  for unit in "${!unit_overrides[@]}"; do
    local destination=/etc/systemd/system/$unit.d/override.conf
    safe_cp "$CO"/config/systemd-overrides/"${unit_overrides[${unit}]}" "$destination"
    if [[ $DRY_RUN = false ]]; then
      chmod -x "$destination"
    fi
  done

  safe_cp "$CO"/config/journald.conf /etc/systemd/journald.conf.d/90-co.conf
  safe_cp "$CO"/config/bluetooth.conf /etc/bluetooth/main.conf
}

# Enables systemwide systemd units.
# Globals Read:
#   - DRY_RUN: See setup().
# Outputs:
#   - Installation progress.
function enable_system_units() {
  local -ra units=(
    # Enable periodic TRIM.
    "fstrim.timer"
    # Enable reflector.
    "reflector.timer"
    # Enable bluetooth.
    "bluetooth.service"
    # Enable the NetworkManager daemon.
    "NetworkManager.service"
    # Start CUPS on demand.
    "cups.socket"
    # Start Docker on demand.
    "docker.socket"
  )

  for unit in "${units[@]}"; do
    if systemctl -q is-active "$unit"; then
      verbose "$unit is already enabled."
    else
      if [[ $DRY_RUN = false ]]; then
        info "Enabling systemd unit $unit."
        systemctl -q enable --now "$unit" || true
      fi
    fi
  done
}

# Applies udev rules.
# Globals Read:
#   - DRY_RUN: See setup().
# Outputs:
#   - Copy feedback.
function configure_udev_rules() {
  for rule in "$CO"/config/udev/*.rules; do
    safe_cp "$rule" /etc/udev/rules.d/"$(basename "$rule")" root:root 600
  done
}

# Configures Xorg.
# Globals Read:
#   - DRY_RUN: See setup().
# Outputs:
#   - Copy feedback.
function configure_xorg() {
  safe_cp "$CO"/config/xorg.conf /etc/X11/xorg.conf.d/10-common.conf
  if [[ $CO_HOST = "LAPTOP_P500" ]]; then
    safe_cp "$CO"/config/xorg.p500.conf /etc/X11/xorg.conf.d/10-p500.conf
  fi
}

# Configures sudo.
# Globals Read:
#   - DRY_RUN: See setup().
# Outputs:
#   - Copy feedback.
function configure_sudo() {
  safe_cp "$CO"/config/sudo.conf /etc/sudo.conf
  safe_cp "$CO"/config/sudoers /etc/sudoers
}

# Creates the group that is used by Docker.
# Arguments:
#   - The name of the group.
# Globals Read:
#   - DRY_RUN: See setup().
# Outputs:
#   - Creation feedback.
function add_group() {
  local -r group=$1

  if grep "^$group:" /etc/group >/dev/null; then
    verbose "\"$group\" group already exists."
  else
    info "Adding new \"$group\" group."
    [[ $DRY_RUN = false ]] && groupadd "$group"
  fi
}

# Adds a user to a group.
# Arguments (modeled after that of `usermod`):
#   - The name of the group.
#   - The name of the user.
# Globals Read:
#   - DRY_RUN: See setup().
# Outputs:
#   - Modification feedback.
function add_user_group() {
  local -r group=$1
  local -r user=$2

  if ! grep "^$user:" /etc/passwd >/dev/null; then
    error "User \"$user\" doesn't exist."
    return 1
  fi
  if ! grep "^$group:" /etc/group >/dev/null; then
    error "Group \"$group\" doesn't exist."
    return 1
  fi

  [[ $DRY_RUN = false ]] && usermod -aG "$group" "$user"
}

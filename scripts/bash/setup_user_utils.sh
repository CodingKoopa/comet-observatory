#!/bin/bash

# Copyright 2019 Comet Observatory
# Licensed under GPLv3.
# Refer to License.txt file included.

# shellcheck source=scripts/bash/common.sh
source "$CO"/scripts/bash/common.sh
# shellcheck source=scripts/bash/file_utils.sh
source "$CO"/scripts/bash/file_utils.sh
# shellcheck source=scripts/makepkg/repos.sh
source "$CO"/scripts/makepkg/repos.sh

# Creates new directories, and sets them up with proper permissions if necessary.
# Globals Read:
#   - DRY_RUN: See setup().
#   - INSTALL_USER: See setup_system().
# Outputs:
#   - Installation progress.
function create_directories() {
  declare -ra new_paths=(
    "$GNUPGHOME"
    "$INSTALL_HOME/.cache/pikaur/pkg/"
  )

  for target in "${new_paths[@]}"; do
    if [[ ! -d $target ]]; then
      info "Making new path $target."
      if [[ $DRY_RUN = false ]]; then
        mkdir -p "$target"
      fi
    fi
  done
  if [[ $(stat -c "%a" "$GNUPGHOME") != "700" ]]; then
    info "Setting GnuPG directory permissions to 700."
    if [[ $DRY_RUN = false ]]; then
      # The GPG home directory needs special permissions.
      chmod 700 -R "$GNUPGHOME"
    fi
  fi
}

# Creates new directories, and sets them up with proper permissions if necessary.
# Globals Read:
#   - DRY_RUN: See setup().
#   - INSTALL_HOME: See export_constants().
#   - INSTALL_USER: See setup_system().
#   - CO: See co_rc.sh.
# Outputs:
#   - Link feedback.
function link_directories() {
  local -r program_configurations=$INSTALL_HOME/Documents/ProgramConfigurations
  local -r pwdata=$INSTALL_HOME/Documents/Passwords \& 2FA

  # The structure here (although will be random at runtime) is parallel to that of the package list.
  declare -A linked_paths=(
    # Shell

    ["$CO/scripts/bash/bash_profile.sh"]="$INSTALL_HOME/.bash_profile"
    ["$CO/scripts/bash/bash_rc.sh"]="$INSTALL_HOME/.bashrc"
    ["$CO/scripts/x/x_rc.sh"]="$INSTALL_HOME/.xinitrc"

    # Tools

    ["$CO/config/less.conf"]="$INSTALL_HOME/.config/lesskey"
    ["$CO/config/nano.conf"]="$INSTALL_HOME/.config/nano/nanorc"
    ["$program_configurations/toprc"]="$INSTALL_HOME/.config/procps/toprc"
    ["$program_configurations/gitconfig"]="$INSTALL_HOME/.gitconfig"
    ["$CO/config/gpg.conf"]="$INSTALL_HOME/.local/share/gnupg/gpg.conf"
    ["$CO/config/gpg-agent.conf"]="$INSTALL_HOME/.local/share/gnupg/gpg-agent.conf"
    ["$CO/config/pikaur.conf"]="$INSTALL_HOME/.config/pikaur.conf"
    ["$pwdata/SSH"]="$INSTALL_HOME/.ssh"

    # Media

    ["$CO/config/filters/documents.stignore"]="$INSTALL_HOME/Documents/.stignore"
    ["$CO/config/chrome-flags.conf"]="$INSTALL_HOME/.config/chrome-flags.conf"
    ["$program_configurations/OBS Studio"]="$INSTALL_HOME/.config/obs-studio"
    ["$program_configurations/Blender"]="$INSTALL_HOME/.config/blender"

    # Gaming

    ["$CO/config/gamemode.ini"]="$INSTALL_HOME/.config/gamemode.ini"
    ["$program_configurations/Citra"]="$INSTALL_HOME/.config/citra-emu"
    ["$program_data/Citra"]="$INSTALL_HOME/.local/share/citra-emu"
    ["$program_configurations/Dolphin"]="$INSTALL_HOME/.config/dolphin-emu"
    ["$program_data/Dolphin"]="$INSTALL_HOME/.local/share/dolphin-emu"
    ["$program_configurations/Yuzu"]="$INSTALL_HOME/.config/yuzu"
    ["$program_data/Yuzu"]="$INSTALL_HOME/.local/share/yuzu"
    ["$program_data/Lucas' Simpsons Hit & Run Mod Launcher"]="$INSTALL_HOME/Documents/My Games/Lucas' Simpsons Hit & Run Mod Launcher"

    # Programming

    ["$CO/config/vs-code/keybindings.json"]="$INSTALL_HOME/.config/Code - OSS/User/keybindings.json"
    ["$CO/config/vs-code/settings.json"]="$INSTALL_HOME/.config/Code - OSS/User/settings.json"
  )

  if [[ $CO_HOST = "DESKTOP" ]]; then
    linked_paths["$CO/config/default.pa"]+="$INSTALL_HOME/.config/pulse/default.pa"
    linked_paths["$CO/config/mpv.desktop.conf"]+="$INSTALL_HOME/.config/mpv/mpv.conf"
  elif [[ $CO_HOST = "LAPTOP_P500" ]]; then
    linked_paths["$CO/config/mpv.laptop.conf"]+="$INSTALL_HOME/.config/mpv/mpv.conf"
  fi

  for target in "${!linked_paths[@]}"; do
    safe_ln "$target" "${linked_paths[${target}]}"
  done
}

# Configures user systemd units.
# Globals Read:
#   - DRY_RUN: See setup().
# Outputs:
#   - Copy feedback.
function configure_user_units() {
  safe_cp "$CO"/config/systemd-overrides/gpg-agent.conf \
    "$INSTALL_HOME"/.config/systemd/user/gpg-agent.service.d/override.conf \
    "$INSTALL_USER":"$INSTALL_USER" 600
  safe_cp "$CO"/config/systemd-overrides/dirmngr-socket.conf \
    "$INSTALL_HOME"/.config/systemd/user/dirmngr.socket.d/override.conf \
    "$INSTALL_USER":"$INSTALL_USER" 600
  safe_cp "$CO"/config/systemd-overrides/gpg-agent-ssh-socket.conf \
    "$INSTALL_HOME"/.config/systemd/user/gpg-agent-ssh.socket.d/override.conf \
    "$INSTALL_USER":"$INSTALL_USER" 600
  safe_cp "$CO"/config/systemd-overrides/gpg-agent-extra-socket.conf \
    "$INSTALL_HOME"/.config/systemd/user/gpg-agent-extra.socket.d/override.conf \
    "$INSTALL_USER":"$INSTALL_USER" 600
  safe_cp "$CO"/config/systemd-overrides/gpg-agent-browser-socket.conf \
    "$INSTALL_HOME"/.config/systemd/user/gpg-agent-browser.socket.d/override.conf \
    "$INSTALL_USER":"$INSTALL_USER" 600
  safe_cp "$CO"/config/systemd-overrides/gpg-agent-socket.conf \
    "$INSTALL_HOME"/.config/systemd/user/gpg-agent.socket.d/override.conf \
    "$INSTALL_USER":"$INSTALL_USER" 600
  safe_cp "$CO"/config/systemd-overrides/xdg-desktop-portal.conf \
    "$INSTALL_HOME"/.config/systemd/user/xdg-desktop-portal.service.d/override.conf \
    "$INSTALL_USER":"$INSTALL_USER" 600
  systemctl --user daemon-reload
}

# Enables user systemd units.
# Globals Read:
#   - DRY_RUN: See setup().
# Outputs:
#   - Installation progress.
function enable_user_units() {
  local -ra units=(
    "syncthing.service"
  )

  for unit in "${units[@]}"; do
    if systemctl --user -q is-active "$unit"; then
      verbose "$unit is already enabled."
    else
      if [[ $DRY_RUN = false ]]; then
        info "Enabling systemd unit $unit"
        # Allow to fail in case we're in a chroot.
        systemctl --user -q enable "$unit" || true
      fi
    fi
  done
}

# Imports data into GPG. To export these files, run:
#     gpg --output "Private Key.key" --export-secret-keys "<you@gmail.com>"
#     gpg --export-ownertrust > "Owner Trust.txt"
# Globals Read:
#   - DRY_RUN: See setup().
#   - export_constants: See export_constants().
function configure_gpg() {
  if [[ $DRY_RUN = false ]]; then
    info "Importing GnuPG data from the private documents."
    # Use loopback pinentry because our normal pinentry may not be set up right now.
    gpg -q --pinentry-mode loopback \
      --import "$INSTALL_HOME/Documents/Passwords & 2FA/GnuPG/Private Key.key"
    gpg -q --pinentry-mode loopback \
      --import-ownertrust "$INSTALL_HOME/Documents/Passwords & 2FA/GnuPG/Owner Trust.txt"
  fi
}

# Clones and builds a custom package. Similar to install_from_repo() but we keep the repo.
# Arguments:
#   - The name of the repository.
# Globals Read:
#   - DRY_RUN: See setup().
#   - AUR_DIR: See setup().
function install_local() {
  local -r repo=$1
  safe_cd "$AUR_DIR"
  if [[ ! -d "$repo"/.git ]]; then
    info "Cloning repo for $repo."
    [[ $DRY_RUN = false ]] && git clone --recursive git@gitlab.com:CodingKoopa/"$1".git
  else
    verbose "Repo for $repo seems to already be cloned."
  fi
  info "Building and installing $repo."
  safe_cd "$repo"
  [[ $DRY_RUN = false ]] && makepkg --force --syncdeps --install --noconfirm "$repo"
  safe_cd -
  safe_cd -
}

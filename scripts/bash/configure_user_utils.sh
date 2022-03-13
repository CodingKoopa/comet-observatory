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
#   - CO: See export_constants().
#   - SYNCED_DOCUMENTS_DIR: See export_constants().
# Outputs:
#   - Link feedback.
function link_directories() {
  # The structure here (although will be random at runtime) is parallel to that of the package list.
  declare -rA linked_paths=(
    # Shell

    ["$CO/scripts/bash/bash_profile.sh"]="$INSTALL_HOME/.bash_profile"
    ["$CO/scripts/bash/bash_rc.sh"]="$INSTALL_HOME/.bashrc"
    ["$CO/scripts/x/x_rc.sh"]="$INSTALL_HOME/.xinitrc"
    ["$CO/config/compose-keys.conf"]="$INSTALL_HOME/.XCompose"

    # KDE Accessories

    ["$CO/config/autostart-plasma/"]="$INSTALL_HOME/.config/autostart-scripts"
    ["$CO/config/khotkeys.ini"]="$INSTALL_HOME/.config/khotkeysrc"

    # Tools

    ["$CO/config/nano.conf"]="$INSTALL_HOME/.config/nano/nanorc"
    ["$SYNCED_DOCUMENTS_DIR/ProgramConfigurations/Top Configuration"]="$INSTALL_HOME/.config/procps/toprc"
    ["$SYNCED_DOCUMENTS_DIR/ProgramConfigurations/Git Configuration"]="$INSTALL_HOME/.gitconfig"
    ["$CO/config/gpg.conf"]="$INSTALL_HOME/.gnupg/gpg.conf"
    ["$CO/config/gpg-agent.conf"]="$INSTALL_HOME/.gnupg/gpg-agent.conf"
    ["$CO/config/pikaur.conf"]="$INSTALL_HOME/.config/pikaur.conf"
    ["$SYNCED_DOCUMENTS_DIR/ProgramConfigurations/KeePassXC.ini"]="$INSTALL_HOME/.config/keepassxc/keepassxc.ini"

    # Media

    ["$CO/config/chrome-flags.conf"]="$INSTALL_HOME/.config/chrome-flags.conf"
    ["$CO/config/mpv.conf"]="$INSTALL_HOME/.config/mpv/mpv.conf"
    ["$SYNCED_DOCUMENTS_DIR/ProgramConfigurations/OBS Studio"]="$INSTALL_HOME/.config/obs-studio"
    ["$SYNCED_DOCUMENTS_DIR/ProgramConfigurations/Blender"]="$INSTALL_HOME/.config/blender"

    # Gaming

    ["$CO/config/gamemode.ini"]="$INSTALL_HOME/.config/gamemode.ini"
    ["$SYNCED_DOCUMENTS_DIR/ProgramConfigurations/Citra"]="$INSTALL_HOME/.config/citra-emu"
    ["$SYNCED_DOCUMENTS_DIR/ProgramData/Citra"]="$INSTALL_HOME/.local/share/citra-emu"
    ["$SYNCED_DOCUMENTS_DIR/ProgramConfigurations/Dolphin"]="$INSTALL_HOME/.config/dolphin-emu"
    ["$SYNCED_DOCUMENTS_DIR/ProgramData/Dolphin"]="$INSTALL_HOME/.local/share/dolphin-emu"
    ["$SYNCED_DOCUMENTS_DIR/ProgramConfigurations/Yuzu"]="$INSTALL_HOME/.config/yuzu"
    ["$SYNCED_DOCUMENTS_DIR/ProgramData/Yuzu"]="$INSTALL_HOME/.local/share/yuzu"
    ["$SYNCED_DOCUMENTS_DIR/ProgramData/Lucas' Simpsons Hit & Run Mod Launcher"]="$INSTALL_HOME/Documents/My Games/Lucas' Simpsons Hit & Run Mod Launcher"
    # TODO: Restore this when we have another game drive.
    # ["$INSTALL_HOME/Fountain/Games/PC/IndependentWindows/The Simpsons Hit & Run/"]="$INSTALL_HOME/.local/share/the-simpsons-hit-and-run"

    # Programming

    ["$CO/config/vs-code/Keybindings.json"]="$INSTALL_HOME/.config/Code - OSS/User/keybindings.json"
    ["$CO/config/vs-code/Settings.json"]="$INSTALL_HOME/.config/Code - OSS/User/settings.json"
    ["$CO/config/vs-code/Snippets/"]="$INSTALL_HOME/.config/Code - OSS/User/snippets"

    # Frogging Family

    # Link TKG Kernel configuration from CO to user configuration.
    # ["$CO/config/tkg/linux-tkg.cfg"]="$INSTALL_HOME/.config/frogminer/linux-tkg.cfg"
    # Link TKG Nvidia configuration from CO to user configuration.
    # ["$CO/config/tkg/nvidia-all.cfg"]="$INSTALL_HOME/.config/frogminer/nvidia-all.cfg"
    # Link TKG Wine configuration from CO to user configuration.
    # ["$CO/config/tkg/proton-tkg.cfg"]="$INSTALL_HOME/.config/frogminer/proton-tkg.cfg"
  )

  if [[ $CO_HOST = "DESKTOP" ]]; then
    linked_paths["$TERRACE_DOWNLOADS_DIR"]+="$INSTALL_HOME/Downloads"
    linked_paths["$FOUNTAIN_DOCUMENTS_DIR"]+="$INSTALL_HOME/Documents"
    linked_paths["$TERRACE_PICTURES_DIR"]+="$INSTALL_HOME/Pictures"
    linked_paths["$TERRACE_VIDEOS_DIR"]+="$INSTALL_HOME/Videos"
    linked_paths["$TERRACE_MUSIC_DIR"]+="$INSTALL_HOME/Music"
    linked_paths["$INSTALL_HOME/Documents"]+="$INSTALL_HOME/Desktop"
  elif [[ $CO_HOST = "LAPTOP_P500" ]]; then
    true
  fi

  for target in "${!linked_paths[@]}"; do
    if [[ $SYNCED_DOCUMENTS = false ]]; then
      if [[ $target == "$SYNCED_DOCUMENTS_DIR"* ]]; then
        continue
      fi
    fi
    safe_ln "$target" "${linked_paths[${target}]}"
  done

  # Link PulseAudio startup script from CO to user configuration.
  if [[ $CO_HOST = "DESKTOP" ]]; then
    safe_ln "$CO/config/default.pa" "$INSTALL_HOME/.config/pulse/default.pa"
  fi
}

# Configures user systemd units.
# Globals Read:
#   - DRY_RUN: See setup().
# Outputs:
#   - Copy feedback.
function configure_user_units() {
  for service in "$CO"/config/systemd-user-units/*.{service,timer}; do
    safe_cp "$service" "$INSTALL_HOME"/.config/systemd/user/"$(basename "$service")" \
      "$INSTALL_USER":"$INSTALL_USER" 600
  done
  # Link the system network-online target to the user systemd instance, for the rclone services.
  safe_ln /usr/lib/systemd/system/network-online.target \
    "$INSTALL_HOME"/.config/systemd/user/network-online.target
}

# Enables user systemd units.
# Globals Read:
#   - DRY_RUN: See setup().
# Outputs:
#   - Installation progress.
function enable_user_units() {
  local -ra units=(
    # Enable the SSH agent.
    "ssh-agent.service"
    "rclone-sync-edges.service"
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
function configure_gpg() {
  if [[ $DRY_RUN = false && $SYNCED_DOCUMENTS = true ]]; then
    info "Importing GnuPG data from the private documents."
    # Use loopback pinentry because our normal pinentry may not be set up right now.
    gpg -q --pinentry-mode loopback \
      --import "$SYNCED_DOCUMENTS_DIR/Passwords & 2FA/GnuPG/Private Key.key"
    gpg -q --pinentry-mode loopback \
      --import-ownertrust "$SYNCED_DOCUMENTS_DIR/Passwords & 2FA/GnuPG/Owner Trust.txt"
  fi
}

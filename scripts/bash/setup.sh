#!/bin/bash

# Dependencies:
#  - "scripts/bash/common.sh"

# Links one file to another and resolves conflicts.
# Arguments:
#  - The destination.
#  - The name.
ln_()
{
  TARGET=$1
  NAME=$2
  if [ -L "$NAME" ]; then
    info "Symbolic link $NAME exists, skipping."
    return
  elif [ -f "$NAME" ] || [ -d "$NAME" ]; then
    NAME_OLD="$NAME.old"
    info "File or directory to be linked $NAME exists, moving to $NAME_OLD."
    mv "$NAME" "$NAME_OLD"
  fi

  PARENT_DIRECTORY=$(dirname "$NAME")
  # Make sure the target's parent directory exists.
  if ! [ -d "$PARENT_DIRECTORY" ]; then
    info "Making parent directory $PARENT_DIRECTORY."
    mkdir -p "$PARENT_DIRECTORY"
  fi

  ln -s "$TARGET" "$NAME"
}

# Sets up a new system.
setup()
{
  # TODO:
  # - Add a udev rule for backing up SD card files when plugged in.

  ##################################################################################################
  ### Stage 1: Make a directory structure to work off of.
  ##################################################################################################
  info "Stage 1: Making directory structure."

  # Arch Build System directory. Technically, AUR packages are not part of the ABS, but this is an
  # easy way of organizing.
  LOCAL_AUR_DIR="$HOME/Documents/ABS/aur"

  declare -a NEW_PATHS=(
      "$HOME/Uploads"
      "$HOME/Documents/Private"
      "$LOCAL_AUR_DIR"
  )

  for LOCAL_PATH in "${NEW_PATHS[@]}"; do
    debug "Making new path $LOCAL_PATH."
    mkdir -p "$LOCAL_PATH"
  done

  ##################################################################################################
  ### Stage 2: Tweak the Pacman configuration.
  ##################################################################################################
  info "Stage 2: Installing Pacman configuration."

  # TODO: update this comment
  # Pacman's configuration is only writeable by root, and the configuration that would be stored in
  # the MEGA private documents isn't accessable yet, so we manually write the config ourselves.
  # TODO: enable multilib repo
  info "Linking dotfiles Pacman configuration to system path. Checking if system path is a symlink."
  if [[ -L /etc/pacman.conf ]]; then
    info "System path is a symlink, skipping."
  else
    info "System path is not a symlink, linking."

    sudo mv /etc/pacman.conf /etc/pacman.conf.old
    sudo ln -sf $DOTFILES/config/pacman.conf /etc/pacman.conf

    info "Syncing package database."
    # Refresh everything.
    sudo pacman -Syu > /dev/null
  fi

  ##################################################################################################
  ### Stage 3: Install pacaur from the AUR.
  ##################################################################################################
  info "Stage 3: Installing pacaur."

  PACMAN_ARGS=(--noconfirm --needed --noprogressbar)

  mkdir -p "$LOCAL_AUR_DIR"

  info "Installing development packages and Git."
  # Install the development packages, and Git.
  sudo pacman -S "${PACMAN_ARGS[@]}" base-devel git > /dev/null

  ( install_aur_package cower )
  ( install_aur_package pacaur )

  ##################################################################################################
  ### Stage 4: Sign into MEGA to sync the private documents.
  ##################################################################################################
  info "Stage 4: Signing into MEGA."

  info "Installing MegaCMD and MegaSync."
  sudo pacman -S "${PACMAN_ARGS[@]}" megacmd megasync > /dev/null

  info "Checking if signed into MEGA."
  mega-login > /dev/null
  if [[ $? -eq 202 ]]; then
    info "Already signed into MEGA. Skipping."
  else
    info "Not signed into MEGA, signing in."
    while true; do
      read -rp "Enter your MEGA username: " USERNAME
      read -rsp "Enter your password: " PASSWORD
      mega-login "$USERNAME" "$PASSWORD"
      # MEGA returns 0 regardless of whether the login was successful or not.
      read -rp "Are you sure? Enter y to continue: " CHOICE
      if [[ $CHOICE = 'y' ]]; then
        break
      fi
    done
  fi

  ##################################################################################################
  ### Stage 5: Create MEGA syncs to home folder subdirectories.
  ##################################################################################################
  info "Stage 5: Syncing local folders to MEGA."

  PRIVATE_DOCUMENTS_LOCAL_DIRECTORY="$HOME/Documents/Private"
  declare -A SYNCED_PATHS=(
      ["$PRIVATE_DOCUMENTS_LOCAL_DIRECTORY"]="/Private Documents"
      ["$HOME/Music"]="/Music"
      ["$HOME/Videos"]="/Videos"
      ["$HOME/Pictures"]="/Pictures"
      ["$HOME/Documents/Timers"]="/Timers"
      ["$HOME/Documents/Models"]="/Models"
      ["$HOME/Uploads"]="/Uploads"
      ["$HOME/External/"]="/Uploads"
      ["$HOME/Uploads"]="/Uploads"
  )

  for LOCAL_PATH in "${!SYNCED_PATHS[@]}"; do
    debug "Local path $LOCAL_PATH gets synced to remote path ${SYNCED_PATHS[$LOCAL_PATH]}."
    mkdir -p "$LOCAL_PATH"
    if ! $DEBUG; then
      mega-sync "$LOCAL_PATH" "${SYNCED_PATHS[$LOCAL_PATH]}"
    fi
  done

  ##################################################################################################
  ### Stage 7: Import GPG data from the private documents.
  ##################################################################################################
  info "Importing GnuPG keys."

  # GPG should be initialized before making the symlinks so that it can make the config dir if it
  # hasn't been ran already.
  gpg -q --import "$PRIVATE_DOCUMENTS_LOCAL_DIRECTORY/GnuPG/Private Key.key"
  # This actually isn't necessary, as the public key is stored inside OpenPGP compliant private
  # keys.
  # gpg --import "$PRIVATE_DOCUMENTS_LOCAL_DIRECTORY/Public Key.key"
  gpg -q --import-ownertrust "$HOME/Documents/Private/GnuPG/Owner Trust.txt"

  ##################################################################################################
  ### Stage 8: Link directories from the private documents to other paths in the system.
  ##################################################################################################
  info "Making symbolic links."

  declare -A LINKED_PATHS=(
      # Link downloads from external to home folder.
      ["$HOME/Downloads"]="$HOME/External/Downloads"
      # Link downloads from external to home folder.
      ["$HOME/Music"]="$HOME/External/Music"

      # Link GnuPGP Public keyring from private docs to home folder.
      ["$HOME/.gnupg/pubring.kbx"]="$PRIVATE_DOCUMENTS_LOCAL_DIRECTORY/GnuPG/Public Keyring.kbx"
      # Link SSH files from private docs to home folder.
      ["$HOME/.ssh"]="$PRIVATE_DOCUMENTS_LOCAL_DIRECTORY/SSH"
      # Link dotfiles config from private docs to dotfiles.
      ["$DOTFILES/scripts/bash/config.sh"]=\
"$PRIVATE_DOCUMENTS_LOCAL_DIRECTORY/Dotfiles Configuration.sh"
      # Link Citra configuration from private docs to home folder. This is private because it stores
      # recent files, including full paths.
      ["$HOME/.config/citra-emu"]="$PRIVATE_DOCUMENTS_LOCAL_DIRECTORY/Configuration/citra-emu"
      # Link Dolphin configuration from private docs to home folder. This is private for the same
      # reason.
      ["$HOME/.config/dolphin-emu"]="$PRIVATE_DOCUMENTS_LOCAL_DIRECTORY/Configuration/dolphin-emu"
      # Link Citra data from private docs to home folder.
      ["$HOME/.local/share/citra-emu"]="$PRIVATE_DOCUMENTS_LOCAL_DIRECTORY/Data/citra-emu"
      # Link Dolphin data from private docs to home folder.
      ["$HOME/.local/share/dolphin-emu"]="$PRIVATE_DOCUMENTS_LOCAL_DIRECTORY/Data/dolphin-emu"
      # Link Git configuration from private docs to home folder. This is private because it contains
      # user-specific info like email.
      ["$HOME/.gitconfig"]="$PRIVATE_DOCUMENTS_LOCAL_DIRECTORY/Git Configuration"
      # Link KeePassX configuration from private docs to home folder. This is private for the same
      # reason.
      ["$HOME/.config/keepassx"]="$PRIVATE_DOCUMENTS_LOCAL_DIRECTORY/Configuration/keepassx"
      # Link Llanfair configuration from private docs to home folder. This is private because, I kid
      # you not, the configuration CFG files are special binary formats. Why.
      ["$HOME/.config/llanfair"]="$PRIVATE_DOCUMENTS_LOCAL_DIRECTORY/Configuration/llanfair"
      # Link OBS Studio configuration from private docs to home folder. This is private because it's
      # somewhat sensitive info.
      ["$HOME/.config/obs-studio"]="$PRIVATE_DOCUMENTS_LOCAL_DIRECTORY/Configuration/obs-studio"
      # Link QT configuration from private docs to home folder. I honestly don't have much of a
      # reason to keep this private, it's just this is so big I don't even know if it has sensitive
      # info.
      ["$HOME/.config/QtProject"]="$PRIVATE_DOCUMENTS_LOCAL_DIRECTORY/Configuration/QtProject"
      # Link Clementine configuration from private docs to home folder. Only link the configuration,
      # because other files in the directory are subject to change.
      ["$HOME/.config/Clementine/Clementine.conf"]=\
"$PRIVATE_DOCUMENTS_LOCAL_DIRECTORY/Configuration/Clementine.conf"

      # Link The Simpsons: Hit & Run data from private docs to home folder.
      ["$HOME/.local/share/lucas-simpsons-hit-and-run-mod-launcher"]=\
"$PRIVATE_DOCUMENTS_LOCAL_DIRECTORY/Data/Lucas' Simpsons Hit & Run Mod Launcher"

      # Link icons from dotfiles to home folder.
      ["$HOME/.icons"]="$DOTFILES/data/icons"
  )

  for LOCAL_PATH in "${!LINKED_PATHS[@]}"; do
    debug "Local path $LOCAL_PATH gets linked to path ${LINKED_PATHS[$LOCAL_PATH]}."
    ln_ "${LINKED_PATHS[${LOCAL_PATH}]}" "$LOCAL_PATH"
  done

  # sudo ln -fs "$DOTFILES/bin/add_sd_card_sync.sh" /opt/add_sd_card_sync
  # TODO: fill out more of the service.
  # sudo ln -fs "$DOTFILES/data/services/add-sd-card-sync.service" /etc/systemd/system/
}

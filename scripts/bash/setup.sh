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
  # Make sure the target's parent directory exists.
  if [ -L "$NAME" ]; then
    info "Symbolic link $NAME exists, skipping."
    return
  elif [ -f "$NAME" ] || [ -d "$NAME" ]; then
    NAME_OLD="$NAME.old"
    info "File or directory to be linked $NAME exists, moving to $NAME_OLD."
    mv "$NAME" "$NAME_OLD"
  fi

  ln -s "$TARGET" "$NAME"
}

# Sets up a new system.
setup()
{
  # TODO:
  # - Add a  udev rule for backing up SD card files when plugged in.
  # - Games and recordings are too big to be practical to sync with MEGA. Not sure how I should
  # backup them.

  info "Making directory structure."
  declare -a NEW_PATHS=(
      "$HOME/Uploads"
      "$HOME/Documents/Private"
  )

  for LOCAL_PATH in "${NEW_PATHS[@]}"; do
    debug "Making new path $LOCAL_PATH."
    mkdir -p "$LOCAL_PATH"
  done

  PRIVATE_DOCUMENTS_LOCAL_DIRECTORY="$HOME/Documents/Private"
  SUBLIME_TEXT_3_CONFIG_PATH="sublime-text-3/Packages/User"

  # GPG should be initialized before making the symlinks so that it can make the config dir if it
  # hasn't been ran already.
  info "Importing GnuPG keys."
  gpg -q --import "$PRIVATE_DOCUMENTS_LOCAL_DIRECTORY/GnuPG/Private Key.key"
  # This actually isn't necessary, as the public key is stored inside OpenPGP compliant private
  # keys.
  # gpg --import "$PRIVATE_DOCUMENTS_LOCAL_DIRECTORY/Public Key.key"
  gpg -q --import-ownertrust "$HOME/Documents/Private/GnuPG/Owner Trust.txt"

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
      # Link The Simpsons: Hit & Run save data from private docs to home folder.
      ["$HOME/Documents/My Games/Lucas' Simpsons Hit & Run Mod Launcher/Saved Games"]=\
"$PRIVATE_DOCUMENTS_LOCAL_DIRECTORY/Data/SHAR Saves"

      # Link icons from dotfiles to home folder.
      ["$HOME/.icons"]="$DOTFILES/data/icons"
      # Link Sublime Text config from dotfiles to home folder.
      ["$HOME/.config/$SUBLIME_TEXT_3_CONFIG_PATH"]="$DOTFILES/config/$SUBLIME_TEXT_3_CONFIG_PATH"
  )

  for LOCAL_PATH in "${!LINKED_PATHS[@]}"; do
    info "Local path $LOCAL_PATH gets linked to path ${LINKED_PATHS[$LOCAL_PATH]}."
    ln_ "${LINKED_PATHS[${LOCAL_PATH}]}" "$LOCAL_PATH"
  done


  info "Syncing local folders to MEGA."
  declare -A SYNCED_PATHS=(
      ["$HOME/Music"]="/Music"
      ["$HOME/Videos"]="/Videos"
      ["$HOME/Pictures"]="/Pictures"
      [$PRIVATE_DOCUMENTS_LOCAL_DIRECTORY]="/Private Documents"
      ["$HOME/Documents/Timers"]="/Timers"
      ["$HOME/Documents/Models"]="/Models"
      ["$HOME/Uploads"]="/Uploads"
      ["$HOME/External/"]="/Uploads"
      ["$HOME/Uploads"]="/Uploads"
  )

  for LOCAL_PATH in "${!SYNCED_PATHS[@]}"; do
    debug "Local path $LOCAL_PATH gets synced to remote path ${SYNCED_PATHS[$LOCAL_PATH]}."
    # Supress error for existing sync.
    mega-sync "$LOCAL_PATH" "${SYNCED_PATHS[$LOCAL_PATH]}" &> /dev/null
  done
}

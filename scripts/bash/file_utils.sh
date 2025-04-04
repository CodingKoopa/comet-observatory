#!/bin/bash

# Copyright 2019 Comet Observatory
# Licensed under GPLv3.
# Refer to License.txt file included.

# shellcheck source=scripts/bash/common.sh
source "$CO"/scripts/bash/common.sh

# Copies a file, the source depending on the form factor of the host.
# Globals Read:
#   - DRY_RUN: See setup().
# Arguments:
#   - The source location if the host is a desktop.
#   - The source location if the host is a laptop.
#   - The destination location.
# Outputs:
#   - Copy feedback, or error.
# Returns:
#   - 0 if successful.
#   - 1 if the form factor isn't recognized.
function cp_for_form_factor() {
  local -r src_desktop=$1
  local -r src_laptop=$2
  local -r dest=$3
  if [[ $CO_HOST = DESKTOP ]]; then
    safe_cp "$src_desktop" "$dest"
  elif [[ $CO_HOST = LAPTOP* ]]; then
    safe_cp "$src_laptop" "$dest"
  else
    error "Form factor unknown, I don't know which configuration to use."
    return 1
  fi
}

# Copies a file, the source depending on the exact host.
# Globals Read:
#   - DRY_RUN: See setup().
# Arguments:
#   - The source location if the host is the desktop.
#   - The source location if the host is the Framework.
#   - The destination location.
# Outputs:
#   - Copy feedback, or error.
# Returns:
#   - 0 if successful.
#   - 1 if the host isn't recognized.
function cp_for_host() {
  local -r src_desktop=$1
  local -r src_fw=$2
  local -r dest=$3
  if [[ $CO_HOST = "DESKTOP" ]]; then
    safe_cp "$src_desktop" "$dest"
  elif [[ $CO_HOST = "LAPTOP_FRAMEWORK" ]]; then
    safe_cp "$src_fw" "$dest"
  else
    error "Host unknown, I don't know which configuration to use."
    return 1
  fi
}

# Copies a file, checking to see if it's already updated or not. Supports dry run.
# Globals Read:
#   - DRY_RUN: See setup().
# Arguments:
# - The source file path.
# - The destination file paths.
# - The owner to set the destination to (optional).
# - The permission to set the destination to (optional).
#  set the destination to.
# Returns:
#   None.
safe_cp() {
  local -r source=$1
  local -r destination=$2
  local -r owner=$3
  local -r permission=$4

  if cmp "$source" "$destination" >/dev/null 2>&1; then
    verbose "$destination is already copied."
  else
    info "Copying file $source to $destination."
    if [[ $DRY_RUN = false ]]; then
      PARENT=$(dirname "$destination")
      if [[ ! -d $PARENT ]]; then
        info "Making parent $PARENT."
        mkdir -p "$PARENT"
      fi
      cp "$source" "$destination"
    fi
    if [[ -n $owner ]]; then
      info "Setting owner of $destination to $owner."
      if [[ $DRY_RUN = false ]]; then
        chown "$owner" "$destination"
      fi
    fi
    if [[ -n $permission ]]; then
      info "Setting permissions of $destination to $permission."
      if [[ $DRY_RUN = false ]]; then
        chmod "$permission" "$destination"
      fi
    fi
  fi
}

# Links one file to another and resolves conflicts.
# Globals Read:
#   - DRY_RUN: See setup().
# Arguments:
#   - The target file path.
#   - The link file path.
# Outputs:
#   - Link feedback.
function safe_ln() {
  local -r target=$1
  local -r link_name=${2%/}

  if [[ -L "$link_name" ]] && cmp "$target" "$link_name" >/dev/null 2>&1; then
    verbose "$link_name is already updated."
  else
    local -r target_parent_directory=$(dirname "$target")
    # Handle conflicts with nonexistent target parent directories. This is a pretty unlikely
    # scenario, but possible if the path will later be populated with files.
    if ! [[ -d "$target_parent_directory" ]]; then
      info "Making target parent directory $target_parent_directory."
      if [[ $DRY_RUN = false ]]; then
        mkdir -p "$target_parent_directory"
      fi
    fi

    # Handle conflicts with preexisting files or directories.
    if [[ -f "$link_name" ]] || [[ -d "$link_name" ]]; then
      local -r common_str="Path $link_name exists"
      if [[ -L "$link_name" ]]; then
        info "$common_str, is a link. Overwriting."
      else
        local -r link_name_old="$link_name.old"
        info "$common_str, isn't a link. Moving to $link_name_old."
        if [[ $DRY_RUN = false ]]; then
          mv "$link_name" "$link_name_old"
        fi
      fi

    # Handle conflcits with nonexistent link name parent directories.
    else
      local -r link_name_parent_directory=$(dirname "$link_name")
      if [[ ! -d $link_name_parent_directory ]]; then
        info "Making link name parent directory $link_name_parent_directory."
        if [[ -L "$link_name_parent_directory" ]]; then
          info "Parent directory $link_name_parent_directory is a link, overwriting."
          if [[ $DRY_RUN = false ]]; then
            rm "$link_name_parent_directory"
          fi
        fi
        if [[ $DRY_RUN = false ]]; then
          mkdir -p "$link_name_parent_directory"
        fi
      fi
    fi

    info "Creating link to target $target at $link_name."

    if [[ $DRY_RUN = false ]]; then
      debug "Executing ln -sf \"$target\" \"$link_name\""
      ln -sf "$target" "$link_name"
    fi
  fi
}

# Enters a directory, erroring and exiting if anything goes wrong.
# Arguments:
#   - The directory to change to.
# Outputs:
#   - Change directory feedback.
# Returns:
#   - 1 if an error occurred.
function safe_cd() {
  d=$1
  debug "$(pwd) -> $1"
  # Supress the path being printed, in the case of "cd -".
  if ! cd "$d" >/dev/null; then
    error "Unable to enter directory \"$d\"."
    exit 1
  fi
}

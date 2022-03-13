#!/bin/bash

# Copyright 2020 Comet Observatory
# Licensed under GPLv3.
# Refer to License.txt file included.

# Builds and installs a package from the AUR. Convenience wrapper for install_from_repo().
# Arguments:
#   - The package to install.
# Outputs:
#   - makepkg output.
# Variables Read:
#   - DRY_RUN: See setup().
#   - PACMAN_ARGS: See export_constants().
#   - AUR_DIR: See install_from_repo().
#   - INSTALL_USER: See setup_system().
function install_from_aur() {
  local -r package=$1
  install_from_repo "$package" "https://aur.archlinux.org/$package.git"
}

# Builds and installs a package from a Git repository with a PKGBUILD.
# Arguments:
#   - The package to install.
#   - The URL to the repository.
# Outputs:
#   - makepkg output.
# Variables Read:
#   - DRY_RUN: See setup().
#   - PACMAN_ARGS: See export_constants().
#   - AUR_DIR: Location that the repository should be downloaded in.
#   - INSTALL_USER: See setup_system().
function install_from_repo() {
  local -r package=$1
  local -r url=$2
  if ! pacman -Qi "$package" &>/dev/null; then
    info "Installing build dependencies."
    if [[ $DRY_RUN = false ]]; then
      sudo pacman -S "${PACMAN_ARGS[@]}" base-devel git >/dev/null
    fi

    info "Installing $1."
    if [[ $DRY_RUN = false ]]; then
      local -r package_build_dir="$AUR_DIR/$package"
      # Make sure there's no pikaur dir becuase, if there is, Git will throw a fit.
      rm -rf "$package_build_dir"
      # Clone the AUR package Git repository.
      git clone -q --depth=1 "$url" "$package_build_dir"
      # Skip the PGP check becasue we might not have yet established our PGP keyring.
      cd "$package_build_dir" && sudo -u "$INSTALL_USER" makepkg -sifc --noconfirm --skippgpcheck
      safe_cd -
      rm -rf "$package_build_dir"
    fi
  else
    verbose "$package is already installed."
  fi
}

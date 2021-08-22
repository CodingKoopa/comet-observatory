#!/bin/bash

# Copyright 2020 Comet Observatory
# Licensed under GPLv3.
# Refer to License.txt file included.

set -e

# shellcheck source=scripts/bash/common.sh
source "$CO"/scripts/bash/common.sh
# shellcheck source=scripts/makepkg/repos.sh
source "$CO"/scripts/makepkg/repos.sh

# Prints the usage info for this script.
# Outputs:
#   - The help message.
function print_help() {
  # Keep the help string in its own variable because a single quote in a heredoc messes up syntax
  # highlighting.
  HELP_STRING="\
Usage: update [-hpc]
Updates the system, including official prebuilt packages, AUR packages, and, and custom Frogging
Family packages. Also handles some routine maintenance tasks.

  -h    Show this help message and exit.
  -a    Do everything. This is the default behavior.
  -c    Update custom packages. This pulls the latest Git repos, reviews changes, and builds the
packages.
  -p    Update prebuilt packages. This essentially runs pacman -Syu for official and AUR packages.
  -e    Check for extraneous packages. They won't necessarily be removed.
  -o    Remove orphan packages. Not included with -a because, generally, we will be keeping build
dependencies installed, which are considered orphaned packages."
  echo "$HELP_STRING"
  exit 0
}

# Updates the system.
# Globals Read:
#   - AUR_DIR: The directory where the repositories are located.
# Arguments:
#   - One or more flags dictating the action to be taken. See print_help().
# Outputs:
#   - Update progress.
function update() {
  local check_missing=false
  local check_extra=false
  local update_custom=false
  local update_prebuilt=false
  local remove_orphans=false

  if [[ $# -eq 0 ]]; then
    set -- -a
  fi
  while getopts "hacpeo" opt; do
    case $opt in
    h)
      print_help
      ;;
    a)
      check_missing=true
      check_extra=true
      update_prebuilt=true
      update_custom=true
      ;;
    c)
      update_custom=true
      ;;
    p)
      update_prebuilt=true
      ;;
    e)
      check_extra=true
      ;;
    o)
      remove_orphans=true
      ;;
    *)
      print_help
      ;;
    esac
  done

  # Ask for the sudo password now so that the rest of the process can proceed without it.
  sudo echo >/dev/null

  function handle_pacnew() {
    # Handle any pacnew/pacsave files issues.
    sudo -E DIFFPROG="sudo code -d" pacdiff
  }

  if [[ $remove_orphans = true ]]; then
    section "Removing Orphan Packages"

    pikaur -Qtdq | pikaur -Rns -
  fi
  if [[ $check_missing = true ]]; then
    section "Checking for Missing Packages"

    diff=$(comm -13 <(get_installed_package_list) <(get_co_package_list))
    if [[ -n $diff ]]; then
      info "These packages are on the CO list, but aren't installed on the system:"
      echo "$diff"
      info "Considering installing them or updating the list."
    fi
  fi
  if [[ $check_extra = true ]]; then
    section "Checking for Extraneous Packages"

    diff=$(comm -23 <(get_installed_package_list) <(get_co_package_list))
    if [[ -n $diff ]]; then
      info "These packages are explicitly installed on the system, but aren't on the CO list:"
      echo "$diff"
      info "Considering uninstalling them or adding them to the list."
    fi
  fi
  if [[ $update_prebuilt = true ]]; then
    section "Updating Prebuilt Packages"

    subsect "Syncing official packages."
    pikaur -Syu

    subsect "Syncing AUR packages."
    pikaur -Sua --devel --needed

    subsect "Handling configuration conflicts."
    handle_pacnew
  fi
  if [[ $update_custom = true ]]; then
    section "Updating Custom Package Sources"

    safe_cd "$AUR_DIR"
    subsect "Checking repository directories."
    check_repos
    subsect "Updating community patches."
    update_repo community-patches
    subsect "Updating TkG Linux kernel source."
    update_repo linux-tkg customization.cfg
    subsect "Updating Nvidia drivers."
    update_repo nvidia-all customization.cfg
    subsect "Updating TkG Proton."
    update_repo wine-tkg-git/proton-tkg proton-tkg.cfg \
      proton-tkg-profiles/advanced-customization.cfg

    section "Building Custom Packages"

    subsect "Building TKG Linux kernel."
    build_repo linux-tkg
    subsect "Building Nvidia drivers."
    build_repo nvidia-all
    subsect "Building TkG Proton."
    build_repo wine-tkg-git/proton-tkg

    subsect "Handling configuration conflicts."
    handle_pacnew
  fi
}

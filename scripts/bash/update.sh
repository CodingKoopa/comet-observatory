#!/bin/bash

# Copyright 2020 Comet Observatory
# Licensed under GPLv3.
# Refer to License.txt file included.

set -eo pipefail

# shellcheck source=scripts/bash/common.sh
source "$CO"/scripts/bash/common.sh
# shellcheck source=scripts/makepkg/repos.sh
source "$CO"/scripts/makepkg/repos.sh

readonly OPTIONS=hapftsome

# Prints the usage info for this script.
# Outputs:
#   - The help message.
function print_help() {
  # Keep the help string in its own variable because a single quote in a heredoc messes up syntax
  # highlighting.
  readonly HELP_STRING="\
Usage: update [-$OPTIONS]
Updates the system, including official prebuilt packages, AUR packages, and, locally patched
custom built packages.

  -h    Show this help message and exit.
  -a    Do everything. This is the default behavior.
  -p    Review and update prebuilt packages.
  -f    Force update all custom packages even if the repo is up to date. Implies -s and -t. Not
  included by -a.
  -t    Review and update custom TkG packages. Not included by -a.
  -s    Review and update custom suckless packages.
  -o    Remove orphan packages. Not included by -a because, generally, we will be keeping build
  dependencies installed, which are considered orphaned packages.
  -m    Check for missing packages. They won't be addded.
  -e    Check for extraneous packages. They won't be removed."
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
  local update_prebuilt=false
  local update_tkg=false
  local update_suckless=false
  local force_custom=false
  local check_missing=false
  local check_extra=false
  local remove_orphans=false

  if [[ $# -eq 0 ]]; then
    set -- -a
  fi
  while getopts "$OPTIONS" opt; do
    case $opt in
    h)
      print_help
      ;;
    a)
      check_missing=true
      check_extra=true
      update_prebuilt=true
      ;;
    p)
      update_prebuilt=true
      ;;
    f)
      force_custom=true
      update_tkg=true
      update_suckless=true
      ;;
    t)
      update_tkg=true
      ;;
    s)
      update_suckless=true
      ;;
    o)
      remove_orphans=true
      ;;
    m)
      check_missing=true
      ;;
    e)
      check_extra=true
      ;;
    *)
      print_help
      ;;
    esac
  done

  # Ask for the sudo password now so that the rest of the process can proceed without it.
  sudo echo >/dev/null

  if [[ $update_prebuilt = true ]]; then
    section "Updating Prebuilt Packages"

    subsect "Syncing official packages."
    pikaur -Syuo

    subsect "Syncing AUR packages."
    pikaur -Sua --devel

    subsect "Handling configuration conflicts."
    # Handle any pacnew/pacsave files issues.
    sudo -E DIFFPROG="sudo code -d" pacdiff
  fi
  if [[ $update_tkg = true ]]; then
    section "Updating TkG Package Sources"

    safe_cd "$AUR_DIR"
    subsect "Checking repository directories."
    check_repos
    subsect "Updating community patches."
    update_repo community-patches || true
    subsect "Updating TkG Linux kernel source."
    update_repo linux-tkg customization.cfg && update_linux_tkg=true || update_linux_tkg=false
    subsect "Updating Nvidia drivers."
    update_repo nvidia-all customization.cfg && update_nvidia_all=true || update_nvidia_all=false
    subsect "Updating TkG Proton."
    update_repo wine-tkg-git/proton-tkg proton-tkg.cfg \
      proton-tkg-profiles/advanced-customization.cfg && update_proton_tkg=true ||
      update_proton_tkg=false

    section "Building TkG Packages"

    subsect "Building TkG Linux kernel."
    if [[ $force_custom = true || $update_linux_tkg = true ]]; then
      build_repo linux-tkg
    else
      info "Already up to date."
    fi
    subsect "Building Nvidia drivers."
    if [[ $force_custom = true || $update_nvidia_all = true ]]; then
      build_repo nvidia-all
    else
      info "Already up to date."
    fi
    subsect "Building TkG Proton."
    if [[ $force_custom = true || $update_proton_tkg = true ]]; then
      build_repo wine-tkg-git/proton-tkg
    else
      info "Already up to date."
    fi
  fi
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
}

#!/bin/bash

# Copyright 2019 Comet Observatory
# Licensed under GPLv3.
# Refer to License.txt file included.

# Color Variables

RESET=$(tput sgr0)
export RESET
BOLD=$(tput bold)
export BOLD
WHITE=$(tput setaf 7)
export WHITE
GREEN=$(tput setaf 2)
export GREEN
CYAN=$(tput setaf 6)
export CYAN
BLUE=$(tput setaf 4)
export BLUE
MAGENTA=$(tput setaf 5)
export MAGENTA
RED=$(tput setaf 1)
export RED

# Printing Utilities

# Prints a section message.
# Arguments:
#   - Name of the section.
# Outputs:
#   - The section message.
function section() {
  printf "[${WHITE}Section${RESET}] ${BOLD}%s${RESET}\n" "$*"
}

# Prints a subsection message.
# Arguments:
#   - Name of the subsection.
# Outputs:
#   - The subsection message.
function subsect() {
  printf "[${MAGENTA}SubSect${RESET}] ${MAGENTA}${BOLD}%s${RESET}\n" "$*"
}

# Prints an info message.
# Arguments:
#   - Info to be printed.
# Outputs:
#   - The info message.
function info() {
  printf "[${GREEN}Info${RESET}   ] %s\n" "$*"
}

# Prompts for a boolean configuration value.
# TODO: "[y/n]", allow "yes"
# Arguments:
#   - Question to ask.
#   - Name of the variable to put the answer in.
#   - (Optional) Default answer, else prompt.
# Globals Exported:
#   - The configured variable.
# Outputs:
#   - The configuration prompt.
function config_bool() {
  local -r question=$1
  local -r variable_name=$2
  local answer=$3

  local message="[${CYAN}Config${RESET} ] $question"

  if [[ -n "$answer" ]]; then
    printf "%s %s\n" "$message" "$answer"
  else
    read -rp "$message " PROMPT
  fi

  if [[ $PROMPT = "y" || $answer = "y" ]]; then
    export "$variable_name"=true
  else
    export "$variable_name"=false
  fi
}

# Prompts for a string configuration value.
# Arguments:
#   - Question to ask.
#   - Name of the variable to put the answer in.
#   - (Optional) Default answer, else prompt.
# Globals Exported:
#   - The configured variable.
# Outputs:
#   - The configuration prompt.
function config_str() {
  local -r question=$1
  local -r variable_name=$2
  local answer=$3

  local message="[${CYAN}Config${RESET} ] $question"

  if [[ -n "$answer" ]]; then
    printf "%s %s\n" "$message" "$answer"
  else
    read -rp "$message " answer
  fi

  export "$variable_name"="$answer"
}

# Presents a "pause" to the user.
function pause() {
  read -n1 -r -p "[${CYAN}Pause${RESET}  ] Press enter to continue.
"
}

# Prints an error message.
# TODO: Use stderr.
# Arguments:
#   - Error to be printed.
# Outputs:
#   - The error message.
function error() {
  printf "[${RED}Error${RESET}  ] %s\n" "$*" >&2
}

# Prints a verbose message.
# Globals Read:
#   - (Optional) VERBOSE: Whether to print verbose info, out of true or false. Default false.
# Arguments:
#   - Verbose info to be printed.
# Outputs:
#   - The verbose message.
function verbose() {
  if [[ $DEBUG = true || $VERBOSE = true ]]; then
    printf "[${MAGENTA}Verbose${RESET}] %s\n" "$*"
  fi
}

# Prints a debug message.
# Globals Read:
#   - (Optional) DEBUG: Whether to print debug info, out of true or false. Default false.
# Arguments:
#   - Debug info to be printed.
# Outputs:
#   - The debug message.
function debug() {
  if [[ $DEBUG = true ]]; then
    printf "[${BLUE}Debug${RESET}  ] %s\n" "$*"
  fi
}

# Other Utilities

# Checks the user running the script.
# Globals Read:
#   - DRY_RUN: See setup().
# Arguments:
#   - Whether to require root.
function check_user() {
  local -r require_root=$1

  if [[ $DRY_RUN = false ]]; then
    if [[ $EUID -eq 0 ]]; then
      if [[ $require_root = false ]]; then
        error "This script cannot be run as root."
        exit 1
      fi
    else
      if [[ $require_root = true ]]; then
        error "This script must be run as root."
        exit 1
      fi
    fi
  fi
}

# Prints a header.
# Arguments:
#   - The name of the script.
# Outputs:
#   - The Luma ASCII art, and repository info.
function print_header() {
  local -r script=$1

  # Within the context of setup-* comet observatory variable has not yet been checked.
  if [[ $DEBUG != true && -d $CO ]]; then
    lolcat -F 0.01 <"$CO"/data/luma.txt
  fi
  info "Comet Observatory System $script Script"
  info "https://gitlab.com/CodingKoopa/comet-observatory"
  debug "Running in debug mode."
}

function ask() {
  zenity --width 300 --question --text "$1"
  echo $?
}

# Asks if the directory selection process should be canceled or not.
# Outputs:
#   - 1 if the user wants to exit, else 0.
function prompt_exit() {
  ask "The list dialog was closed, or cancel was clicked. Exit?"
}

# Sanitizes a string so that it may be displayed in Zenity without any problems. sed expression from
# https://unix.stackexchange.com/a/37663.
# Arguments:
#   - The input string.
# Outputs:
#   - The sanitized string.
function sanitize_zenity() {
  echo "$1" | sed -e 's/\\/\\\\/g' -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g'
}

# Gets the list of explicitly installed packages, excluding members of the "base" meta package and
# the "base-devel" package group, and custom built packages. Thanks:
# https://wiki.archlinux.org/title/Pacman/Tips_and_tricks
# Outputs:
#   - The list of packages.
function get_installed_package_list() {
  comm -23 <(
    {
      echo "base-devel"
      pacman -Qqe
    } | sort
  ) <({
    pacman -Qqg base-devel
    expac -l '\n' '%E' base
  } | sort) | grep -v "tkg"
}

# Gets the list of packages specified in this repo. Empty lines and comments are stripped out.
# Globals Read:
#   - CO: See export_constants().
#   - CO_HOST: See co_rc.sh.
# Outputs:
#   - The list of packages.
function get_co_package_list() {
  function parse() {
    grep "^[a-z|A-Z]" "$CO"/data/"$1"
  }

  local packages
  packages=$(parse packages.sh)
  if [[ $CO_HOST = "DESKTOP" ]]; then
    packages+="
$(parse packages.desktop.sh)"
  elif [[ $CO_HOST = "LAPTOP_P500" ]]; then
    packages+="
$(parse packages.p500.sh)"
  fi
  packages=$(echo "$packages" | sort)

  echo "$packages"
}

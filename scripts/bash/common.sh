#!/bin/bash

# Only define these once per source.
BLUE=$(tput setaf 4)
GREEN=$(tput setaf 2)
RED=$(tput setaf 1)
NORMAL=$(tput sgr0)

DEBUG=false

debug()
{
  if $DEBUG; then
    printf "${BLUE}Debug: %s\n${NORMAL}" "$*"
  fi
}

info()
{
  printf "${GREEN}Info: %s\n${NORMAL}" "$*"
}

error()
{
  printf "${RED}Error: %s\n${NORMAL}" "$*"
}

get_package_manager()
{
  while true; do
    printf "What package manager do you use?\n"
    printf "P - pacaur (Arch Linux)\n"
    printf "S - Skip this, I'll install the packages myself\n"
    read -r PACKAGE_MANAGER
    if [ "$PACKAGE_MANAGER" != 'P' ] && [ "$PACKAGE_MANAGER" != 'p' ] && \
    [ "$PACKAGE_MANAGER" != 'S' ] && [ "$PACKAGE_MANAGER" != 's' ]; then
      printf "Invalid package manager, try again.\n"
    else
      return
    fi
  done
}

# Arguments:
# 1: Executable.
# 2: pacaur package name.
check_install()
{
  if [ -z "$PACKAGE_MANAGER" ]; then
    get_package_manager
  fi

  # Check if the command is there.
  if hash "$1" 2>/dev/null; then
    return 0
  else
    read -r -p "The program \"$1\" was not found.
    Would you like to install it? (y/n)" INSTALL_PROGRAM
    if [[ "$INSTALL_PROGRAM" = "Y" ]] || [[ "$INSTALL_PROGRAM" = "y" ]]; then
      if [[ "$PACKAGE_MANAGER" = 'P' ]] || [[ "$PACKAGE_MANAGER" = 'p' ]]; then
        pacaur -S "$2"
      fi
      if [[ "$PACKAGE_MANAGER" = 'S' ]] || [[ "$PACKAGE_MANAGER" = 's' ]]; then
        return 1
      fi
    else
      return 1
    fi
  fi
}

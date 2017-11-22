#!/bin/bash

# Dependencies:
#  - "scripts/bash/common.sh"

# Searches for a package, with pacaur.
# Arguments:
#  - The database to search in. Valid choices are "local" and "sync".
#  - The name of the package to search for.
search_for_package()
{
  DATABASE=$1
  PACKAGE_NAME=$2

  case $DATABASE in
    "local")
    # Only list explicitly installed packages.
    LIST=$(pacaur -Qs "$PACKAGE_NAME")
    ;;
    "sync")
    LIST=$(pacaur -Ss "$PACKAGE_NAME")
    ;;
    *)
    return 2
    ;;
  esac

  PACKAGE_SEARCH_RESULT=$?
  if [ $PACKAGE_SEARCH_RESULT -eq 0 ]; then
    declare -A REPOSITORY_HIGHLIGHTING=(["local"]="$CYAN"
                                        ["core"]="$RED"
                                        ["extra"]="$GREEN"
                                        ["testing"]="$RED$REVERSE"
                                        ["community"]="$YELLOW"
                                        ["community-testing"]="$YELLOW$REVERSE"
                                        ["multilib"]="$BLUE"
                                        ["multilib-testing"]="$BLUE$REVERSE"
                                        ["aur"]="$MAGENTA"
                                        # MEGA repo.
                                        ["DEB_Arch_Extra"]="$RED"
                                        # Sublime Text repo
                                        ["sublime-text"]="$YELLOW")

    for REPOSITORY in "${!REPOSITORY_HIGHLIGHTING[@]}"; do
      # Run the list through sed, applying color codes to package names.
      # The regex captures 4 groups from each line of pacaur's tooutput:
      #  - The repository. Ex. 'core'.
      #  - The forward slash separating the repo from the package. Ex. '/'.
      #  - The first character of the package name. Ex. '+'.
      #  - The rest of the characters of the package name. Ex. '-'.
      # In compliance with the PKGBUILD specification (https://wiki.archlinux.org/index.php/PKGBUILD#pkgname),
      # the first char of the package name is more restricted, and cannot have a '-'.
      LIST=$(echo "$LIST" | sed -r -e \
"s!\
^($REPOSITORY)(\/)(\+|[0-9]|@|_|[A-Z]|[a-z]|\d)((\+|-|\.|[0-9]|@|_|[A-Z]|[a-z])+)!\
${REPOSITORY_HIGHLIGHTING[$REPOSITORY]}${UNDERLINE}\1${NORMAL}\2${WHITE}\3\4${NORMAL}!\
gm")
    done

    echo "$LIST"
    # Package found.
    return 0
  elif [ $PACKAGE_SEARCH_RESULT -eq 1 ]; then
    # Package not found.
    return 1
  else
    # Unknown error.
    return 2
  fi
}

# Search for and install a package.
# Arguments:
#  - The name of the package to search for and install.
blinky()
{
  PACKAGE_NAME=$1

  info "Searching for package \"$PACKAGE_NAME\" in the sync database."
  LIST=$(search_for_package sync "$PACKAGE_NAME")
  PACKAGE_SEARCH_RESULT=$?
  if [ $PACKAGE_SEARCH_RESULT -eq 0 ]; then
    info "Package(s) found:"
    echo "$LIST"
    read -r -p "Which package(s) would you like to install? " INSTALL_PACKAGE_NAME
    pacaur -S "$INSTALL_PACKAGE_NAME"
    return 0
  elif [ $PACKAGE_SEARCH_RESULT -eq 1 ]; then
    error "Package not found. Exiting."
    return 1
  else
    error "An unknown error occured. Exiting."
    return 2
  fi
}
# Search for a package.
# Arguments:
#  - The name of the package to search for.
pinky()
{
  PACKAGE_NAME=$1

  info "Searching for package \"$PACKAGE_NAME\" in the sync database."
  LIST=$(search_for_package sync "$PACKAGE_NAME")
  PACKAGE_SEARCH_RESULT=$?
  if [ $PACKAGE_SEARCH_RESULT -eq 0 ]; then
    info "Package(s) found:"
    echo "$LIST"
    return 0
  elif [ $PACKAGE_SEARCH_RESULT -eq 1 ]; then
    error "Package not found."
    return 1
  else
    error "An unknown error occured."
    return 2
  fi
}
# Searches for and removes a package.
# Arguments:
#  - The name of the package to search for and install.
inky()
{
  PACKAGE_NAME=$1

  info "Searching for package \"$PACKAGE_NAME\" in the local database."
  LIST=$(search_for_package local "$PACKAGE_NAME")
  PACKAGE_SEARCH_RESULT=$?
  if [ $PACKAGE_SEARCH_RESULT -eq 0 ]; then
    info "Package(s) found:"
    echo "$LIST"
    read -r -p "Which package(s) would you like to remove? " REMOVE_PACKAGE_NAME
    pacaur -Rs "$REMOVE_PACKAGE_NAME"
    return 0
  elif [ $PACKAGE_SEARCH_RESULT -eq 1 ]; then
    error "Package not found."
    return 1
  else
    error "An unknown error occured."
    return 2
  fi
}
# Update the system.
clyde()
{
  info "Updating system."
  pacaur -Syu --devel
}
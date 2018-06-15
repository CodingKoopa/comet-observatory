#!/bin/bash

####################################################################################################
### State Variables
####################################################################################################
export DEBUG=false

####################################################################################################
### Color Variables
####################################################################################################

# Only define these once per source.
NORMAL="$(tput sgr0)"
readonly NORMAL
BLACK=$(tput setaf 0)
readonly BLACK
RED=$(tput setaf 1)
readonly RED
GREEN=$(tput setaf 2)
readonly GREEN
YELLOW=$(tput setaf 3)
readonly YELLOW
BLUE="$(tput setaf 4)"
readonly BLUE
MAGENTA=$(tput setaf 5)
readonly MAGENTA
CYAN=$(tput setaf 6)
readonly CYAN
WHITE=$(tput setaf 7)
readonly WHITE
REVERSE=$(tput smso)
readonly REVERSE
UNDERLINE=$(tput smul)
readonly UNDERLINE


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

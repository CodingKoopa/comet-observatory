#!/bin/bash

# Only define these once per source.
NORMAL=$(tput sgr0)
# shellcheck disable=SC2034
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
# shellcheck disable=SC2034
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
# shellcheck disable=SC2034
MAGENTA=$(tput setaf 5)
# shellcheck disable=SC2034
CYAN=$(tput setaf 6)
# shellcheck disable=SC2034
WHITE=$(tput setaf 7)
# shellcheck disable=SC2034
REVERSE=$(tput smso)
# shellcheck disable=SC2034
UNDERLINE=$(tput smul)

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

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

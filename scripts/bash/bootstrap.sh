#!/bin/bash

# Dependencies:
#  - "$DOTFILES/scripts/bash/common.sh"
#  - "$DOTFILES/scripts/bash/config.sh"

# Refresh the dotfiles.
r()
{
  # shellcheck source=.bashrc
  source "$HOME/.bashrc"
}

# Loads all of the scripts, should be placed in the BashRC.
bootstrap()
{
  # info is needed right off the bat.
  source "$DOTFILES/scripts/bash/common.sh"
  info "Koopa's Dotfiles Bootstrap starting up."

  info "Adding binaries to path."
  ERROR_OCCURED=false

  for DIRECTORY in "$DOTFILES"scripts/*/; do
    info "Reading script category \"$DIRECTORY\"."
    for SCRIPT in "$DIRECTORY"*sh; do
      if [[ ! "$SCRIPT" = *.template.sh* ]]; then
        info "Sourcing script \"$SCRIPT\"."
        # shellcheck source=/dev/null
        source $SCRIPT
        if [ $? -ne 0 ]; then
          ERROR_OCCURED=true
        fi
      fi
    done
  done

  info "Startup completed."
  if $ERROR_OCCURED; then
    info "Not clearing screen because one or more errors have occured."
  else
    # Terminal escape code to clear screen, because clear doesn't work.
    info "\033cThe dotfiles are up and running 👌"
  fi
}

#!/bin/bash

# Dependencies:
#  - "scripts/bash/common.sh"

# Update the synced public and private keys with the local ones.
update_keys()
{
  info "Updating synced GnuPGP keys to local keys."
  gpg -ao "$HOME/Documents/Private/GnuPG/Private Key.key" --export-secret-keys "<thekoopakingdom@gmail.com>"
  gpg -ao "$HOME/Documents/Private/GnuPG/Public Key.key" --export "<thekoopakingdom@gmail.com>"
  gpg --export-ownertrust > "$HOME/Documents/Private/GnuPG/Owner Trust.txt"
}
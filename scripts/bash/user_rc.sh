#!/bin/bash

# This script sets environment variables for all user applications. See /docs/Init.md.

# Editor Preferences

# Set the preferred editor to nano.
export EDITOR=nano
# Set the preferred diff viewer to the preferred editor.
export DIFFPROG=$EDITOR

# Paths

# Set the PATH to prefer ccache binaries, prefer user binaries, and include CO binaries.
export PATH=/usr/lib/ccache/bin/:$HOME/.local/bin/:$PATH:$CO/bin
# Set the path to the GnuPG home directory. Keep this in sync with export_constants().
export GNUPGHOME=$HOME/.local/share/gnupg
# Point asdf-vm away from `~/.asdfrc`.
export ASDF_CONFIG_FILE=/opt/co/config/asdf.conf
# Point asdf-vm away from `~/.asdf`.
export ASDF_DATA_DIR=$HOME/.local/share/asdf
# Use XDG directories for OCaml's `opam``.
export OPAMROOT=$HOME/.local/share/opam

# Authentication

# Set the SSH authentication socket to defer to the GPG agent.
export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/gnupg/d.sain89k17bnepd3ojwki9xob/S.gpg-agent.ssh

# Runtimes

# Enable Docker BuildKit
export DOCKER_BUILDKIT=1
# Disable .NET Core Telemetry.
export DOTNET_CLI_TELEMETRY_OPTOUT=1
# Enable Wine esync.
export WINEESYNC=1
# Enable Wine fsync.
export WINEFSYNC=1

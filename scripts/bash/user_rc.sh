#!/bin/bash

# This script sets environment variables for all user applications. See /docs/Init.md.

# Editor Preferences

# Set the preferred editor to nano.
export EDITOR=nano
# Set the preferred diff viewer to the preferred editor.
export DIFFPROG=$EDITOR
# Set the preferred SSH askpass program to ksshaskpass.
export SSH_ASKPASS=/usr/bin/ksshaskpass

# Paths

# Set the path to the Comet Observatory.
export CO=$HOME/Documents/Projects/Bash/comet-observatory
# Set the PATH to prefer ccache binaries, prefer user binaries, and include CO binaries.
export PATH=/usr/lib/ccache/bin/:$HOME/.local/bin/:$PATH:$CO/bin

# Authentication

# Set the SSH authentication socket to the socket that the SSH agent systemd user service is
# configured to use.
export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent.socket

# Runtimes

# Enable Docker BuildKit
export DOCKER_BUILDKIT=1
# Disable .NET Core Telemetry.
export DOTNET_CLI_TELEMETRY_OPTOUT=1
# Enable Wine esync.
export WINEESYNC=1
# Enable Wine fsync.
export WINEFSYNC=1

# Graphics Drivers (May be applicable even without X running)

# Override the driver for VA-API.
export LIBVA_DRIVER_NAME=vdpau
# Override the driver for VDPAU.
export VDPAU_DRIVER=nvidia

#!/bin/bash

# Copyright 2019 Comet Observatory
# Licensed under GPLv3.
# Refer to License.txt file included.

# shellcheck source=scripts/bash/common.sh
source "$CO"/scripts/bash/common.sh

# Installs VSCode extensions from a hardcoded list.
# Outputs:
#   - VSCode installation progress
function install_vscode_extensions() {
  local -ra EXTENSIONS=(
    tamasfe.even-better-toml
    Catppuccin.catppuccin-vsc
    dbaeumer.vscode-eslint
    EditorConfig.EditorConfig
    esbenp.prettier-vscode
    exiasr.hadolint
    foxundermoon.shell-format
    intellsmi.comment-translate
    James-Yu.latex-workshop
    mikestead.dotenv
    mrmlnc.vscode-csscomb
    ms-azuretools.vscode-docker
    ms-python.python
    ms-vscode.cmake-tools
    ms-vscode.cpptools
    ms-vscode.makefile-tools
    redhat.vscode-yaml
    timonwong.shellcheck
    twxs.cmake
    xdebug.php-pack
    yzhang.markdown-all-in-one
  )
  local -r installed_extensions=$(code --list-extensions)
  for extension in "${EXTENSIONS[@]}"; do
    if [[ $installed_extensions != *$extension* ]]; then
      info "Installing extension $extension."
      [[ $DRY_RUN = false ]] && code --install-extension "$extension"
    else
      verbose "Extension $extension is already installed."
    fi
  done
}

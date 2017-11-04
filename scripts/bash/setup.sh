#!/bin/bash

# Dependencies:
#  - "scripts/bash/common.sh"

setup()
{
  info "Making links from home folder downloads and music to external hard drive."
  ln -s ~/External/Downloads/ ~/Downloads
  ln -s ~/External/Music/ ~/Music
}

#!/bin/bash

# This is for the VS extention, to allow following file paths, because the extention doesn't have
# an option for doing so. Allow any other parameters to fall through.
shellcheck -x "$@"
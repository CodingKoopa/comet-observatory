#!/bin/bash

# Set the path to the Comet Observatory.
export CO=/home/koopa/Documents/Projects/Bash/comet-observatory

if [[ ! -d $CO ]]; then
  printf 'Error: CO doesn'\''t exist at "%s". Expect dragons.' $CO >&2
fi

# Set the host.
product_version=$(cat /sys/devices/virtual/dmi/id/product_version)
readonly product_version
if [[ $product_version = *P500* ]]; then
  export CO_HOST=LAPTOP_P500
else
  export CO_HOST=DESKTOP
fi

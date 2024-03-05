#!/bin/bash

# Set the path to the Comet Observatory.
export CO=/opt/co

if [[ ! -d $CO ]]; then
  printf 'Error: CO doesn'\''t exist at "%s". Expect dragons.' $CO >&2
fi

# Set the host.
if [[ $(cat /sys/devices/virtual/dmi/id/board_vendor) = Framework ]]; then
  export CO_HOST=LAPTOP_FRAMEWORK
elif [[ $(cat /sys/devices/virtual/dmi/id/product_version) = *P500* ]]; then
  export CO_HOST=LAPTOP_P500
else
  export CO_HOST=DESKTOP
fi

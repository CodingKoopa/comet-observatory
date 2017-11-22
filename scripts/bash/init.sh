#!/bin/bash

# Dependencies:
#  - "scripts/bash/common.sh"
#  - "scripts/pacaur/ghosts.sh"

# Links one file to another and resolves conflicts.
# Arguments:
#  - The destination.
#  - The name.

# TODO: Proper documentation, use info().

setup_monitors_normal()
{
  printf "Making sure laptop screen is off...\n"
  xrandr --output LVDS-1 --off
  printf "Success. \n"
  printf "Making sure Dell monitor is on...\n"
  if ! xrandr --output HDMI-1 --mode 1920x1080 ; then
    return 1
  fi
  printf "Success. \n"
  printf "Making sure Sharp TV is on...\n"
  if ! xrandr --output VGA-1 --mode 1368x768 --pos 1920x312 ; then
    return 1
  fi
  printf "Success. \n"
  return 0
}

setup_monitors_backup()
{
  printf "Making sure laptop screen is on...\n"
  xrandr --output LVDS-1 --mode 1366x768
  printf "Success. \n"
  printf "Making sure Dell monitor is off...\n"
  if ! xrandr --output HDMI-1 --off; then
    return 1
  fi
  printf "Success.\n"
  printf "Making sure Sharp TV is off...\n"
  if ! xrandr --output VGA-1 --off; then
    return 1
  fi
  printf "Success.\n"
  return 0
}

init()
{
  printf "Sup.\n"

  if ! setup_monitors_normal; then
    printf "Something went wrong. Proceeding to backup procedure.\n"
    if ! setup_monitors_backup; then
      printf "The backup procedure failed. Welp, good luck lmao.\n"
    fi
  fi

  printf "Making sure Discord is minimized..."
  # TODO: i isn't used here.
  for i in {0..3}; do
    xdotool search --sync --onlyvisible --classname "Discord" windowminimize %@
    sleep 1
  done
  printf "Success. \n"
  clyde
  printf "Ready to go! \n"
}

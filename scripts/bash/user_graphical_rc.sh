#!/bin/bash

# This script sets environment variables for all graphical user applications. See /docs/Init.md.

# Desktop Environment

# Set the desktop session variable, in case we aren't starting X at login but rather manually.
export DESKTOP_SESSION=plasma
# Set the desktop environment variable for xdg-open integration.
#export DE=kde
# Use the XDG portal for GTK applications.
export GTK_USE_PORTAL=1
# Use the fcitx input method for Qt applications.
export QT_IM_MODULE=fcitx
# Use the fcitx input method for GTK applications.
export GTK_IM_MODULE=fcitx
# Use the fcitx input method for certain SDL2 applications.
export SDL_IM_MODULE=fcitx
# Use the fcitx input method for XIM.
export XMODIFIERS=@im=fcitx

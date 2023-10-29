#!/bin/bash

# This script sets environment variables for all graphical user applications. See /docs/Init.md.

# Desktop Environment

# Pretend we are KDE, for now.
export XDG_CURRENT_DESKTOP=KDE
# Make xdg-open believe us.
export KDE_SESSION_VERSION=5
# Set the desktop session variable, in case we aren't starting X at login but rather manually.
export DESKTOP_SESSION=plasma
# Set the desktop environment variable for xdg-open integration.
#export DE=kde
# Set the user Compose file path.
export XCOMPOSEFILE=$CO/config/compose-keys.conf
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
# We are using a non-reparenting WM.
export _JAVA_AWT_WM_NONREPARENTING=1
# Force anti-aliasing in Java (necessary for JFLAP).
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on'

#!/bin/bash

# Base system.
base

# Hardware

# Firmware files.
linux-firmware
# efibootmgr, for managing UEFI entries.
efibootmgr
# Linux kernel, for doing stuff.
linux
# Linux kernel headers, for compiling kernel modules.
linux-headers
# mkinitcpio numlock hook, for turning on numlock.
mkinitcpio-numlock
# PulseAudio, for audio support.
pulseaudio
# PulseAudio ALSA, for ALSA support in PA.
pulseaudio-alsa
# PulseAudio Bluetooth modules.
pulseaudio-bluetooth
# PipeWire stuff:
# pipewire
# pipewire-pulse
# pipewire-jack
# pipewire-jack-dropin
# qjackctl
# Ext2/3/4 filesystem utilities, for Ext4 support.
e2fsprogs
# NTFS filesystem utilities, for NTFS support.
ntfs-3g
# DOS filesystem utilities, for FAT32 support.
dosfstools
# SSHFS, for remote filesystem support. This is used by KDE Connect.
sshfs
# scrcpy, for phone mirroring.
scrcpy
# ncdu, for managing disk usage.
ncdu
# Plasma Disks, for montoring drive health.
plasma-disks
# f3, for error checking filesystems.
#f3
# Nintendo Switch udev rules, for not requiring root for access.
nx-udev
# bluez, for the Bluetooth stack.
bluez
# CUPS, for printing support.
cups
# Canon Pixma TR7500 series drivers, for home printer support.
canon-pixma-lt7500-complete
# GfxTablet, for using an Android tablet as a drawing tablet.
# gfxtablet-git

# Disc Drive Emulation

# VHBA module, for disk drive support.
# vhba-module-dkms
# CDEmu daemon, for emulating drives.
# cdemu-daemon
# KDE CDEmu manager, for emulating drives.
# kde-cdemu-manager-kf5

# Hardware Management

# plasma-pa, for volume slider.
plasma-pa
# pavucontrol, for managing audio. This is more flexible than plasma-pa.
pavucontrol
# KDE Partition Manager, for managing filesystems.
partitionmanager
# Plasma NetworkManager, for managing network connections.
plasma-nm
# Nintendo Switch USB loader, for managing game and NAND backups.
# ns-usbloader
# print-manager, for managing printers.
print-manager
# system-config-printer, for automatically detecting printer drivers.
system-config-printer
# Bluedevil, for managing bluetooth.
bluedevil

# Package Management

# expac, for list of packages in "base".
expac
# pikaur, for managing AUR packages.
pikaur
# Chaotic-AUR keyring, for using Chaotic-AUR.
chaotic-keyring
# Chaotic-AUR mirrorlist, for using Chaotic-AUR.
chaotic-mirrorlist
# Pacman contributed scripts, for paccache, for cleaning the package cache.
pacman-contrib
# Reflector, for updating pacman mirrors.
reflector
# pkgstats, for submitting package statistics.
pkgstats

# Wine Mono, for .NET support in Wine.
wine-mono
# Wine Gecko, for browser support in Wine.
wine-gecko
# Winetricks, for managing Wine.
winetricks
# OpenJDK JRE, for running Java applications.
jre-openjdk

# Service Hosting

# Docker, for hosting containerized services.
# docker
# Docker Compose, for controlling Docker.
# docker-compose
# Apache, for hosting HTTP services.
# apache

# CLI Utilities

# neofetch, for obtaining system info.
neofetch
# LSDeluxe, for listing directories.
lsd
# tree, for listing directories.
# tree
# nano, for editing text.
nano
# figlet, for making ASCII figures.
figlet
# lolcat, for making rainbow text.
lolcat

# Desktop Environment

# xinit, for logging in.
xorg-xinit
xorg-server
# xsel, for clipboard support for tag_mp3.sh.
xsel
# Plasma Desktop, for Plasma Shell.
plasma-desktop
# Plasma Addons, for improving Plasma Shell.
kdeplasma-addons
# khotkeys, for custom keyboard shortcuts.
khotkeys
# fcitx5 input method, for inputting characters. This is the "fcitx5-im" group, expanded.
fcitx5
fcitx5-configtool
fcitx5-gtk
fcitx5-qt
# xdg-desktop-portal, for interfacing with containment frameworks.
xdg-desktop-portal
# xdg-desktop-portal-kde, a Qt/KF5 backend for xdg-desktop-portal.
xdg-desktop-portal-kde
# KDE GTK config, for customizing GTK applications.
kde-gtk-config
# Plasma Browser Integration, for integrating browsers with Plasma.
plasma-browser-integration
# KDEConnect, for integrating the desktop with Android.
kdeconnect
# RSIBreak, for taking breaks.
rsibreak

# Graphical Resources

# Noto fonts, for most applications.
noto-fonts
# Liberation fonts, for websites that ask for it.
ttf-liberation
# Microsoft fonts, for making spicy impact font memes.
ttf-ms-fonts
# Chinese/Japanese/Korean Noto fonts, for foreign text.
noto-fonts-cjk
# Emoji Noto fonts, for emoji.
noto-fonts-emoji
# Extra Noto fonts, for monospaced text.
noto-fonts-extra
# Fira Code font patched with additional symbols, for terminals and code editors.
nerd-fonts-fira-code
# Breeze GTK theme, for GTK applications to look nice.
breeze-gtk
# GNOME icon theme, for when applications ask about it.
gnome-icon-theme
# GNOME themes, for when applications ask about it (this seems to provide Adwaita).
gnome-themes-extra

# Desktop Utilities

# Dolphin, for managing files.
dolphin
# kdegraphics-thumbnailers, for image/PDF thumbnail support in Dolphin.
kdegraphics-thumbnailers
# ffmpegthumbs, for video thumbnail support in Dolphin.
ffmpegthumbs
# MEGASync, for managing files with MEGA.
megasync
# Ark, for managing archives.
ark
# p7zip, for ZIP and 7z support in Ark.
p7zip
# unrar, for RAR support in Ark.
unrar
# Spectacle, for taking screenshots.
spectacle
# Konsole, for using the terminal.
konsole
# Plasma System Monitor, for monitoring the system.
plasma-systemmonitor

# Authentication (See /docs/Auth.md)

# KWallet, for storing passwords.
kwallet
# KWalletManager, for managing system passwords.
kwalletmanager
# kwalletcli, for using KWallet for GPG key passwords. Currently not in use.
# kwalletcli
# Ksshaskpass, for Using KWallet for SSH key passwords.
ksshaskpass
# KeepassXC, for managing all passwords.
keepassxc

# Media

# Gwenview, for viewing images.
gwenview
# GIMP, for editing images.
gimp
# ImageMagick, for editing images.
imagemagick
# eyed3, for tagging audio.
python-eyed3
# Clementine, for playing audio.
clementine
# youtube-dl, for downloading media.
youtube-dl
# mpv Git, for playing media.
mpv
mpv-mpris
# OBS Studio, for recording media.
obs-studio
# Kdenlive, for editing media.
kdenlive
# Linux-Fake-Background-Webcam
# linux-fake-background-webcam-opt-git
# Blender, for editing 3D models.
# blender

# Internet

# Firefox, for browsing the web.
firefox
# Google Chrome, for browsing the internet.
google-chrome
# Discord with native Electron, for messaging.
discord_arch_electron
# Konversation, for messaging.
konversation
# OpenSSH, for connecting to other computers.
openssh
# Transmission (Qt interface), for downloading files from other computers.
transmission-qt

# Gaming

# GameMode, for improving performance.
gamemode
# GameMode 32-bit.
lib32-gamemode
# Steam, for managing games.
steam
# protontricks, for managing Proton prefixes.
# protontricks-git
# Minecraft Launcher, for launching Minecraft.
minecraft-launcher
# MultiMC5, for launching Minecraft but not suck at it.
multimc5-bin

# Programming (Editors/IDEs, Compilers/Interpreters, Linters, Build Systems, Libraries)

# base-devel packages, for development.
base-devel
# Git, for version control.
git
# Visual Studio Code, for editing code.
code
# VSCode Marketplace Hook, for having extensions.
code-marketplace
# Eclipse common files.
# eclipse-common
# Eclipse IDE for Java Developers, for developing Java applications.
# eclipse-java
# OpenJDK JDK docs, for writing Java applications.
# openjdk-doc
# Android Studio, for developing Android applications, and for adb.
# android-studio
# ShellCheck, for Bash linting. This is the statically compiled version without the Haskell
# dependencies.
shellcheck-bin
# shfmt, for Bash formatting.
shfmt
# namcap, for PKGBUILD linting.
# namcap
# GCC 7, for Cuda and cuDNN.
# gcc7
# GCC 7 libraries, for GCC 7.
# gcc7-libs
# Cmake, for building projects.
cmake
# Ninja, for building projects.
# ninja
# Gradle, for building projects.
# gradle
# npm, for managing Node.JS packages.
# npm
# npm-check-updates, for upgrading packages.
# npm-check-updates
# Gulp.js, for building websites.
# gulp
# Hugo, for building websites.
# hugo
# OpenJDK JDK, for compiling Java applications.
# jdk-openjdk
# ccache, for compiling code faster.
ccache
# GDB, for debugging code.
gdb
# Doxygen, for building documentation.
# doxygen
# TeX Live core, for building LaTeX documents.
# texlive-core
# TeX Live LaTeX extras.
# texlive-latexextra
# Packages necessary for using latex-indent. Workaround for: https://bugs.archlinux.org/task/60210.
# texlive-latexindent-meta
# TeX Live science, for the siunitx package.
# texlive-science

# Programming Libraries

# SDL2 32-bit, for OpenLoco.
# lib32-sdl2
# SDL2 mixer 32-bit, for OpenLoco.
# lib32-sdl2_mixer
# yaml-cpp 32-bit, for OpenLoco.
# lib32-yaml-cpp
# Bullet, for donut.
# bullet

# Modding

# Okteta, for editing data.
okteta
# 3dstool, for managing 3DS ROMs.
# 3dstool
# ctrtool, for managing 3DS ROMs.
# ctrtool-git
# firmtool, for managing 3DS firmware.
# firmtool-git
# hactool, for managing Switch ROMs.
# hactool

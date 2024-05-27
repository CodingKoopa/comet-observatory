#!/bin/bash

# Boot

# efibootmgr, for managing UEFI entries.
efibootmgr
# Linux kernel.
linux-zen
# Firmware files.
linux-firmware
# Linux kernel headers for compiling kernel modules.
linux-zen-headers
# Base system.
base
# mkinitcpio hook to turn on numlock.
mkinitcpio-numlock

# Graphics

# Vulkan ICD loader, for initializing Vulkan.
vulkan-icd-loader
lib32-vulkan-icd-loader
# GPU usage monitor.
nvtop
# For OpenGL checker (eglinfo).
mesa-utils
# For Vulkan checker (vulkaninfo).
vulkan-tools
# VA-API checker.
libva-utils
# VDPAU checker.
vdpauinfo

# Audio

# Audio + video server, including native PW client support.
pipewire
lib32-pipewire
# PW session manager.
wireplumber
# PulseAudio client support for PW.
pipewire-pulse
# ALSA client support for PW.
pipewire-alsa

# Filesystems

# FUSE-based VFS interface (not to be confused w/ the kernel VFS).
# Provides access in file manager to:
# - Removable storage via UDisks daemon.
# - Trash protocol.
gvfs
# MTP protocol backend for GVFS.
gvfs-mtp
# Samba protocol backend for GVFS.
gvfs-smb
# Remote filesystem support.
sshfs
# NTFS support + tools.
ntfs-3g
# VHBA module, for emulated disk drive support.
# vhba-module-dkms
# CDEmu daemon, for emulating drives.
# cdemu-daemon

# Filesystem Tools

# btrfs tools.
btrfs-progs
# Ext2/3/4 tools.
e2fsprogs
# FAT32 tools.
dosfstools
# Filesystem error checker.
f3
# Interactive disk usage checker.
ncdu
# File handle checker.
lsof

# Wireless

# Lower-level wireless utility.
iw
# Wireless regulatory database.
wireless-regdb
# Network service.
networkmanager
# mDNS (+ DNS-SD) service discovery.
avahi
# Support for hostname resolution via mDNS in glibc.
nss-mdns
# Bluetooth service.
bluez
# Bluetooth tools.
bluez-utils

# Other Devices

# USB utilities (such as lsusb).
usbutils
# evdev tester.
evtest
# Razer peripheral driver.
openrazer-daemon
# Print service.
cups
# PDF renderer (for CUPS).
ghostscript
# Nintendo Switch udev rules, for not requiring root for access.
nx-udev
# GfxTablet, for using an Android tablet as a drawing tablet.
# gfxtablet-git
# scrcpy, for phone mirroring.
scrcpy

# Package Management

# AUR manager.
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

# CLI Utilities

# Privilege escalation tool.
sudo
# System manuals.
man-db
man-pages
# bash-completion, for programs to provide auto-completion within Bash.
bash-completion
# System info tool.
fastfetch
# Pager.
less
# Simple terminal text editor.
nano
# Asymmetric cryptography tool.
gnupg
# ZIP + 7z extraction/creation.
p7zip
# RAR extraction.
unrar

# Desktop Environment

# Compositor.
hyprland
# Idle daemon.
hypridle
# Screen locker.
hyprlock
# Notification daemon.
rofi-lbonn-wayland-git
# Bar.
waybar
# Background image.
swaybg
# Screenshot utility.
hyprshot
# Xwayland support.
xorg-xwayland
# Xwayland detector.
xorg-xeyes
# Key tester.
wev

# Desktop Environment Integration

# Privilege escalation for GUI programs.
lxqt-policykit
# Wayland support for Qt.
qt5-wayland
qt6-wayland
# XDG Desktop Portal interface.
xdg-desktop-portal
xdg-desktop-portal-hyprland

# Desktop Resources

# English dictionary
hunspell-en_us
# Noto fonts, for most applications.
noto-fonts
# Chinese/Japanese/Korean Noto fonts, for foreign text.
noto-fonts-cjk
# Emoji Noto fonts, for emoji.
noto-fonts-emoji
# Extra Noto fonts, for monospaced text.
noto-fonts-extra
# FontAwesome icons.
otf-font-awesome

# Desktop Utilities

# Removable storage GUI.
udiskie
# Volume control GUI.
pavucontrol-qt
# Patchbay GUI.
qpwgraph
# Bluetooth GUI.
blueman
# Network GUI.
network-manager-applet
# Printer GUI.
system-config-printer
# GTK appearance settings GUI.
nwg-look
# Qt appearance settings GUI.
qt6ct
# Display settings CLI.
wlr-randr
# Display settings GUI.
nwg-displays
# Terminal.
kitty
# File manager.
pcmanfm-qt
# Video thumbnail support for file manager.
ffmpegthumbnailer
# File archiver.
lxqt-archiver
# Image viewer.
imv
# RSI prevention.
# TODO: fix me
safeeyes
# For Do Not Disturb support in safeeyes.
wlrctl
# Razer peripheral GUI.
polychromatic
# Password manager.
keepassxc

# Multimedia

# Document viewer + PDF thumbnail support for file manager.
evince
# Note app.
xournalpp
# Video player.
mpv
# MPRIS integration for mpv.
mpv-mpris
# Watch party integration for mpv.
syncplay-git
pyside6
# Media manipulator CLI.
ffmpeg
# Video downloader.
yt-dlp
# Image manipulator CLI.
imagemagick
# Image editor GUI.
gimp
# Vector image editor.
inkscape
# Video recorder.
obs-studio
# Fake webcam module.
v4l2loopback-dkms

# Internet

# Remote shell.
openssh
# Simple file synchronization.
rsync
# Two-way file synchronization.
syncthing
# VPN.
tailscale
# Also VPN.
openconnect
# Web browser. The developer edition is blue and cute :3
firefox-developer-edition
# Spyware web browser.
google-chrome
# Anonymous web browser (for scene things).
torbrowser-launcher
# Email client
thunderbird
# Instant messenger.
discord
# Instant messenger.
telegram-desktop
# Video conference app.
zoom
# Torrent client.
qbittorrent

# Gaming

# GameMode, for improving performance.
gamemode
# GameMode 32-bit.
lib32-gamemode
# Game manager.
steam
# Game manager.
lutris
# protontricks, for managing Proton prefixes.
protontricks
# Minecraft launcher.
prismlauncher

# Programming

# Basic dev packages.
base-devel
# LLVM compiler infrastructure.
clang
lld
llvm
# Caching compiler wrapper.
ccache
# Build system.
cmake
# Build system.
ninja
# Version control system.
git
# Code editor.
code
# VSCode Marketplace Hook, for having extensions.
code-marketplace

# Lower-level Tools

# Debugger.
gdb
# Hex editor.
imhex
# Reverse engineer suite.
ghidra
# Network mapper.
nmap

# Runtime + Runtime Tools

# Tool version manager.
asdf-vm
# Containerization service.
docker
# Docker manager.
docker-compose
# Windows translation layer.
wine
# Adds Mono's .NET implementation to Wine.
wine-mono
# Manages Wine.
winetricks
# Java runtime.
jdk-openjdk

# Specific Runtime + Language Tools

# Bash linter. This is the statically compiled version without the Haskell dependencies.
shellcheck-bin
# shfmt, for Bash formatting.
shfmt
# PKGBUILD linter.
namcap
# Dockerfile linter.
hadolint-bin
# JavaScript runtime.
nodejs
# Node.JS package manager.
pnpm
# PHP runtime.
php
# PHP package manager.
composer

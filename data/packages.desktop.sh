#!/bin/bash

# Hardware

# AMD Microcode, for CPU patches.
amd-ucode
# Nvidia graphics drivers, for seeing stuff.
nvidia
# Nvidia settings, for configuring the output.
nvidia-settings
# Nvidia driver utilities (includes Vulkan support)
nvidia-utils
# 32-bit Nvidia driver utilities.
lib32-nvidia-utils
# nvme-cli, for managing NVMe devices.
# nvme-cli
# xboxdrv, for ninja360. TODO: make an AUR package for that, and get this out of here!
xboxdrv

# Runtimes, Virtualization

# QEMU, for virtualization.
qemu-base
# UEFI firmware for QEMU.
edk2-ovmf
# spicy, for viewing virtual machines.
spice-gtk

# Media

# Kdenlive, for editing media.
kdenlive

# Gaming

# MangoHUD
mangohud
# MangoHUD 32-bit library.
lib32-mangohud
# libxnvctrl, for MangoHUD.
lib32-libxnvctrl
# Lucas' Simpsons Hit & Run Mod Launcher, for playing mods.
lucas-simpsons-hit-and-run-mod-launcher
# xdelta3, for patching games.
# xdelta3
# mGBA, for playing GBA games.
mgba-qt
# melonds, for playing DS games.
melonds
# Dolphin, for playing Wii and Gamecube games.
dolphin-emu
# Citra, for playing 3DS games.
citra-canary-git
# yuzu, for playing Switch games.
yuzu-mainline-git

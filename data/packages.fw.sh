#!/bin/bash

# Boot

# AMD Microcode, for CPU patches.
amd-ucode

# Graphics

# User-space graphics driver components.
mesa
# Vulkan ICD.
vulkan-radeon
# VA-API video acceleration.
libva-mesa-driver
# VDPAU video acceleration.
mesa-vdpau

# Other Devices

# Brightness adjuster.
brightnessctl
# Fingerprint reader.
fprintd


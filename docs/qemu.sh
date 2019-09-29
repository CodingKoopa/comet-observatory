#!/bin/bash

echo "This is not meant to be ran as a script!"
exit 0

# Create a new disk to install to:
qemu-img create -f qcow2 debian-base.img 15G
# The qcow2 format allows zlib file compression (As opposed to the file "compression" of a raw disk
# with "holes", only writing used parts to the disk.), as well as snapshots. It's the format for
# QEMU, but can be exported with the qemu-nbd tool, or converted with qemu-img convert. The
# tradeoff of using this format is that it's less performant than the raw disk image.

qemu-system-x86_64 -machine pc,accel=kvm -cpu host -m 512M debian-9.9.0-amd64-xfce-CD-1.iso --enable-kvm
# This command specifies the installation media as the main raw hard disk image, but QEMU always
# complains about the format for it not being specified. I'm not really sure how I would
# specify the installer though.

# Final command for installing Debian:
qemu-system-x86_64 -machine pc,accel=kvm -cpu host -boot d -m 2G -hda debian-base.img -cdrom debian-9.9.0-amd64-xfce-CD-1.iso --enable-kvm

# Making a disk to record changes made to the base:
qemu-img create -f qcow2 -b debian-base.img debian-main.img 15G

# Making a bridge connection:
nmcli c add type bridge ifname br0 con-name "QEMU Bridge" stp no
nmcli c add type bridge-slave ifname wlp37s0 con-name "Main Wireless Slave" master br0
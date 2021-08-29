#!/bin/bash

# Copyright 2019 Comet Observatory
# Licensed under GPLv3.
# Refer to License.txt file included.

set -e

# shellcheck source=scripts/bash/common.sh
source "$CO"/scripts/bash/common.sh

# Finds the bootnum from the name of a boot entry.
# Arguments:
#   - The name of the boot entry to find.
# Outputs:
#   The bootnum of the found boot entries, or nothing if none is found.
function find_bootnum() {
  # Escapes a string for usage in a sed pattern. Sed expression copied from
  # https://stackoverflow.com/a/2705678.
  # Arguments:
  #   - The string to escape.
  # Outputs:
  #   The escaped string.
  function sed_escape_pattern() {
    if [[ $# -ge 1 ]]; then
      # shellcheck disable=SC1003
      printf '%s\n' "$1" | sed 's/[]\\'"${2:-/}"'$*.^[]/\\&/g'
    else
      sed 's/[]\\/$*.^[]/\\&/g'
    fi
  }

  efibootmgr | sed -n '{0,/^Boot\([0-9A-Fa-f]\{4\}\)\*\? '"$(sed_escape_pattern "$1")"'$/s//\1/p}'
}

# Removes a boot entry if it exists.
# Arguments:
#   - The label of the boot entry.
# Outputs:
#   Deletion message.
function remove_entry_if_existing() {
  local -r label=$1

  bootnum="$(find_bootnum "$label")"
  if [[ -n "$bootnum" ]]; then
    info "Existing boot entry for \"$label\" found, deleting."
    efibootmgr -q -b "$bootnum" -B
  fi
}

# Adds a UEFI boot entry. Empty parameters are handled like unset.
# Globals Read:
#   - CO_HOST: See co_rc.sh.
# Arguments:
#   - The label of the boot entry.
#   - The loader for the boot entry.
#   - Command line arguments for the loader.
# Outputs:
#   The bootnum of the boot entry.
function add_entry() {
  local -r label=$1
  local -r loader=$2
  local -r cmdline=$3

  # It's necessary to delete the existing entry and replace it, because efibootmgr doesn't support
  # editing an existing entry: https://github.com/rhboot/efibootmgr/issues/49.
  remove_entry_if_existing "$label"
  if [[ $CO_HOST = "DESKTOP" ]]; then
    local -r device=/dev/nvme0n1
  elif [[ $CO_HOST = "LAPTOP_P500" ]]; then
    local -r device=/dev/sda
  else
    error "Host unknown, I don't know which disk to use."
    exit 1
  fi
  efibootmgr -q -c -d $device -p 3 --label "$label" -l "$loader" -u "$cmdline"
}

# Updates Arch Linux UEFI boot entries.
# Globals Read:
#   - CO_HOST: See co_rc.sh.
# Arguments:
#   - The type of entries to generate, out of "normal", "silent", "debug", "rescue", and
# "fallback-rescue".
#   - Any boot parameters to append.
# Outputs:
#   Changes being made to EFI boot entries.
function update_efi() {
  local -r type=$1
  if [[ -n $type ]]; then
    shift
  fi

  figlet -k -f slant update-efi | lolcat -f -s 100 -p 1
  info "Comet Observatory UEFI Boot Entry Updater Script"
  info "https://gitlab.com/CodingKoopa/comet-observatory"

  if [[ $CO_HOST = "DESKTOP" ]]; then
    local -r ROOT="PARTUUID=5e22d600-bd6a-42de-b0e5-c5978a17e3b3"
    local -r MICROCODE="amd-ucode.img"
  elif [[ $CO_HOST = "LAPTOP_P500" ]]; then
    local -r ROOT="PARTUUID=90dd0890-79d3-4f66-b1f4-67f8fb2345c2"
    local -r MICROCODE="intel-ucode.img"
  else
    error "Host unknown, I don't know which disk to use."
    exit 1
  fi

  # See: https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html

  # Set the initial ramdisk to the microcode, for functionality. This is set separately because it
  # has to come before the kernel initrd.
  local -r MICROCODE_INITRD_STR="initrd=\\$MICROCODE"
  local -a CMDLINE_ARRAY=(
    # Enable r/w on the file system, for functionality.
    "rw"
    # Set the root filesystem, for functionality.
    "root=$ROOT"
    # Enable zswap, disable the watch dog, optimize for performance, and disable staggered spinup,
    # for performance.
    "zswap.enabled=1 nowatchdog workqueue.power_efficient=0 libahci.ignore_sss=1"
    # Enable DRM modesetting, for functionality.
    "nvidia-drm.modeset=1"
  )
  if [[ $CO_HOST = "LAPTOP_P500" ]]; then
    # Use the ACPI video.ko driver, because the vendor driver causes the brightness to be stuck.
    CMDLINE_ARRAY+=("acpi_backlight=video")
  fi
  local -r CMDLINE_STR="${CMDLINE_ARRAY[*]}"
  # Set the kernel logging level to errors, set the initrd systemd logging level to errors, supress
  # successful systemd initramfs messages, and hide the cursor, for less verbosity.
  local -ra CMDLINE_SILENT_STR="quiet rd.udev.log_priority=3 rd.systemd.show_status=auto \
vt.global_cursor_default=0"
  # Print early EFI kernel messages, allocate a larger kernel message buffer, ignore the kernel
  # logging level, allocate a larger log buffer, set the systemd log level to debug, write systemd
  # logs to the kernel log buffer, and allow unlimited logging from userspace, for more verbosity.
  local -ra CMDLINE_DEBUG_STR="earlyprintk=efi,keep log_buf_len=16M ignore_loglevel \
systemd.log_level=debug systemd.log_target=kmsg printk.devkmsg=on"
  # Enable rescue mode, for emergencies.
  local -ra CMDLINE_RESCUE_STR="rescue"

  # Decides what configuration to use, and adds a UEFI boot entry acoordingly using add_entry().
  # Arguments:
  #   - The name of the kernel.
  #   - The vmlinux suffix, if applicable.
  # Outputs:
  #   Entry addition progress.
  function add_entry_decide_configuration() {
    local -r kernel=$1
    local -r vmlinuz_path=/vmlinuz-linux${2}
    local -r kernel_initrd_str=initrd=initramfs-linux${2}.img
    local -r fallback_kernel_initrd_str=initrd=initramfs-linux${2}.img
    shift 2

    case $type in
    *debug*)
      info "Updating $kernel debug UEFI boot entry ($vmlinuz_path)."
      add_entry "$kernel (Debug)" "$vmlinuz_path" "$MICROCODE_INITRD_STR $kernel_initrd_str \
$CMDLINE_STR $CMDLINE_DEBUG_STR $*"
      ;;
    *rescue-fallback*)
      info "Updating $kernel fallback rescue UEFI boot entry ($vmlinuz_path)."
      add_entry "$kernel (Fallback Rescue)" "$vmlinuz_path" "$MICROCODE_INITRD_STR \
$fallback_kernel_initrd_str $CMDLINE_STR $CMDLINE_DEBUG_STR $CMDLINE_RESCUE_STR $*"
      ;;
    *rescue*)
      info "Updating $kernel rescue UEFI boot entry ($vmlinuz_path)."
      add_entry "$kernel (Rescue)" "$vmlinuz_path" "$MICROCODE_INITRD_STR $kernel_initrd_str \
$CMDLINE_STR $CMDLINE_DEBUG_STR $CMDLINE_RESCUE_STR $*"
      ;;
    *silent*)
      info "Updating $kernel silent UEFI boot entry ($vmlinuz_path)."
      add_entry "$kernel (Silent)" "$vmlinuz_path" "$MICROCODE_INITRD_STR $kernel_initrd_str \
$CMDLINE_STR $CMDLINE_SILENT_STR $*"
      ;;
    *)
      info "Updating $kernel normal UEFI boot entry ($vmlinuz_path)."
      add_entry "$kernel (Normal)" "$vmlinuz_path" "$MICROCODE_INITRD_STR $kernel_initrd_str \
$CMDLINE_STR $*"
      ;;
    esac
  }

  # Assign a vmlinux suffix to the different kernels.
  local -A kernel_suffixes=(
    ["Vanilla $(pacman -Q linux | cut -d" " -f2 | cut -d. -f1-2)"]=""
  )

  local -ra CONFIGURATIONS=(
    "Debug"
    "Rescue"
    "Fallback Rescue"
    "Silent"
    "Normal"
  )

  info "Scanning existing boot entries."
  for kernel in "${!kernel_suffixes[@]}"; do
    for configuration in "${CONFIGURATIONS[@]}"; do
      remove_entry_if_existing "Arch Linux ($kernel) ($configuration)"
    done
  done

  info "Adding new boot entries."
  for kernel in "${!kernel_suffixes[@]}"; do
    add_entry_decide_configuration "Arch Linux ($kernel)" "${kernel_suffixes[${kernel}]}" "$@"
  done

  local -r default_entry="Arch Linux ($kernel) (Normal)"
  local -r default_entry_num=$(find_bootnum "$default_entry")
  if [[ -n $default_entry_num ]]; then
    info "Setting $default_entry as default entry."
    efibootmgr -q -O
    efibootmgr -q -o "$default_entry_num"
  else
    info "Default entry doesn't seem to be present."
  fi

  info "Boot entries:"
  efibootmgr | tr -d "."
}

# Sets the UEFI next boot parameter to that of the Windows Boot Manager, and reboots.
function win_boot() {
  info "Rebooting into Windows."
  local -r WINDOWS_ENTRY_NAME="Windows Boot Manager"
  local -r windows_entry_num="$(find_bootnum "$WINDOWS_ENTRY_NAME")"
  if [[ -n $windows_entry_num ]]; then
    efibootmgr -q -n "$windows_entry_num"
    systemctl reboot
  else
    error "Boot entry \"$WINDOWS_ENTRY_NAME\" not found."
  fi
}

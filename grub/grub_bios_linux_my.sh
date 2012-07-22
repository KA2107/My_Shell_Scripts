#!/usr/bin/env bash

_GRUB_BIOS_LINUX="${PWD}/grub_bios.sh"
_GRUB_BIOS_LINUX_MY="${_GRUB_BIOS_LINUX} /dev/sda /boot grub_bios /media/Data_2/grub_bios_backup /media/Data_2/grub_bios_utils_backup /_grub_/grub_bios/"

echo

echo "${_GRUB_BIOS_LINUX} [GRUB_INSTALL_DEVICE] [GRUB_BOOT_PARTITION_MOUNTPOINT] [GRUB_BIOS_INSTALL_DIR_NAME] [GRUB_BIOS_BACKUP_DIR_PATH] [GRUB_BIOS_UTILS_BACKUP_DIR_PATH] [GRUB_BIOS_PREFIX_DIR_PATH]"

echo

# echo "${_GRUB_BIOS_LINUX_MY}"

echo

set -x

${_GRUB_BIOS_LINUX_MY}

echo

set +x

unset _GRUB_BIOS_LINUX
unset _GRUB_BIOS_LINUX_MY

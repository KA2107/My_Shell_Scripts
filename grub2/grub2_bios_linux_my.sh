#!/usr/bin/env bash

_GRUB2_BIOS_LINUX="${PWD}/grub2_bios.sh"
_GRUB2_BIOS_LINUX_MY="${_GRUB2_BIOS_LINUX} /dev/sda /boot/grub_bios grub /media/Data_3/grub_bios_backup /media/Data_3/grub_bios_utils_backup /_grub_bios_/"

echo

echo "${_GRUB2_BIOS_LINUX} [GRUB2_INSTALL_DEVICE] [GRUB2_BOOT_PARTITION_MOUNTPOINT] [GRUB2_BIOS_INSTALL_DIR_NAME] [GRUB2_BIOS_BACKUP_DIR_PATH] [GRUB2_BIOS_UTILS_BACKUP_DIR_PATH] [GRUB2_BIOS_PREFIX_DIR_PATH]"

echo

# echo "${_GRUB2_BIOS_LINUX_MY}"

echo

set -x

${_GRUB2_BIOS_LINUX_MY}

echo

set +x

unset _GRUB2_BIOS_LINUX
unset _GRUB2_BIOS_LINUX_MY

#!/usr/bin/env bash

_GRUB_UEFI_LINUX="${PWD}/grub_uefi.sh"
_GRUB_UEFI_LINUX_MY="${_GRUB_UEFI_LINUX} x86_64 /boot/efi /boot/efi/efi grub_uefi_x86_64 /media/Data_3/grub_uefisys_x86_64_backup /media/Data_3/grub_uefi_x86_64_bootdir_backup /media/Data_3/grub_uefi_x86_64_utils_Backup /_grub_/grub_uefi_x86_64/"

echo

echo "${_GRUB_UEFI_LINUX} [TARGET_UEFI_ARCH] [UEFI_SYSTEM_PART_MOUNTPOINT] [GRUB_UEFI_BOOTDIR] [GRUB_UEFI_INSTALL_DIR_NAME] [GRUB_UEFISYS_BACKUP_DIR_PATH] [GRUB_UEFI_BOOTDIR_BACKUP_DIR_PATH] [GRUB_UEFI_UTILS_BACKUP_DIR_PATH] [GRUB_UEFI_PREFIX_DIR_PATH]"

echo

# echo "${_GRUB_UEFI_LINUX_MY}"

echo

set -x

${_GRUB_UEFI_LINUX_MY}

echo

set +x

unset _GRUB_UEFI_LINUX
unset _GRUB_UEFI_LINUX_MY

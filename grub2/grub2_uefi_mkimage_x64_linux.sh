#!/bin/bash

export _TARGET_UEFI_ARCH='x86_64'
export _GRUB2_UEFI_PREFIX="/_grub_/grub_uefi_${_TARGET_UEFI_ARCH}"

export _GRUB2_UEFI_NAME='grub_uefi_x64'
export _GRUB2_UEFI_APP_PREFIX="efi/${_GRUB2_UEFI_NAME}"
export _GRUB2_UEFI_SYSTEM_PART_DIR="/boot/efi/${_GRUB2_UEFI_APP_PREFIX}"

export _GRUB2_PARTMAP_FS_MODULES="part_gpt part_msdos part_apple fat ext2 reiserfs iso9660 udf hfsplus hfs btrfs nilfs2 xfs ntfs ntfscomp zfs zfsinfo"
export _GRUB2_COMMON_IMP_MODULES="relocator reboot multiboot multiboot2 fshelp xzio gzio memdisk tar normal gfxterm chain linux ls cat search search_fs_file search_fs_uuid search_label help loopback boot configfile echo lvm usbms usb_keyboard"
export _GRUB2_UEFI_APP_MODULES="efi_gop efi_uga font png jpeg"
export _GRUB2_EXTRAS_MODULES="lua.mod"

# export _GRUB2_UEFI_FINAL_MODULES="${_GRUB2_PARTMAP_FS_MODULES} ${_GRUB2_COMMON_IMP_MODULES} ${_GRUB2_UEFI_APP_MODULES} ${_GRUB2_EXTRAS_MODULES}"
export _GRUB2_UEFI_FINAL_MODULES="${_GRUB2_PARTMAP_FS_MODULES} ${_GRUB2_COMMON_IMP_MODULES} ${_GRUB2_UEFI_APP_MODULES}"

export _GRUB2_UNIFONT_PATH='/usr/share/fonts/misc'

set -x -e

sudo "${_GRUB2_UEFI_PREFIX}/bin/${_GRUB2_UEFI_NAME}-mkimage" --verbose --directory="${_GRUB2_UEFI_PREFIX}/lib/${_GRUB2_UEFI_NAME}/${_TARGET_UEFI_ARCH}-efi" --prefix="" --output="${_GRUB2_UEFI_SYSTEM_PART_DIR}/${_GRUB2_UEFI_NAME}.efi" --format="${_TARGET_UEFI_ARCH}-efi" ${_GRUB2_UEFI_FINAL_MODULES}
echo

# sudo "${_GRUB2_UEFI_PREFIX}/bin/${_GRUB2_UEFI_NAME}-mkfont" --verbose --output="${_GRUB2_UEFI_SYSTEM_PART_DIR}/unicode.pf2" "${_GRUB2_UNIFONT_PATH}/unifont.bdf" || true
echo
# sudo "${_GRUB2_UEFI_PREFIX}/bin/${_GRUB2_UEFI_NAME}-mkfont" --verbose --ascii-bitmaps --output="${_GRUB2_UEFI_SYSTEM_PART_DIR}/ascii.pf2" "${_GRUB2_UNIFONT_PATH}/unifont.bdf" || true
echo

sudo cp "${_GRUB2_UEFI_PREFIX}/share/${_GRUB2_UEFI_NAME}/unicode.pf2" "${_GRUB2_UEFI_SYSTEM_PART_DIR}/" || true
echo

set +x +e

unset _GRUB2_UEFI_PREFIX
unset _GRUB2_UEFI_NAME
unset _TARGET_UEFI_ARCH
unset _GRUB2_UEFI_APP_PREFIX
unset _GRUB2_UEFI_SYSTEM_PART_DIR
unset _GRUB2_PARTMAP_FS_MODULES
unset _GRUB2_COMMON_IMP_MODULES
unset _GRUB2_UEFI_APP_MODULES
unset _GRUB2_EXTRAS_MODULES
unset _GRUB2_UEFI_FINAL_MODULES
unset _GRUB2_UNIFONT_PATH

#! /bin/sh

export TARGET_EFI_ARCH="x86_64"
export GRUB2_EFI_PREFIX="/grub2/grub2_uefi_${TARGET_EFI_ARCH}"
export GRUB2_EFI_NAME="grub2_uefi_x64"
export GRUB2_EFI_APP_PREFIX="efi/${GRUB2_EFI_NAME}"
export GRUB2_EFISYS_PART_DIR="/boot/efi/${GRUB2_EFI_APP_PREFIX}"

export GRUB2_PARTMAP_FS_MODULES="part_gpt part_msdos part_apple fat ext2 reiserfs iso9660 udf hfsplus hfs btrfs nilfs2 xfs ntfs ntfscomp zfs zfsinfo"
export GRUB2_COMMON_IMP_MODULES="relocator reboot multiboot multiboot2 fshelp xzio gzio memdisk tar normal gfxterm chain linux ls cat search search_fs_file search_fs_uuid search_label help loopback boot configfile echo lvm usbms usb_keyboard"
export GRUB2_EFI_APP_MODULES="efi_gop efi_uga font png jpeg"
export GRUB2_EXTRAS_MODULES="lua.mod"
# export GRUB2_EFI_FINAL_MODULES="${GRUB2_PARTMAP_FS_MODULES} ${GRUB2_COMMON_IMP_MODULES} ${GRUB2_EFI_APP_MODULES} ${GRUB2_EXTRAS_MODULES}"
export GRUB2_EFI_FINAL_MODULES="${GRUB2_PARTMAP_FS_MODULES} ${GRUB2_COMMON_IMP_MODULES} ${GRUB2_EFI_APP_MODULES}"

export GRUB2_UNIFONT_PATH="/usr/share/fonts/misc"

set -x -e

sudo "${GRUB2_EFI_PREFIX}/bin/${GRUB2_EFI_NAME}-mkimage" --verbose --directory="${GRUB2_EFI_PREFIX}/lib/${GRUB2_EFI_NAME}/${TARGET_EFI_ARCH}-efi" --prefix="" --output="${GRUB2_EFISYS_PART_DIR}/${GRUB2_EFI_NAME}.efi" --format="${TARGET_EFI_ARCH}-efi" ${GRUB2_EFI_FINAL_MODULES}
echo

# sudo "${GRUB2_EFI_PREFIX}/bin/${GRUB2_EFI_NAME}-mkfont" --verbose --output="${GRUB2_EFISYS_PART_DIR}/unicode.pf2" "${GRUB2_UNIFONT_PATH}/unifont.bdf" || true
echo
# sudo "${GRUB2_EFI_PREFIX}/bin/${GRUB2_EFI_NAME}-mkfont" --verbose --ascii-bitmaps --output="${GRUB2_EFISYS_PART_DIR}/ascii.pf2" "${GRUB2_UNIFONT_PATH}/unifont.bdf" || true
echo

sudo cp "${GRUB2_EFI_PREFIX}/share/${GRUB2_EFI_NAME}"/*.pf2 "${GRUB2_EFISYS_PART_DIR}/" || true
echo

set +x +e

unset GRUB2_EFI_PREFIX
unset GRUB2_EFI_NAME
unset TARGET_EFI_ARCH
unset GRUB2_EFI_APP_PREFIX
unset GRUB2_EFISYS_PART_DIR
unset GRUB2_PARTMAP_FS_MODULES
unset GRUB2_COMMON_IMP_MODULES
unset GRUB2_EFI_APP_MODULES
unset GRUB2_EXTRAS_MODULES
unset GRUB2_EFI_FINAL_MODULES
unset GRUB2_UNIFONT_PATH

#!/usr/bin/env bash

_WD="${PWD}/"

_TARGET_UEFI_ARCH='x86_64'
_UEFI_SYSTEM_PART_MP="/boot/efi"

_GRUB_UEFI_PREFIX_DIR="/_grub_/grub_uefi_${_TARGET_UEFI_ARCH}"
_GRUB_UEFI_BIN_DIR="${_GRUB_UEFI_PREFIX_DIR}/bin"
_GRUB_UEFI_SBIN_DIR="${_GRUB_UEFI_PREFIX_DIR}/sbin"
_GRUB_UEFI_SYSCONF_DIR="${_GRUB_UEFI_PREFIX_DIR}/etc"
_GRUB_UEFI_LIB_DIR="${_GRUB_UEFI_PREFIX_DIR}/lib"
_GRUB_UEFI_DATA_DIR="${_GRUB_UEFI_LIB_DIR}"
_GRUB_UEFI_DATAROOT_DIR="${_GRUB_UEFI_PREFIX_DIR}/share"

_GRUB_UEFI_NAME='grub_uefi_x86_64'
_GRUB_UEFI_MENU_CONFIG='grub'

_GRUB_UEFI_APP_PREFIX="efi/${_GRUB_UEFI_NAME}"
_GRUB_UEFI_SYSTEM_PART_DIR="${_UEFI_SYSTEM_PART_MP}/${_GRUB_UEFI_APP_PREFIX}"

_GRUB_UEFI_BOOTDIR_ACTUAL="/boot/efi/efi/grub_uefi_${_TARGET_UEFI_ARCH}/"

_GRUB_UNIFONT_PATH='/usr/share/fonts/misc'

set -x -e

echo

_GRUB_BOOT_PART_HINTS_STRING="$(sudo "${_GRUB_UEFI_SBIN_DIR}/${_GRUB_UEFI_NAME}-probe" --target="hints_string" "${_GRUB_UEFI_BOOTDIR_ACTUAL}/${_TARGET_UEFI_ARCH}-efi/core.efi")"

echo

_GRUB_BOOT_PART_RELATIVE_PREFIX="$(sudo "${_GRUB_UEFI_BIN_DIR}/${_GRUB_UEFI_NAME}-mkrelpath" "${_GRUB_UEFI_BOOTDIR_ACTUAL}")"

echo

cat << EOF > "${_WD}/${_GRUB_UEFI_NAME}_standalone_memdisk_config.cfg"

insmod usbms
insmod usb_keyboard

insmod part_gpt
insmod part_msdos

insmod fat
insmod iso9660
insmod udf

insmod ext2
insmod reiserfs
insmod ntfs
insmod hfsplus

search --file --no-floppy --set=grub_uefi_prefix_root ${_GRUB_BOOT_PART_HINTS_STRING} "${_GRUB_BOOT_PART_RELATIVE_PREFIX}/${_TARGET_UEFI_ARCH}-efi/core.efi"

# set prefix="(\${grub_uefi_prefix_root})/${_GRUB_BOOT_PART_RELATIVE_PREFIX}"
source "\${prefix}/${_GRUB_UEFI_MENU_CONFIG}.cfg"

EOF

echo

mkdir -p "${_WD}/boot/grub" || true
echo

if [[ -e "${_WD}/boot/grub/grub.cfg" ]]; then
	mv "${_WD}/boot/grub/grub.cfg" "${_WD}/boot/grub/grub.cfg.save"
	echo
fi
echo

install -D -m0644 "${_WD}/${_GRUB_UEFI_NAME}_standalone_memdisk_config.cfg" "${_WD}/boot/grub/grub.cfg"
echo

__WD="${PWD}/"
echo

cd "${_WD}/"
echo

## Create the grub standalone uefi application
sudo "${_GRUB_UEFI_BIN_DIR}/${_GRUB_UEFI_NAME}-mkstandalone" --directory="${_GRUB_UEFI_LIB_DIR}/${_GRUB_UEFI_NAME}/${_TARGET_UEFI_ARCH}-efi" --format="${_TARGET_UEFI_ARCH}-efi" --compression="xz" --output="${_GRUB_UEFI_SYSTEM_PART_DIR}/${_GRUB_UEFI_NAME}_standalone.efi" "boot/grub/grub.cfg"
echo

cd "${__WD}/"
echo

if [[ -e "${_WD}/boot/grub/grub.cfg.save" ]]; then
	mv "${_WD}/boot/grub/grub.cfg.save" "${_WD}/boot/grub/grub.cfg"
	echo
fi
echo

sudo rm -f --verbose "${_GRUB_UEFI_SYSTEM_PART_DIR}/${_GRUB_UEFI_NAME}_standalone.cfg" || true
echo

if [[ -e "${_WD}/${_GRUB_UEFI_NAME}_standalone_memdisk_config.cfg" ]]; then
	sudo install -D -m0644 "${_WD}/${_GRUB_UEFI_NAME}_standalone_memdisk_config.cfg" "${_GRUB_UEFI_SYSTEM_PART_DIR}/${_GRUB_UEFI_NAME}_standalone.cfg"
	echo
fi
echo

sudo rm -f --verbose "${_UEFI_SYSTEM_PART_MP}/efi/boot/bootx64.efi"
echo

sudo install -D -m0644 "${_GRUB_UEFI_SYSTEM_PART_DIR}/${_GRUB_UEFI_NAME}_standalone.efi" "${_UEFI_SYSTEM_PART_MP}/efi/boot/bootx64.efi"
echo

# sudo "${_GRUB_UEFI_BIN_DIR}/${_GRUB_UEFI_NAME}-mkfont" --verbose --output="${_GRUB_UEFI_SYSTEM_PART_DIR}/unicode.pf2" "${_GRUB_UNIFONT_PATH}/unifont.bdf" || true
echo

# sudo "${_GRUB_UEFI_BIN_DIR}/${_GRUB_UEFI_NAME}-mkfont" --verbose --ascii-bitmaps --output="${_GRUB_UEFI_SYSTEM_PART_DIR}/ascii.pf2" "${_GRUB_UNIFONT_PATH}/unifont.bdf" || true
echo

if [[ -e "${_GRUB_UEFI_DATA_DIR}/${_GRUB_UEFI_NAME}/unicode.pf2" ]]; then
	mkdir -p "${_GRUB_UEFI_DATAROOT_DIR}/${_GRUB_UEFI_NAME}" || true
	sudo cp --verbose "${_GRUB_UEFI_DATA_DIR}/${_GRUB_UEFI_NAME}"/{{ascii,euro,unicode}.pf2,{ascii,widthspec}.h} "${_GRUB_UEFI_DATAROOT_DIR}/${_GRUB_UEFI_NAME}/" || true
	echo
fi 

sudo cp --verbose "${_GRUB_UEFI_DATAROOT_DIR}/${_GRUB_UEFI_NAME}"/{ascii,euro,unicode}.pf2 "${_GRUB_UEFI_SYSTEM_PART_DIR}/" || true
echo

set +x +e

unset _WD
unset _TARGET_UEFI_ARCH
unset _UEFI_SYSTEM_PART_MP
unset _GRUB_UEFI_PREFIX_DIR
unset _GRUB_UEFI_BIN_DIR
unset _GRUB_UEFI_SBIN_DIR
unset _GRUB_UEFI_SYSCONF_DIR
unset _GRUB_UEFI_LIB_DIR
unset _GRUB_UEFI_DATA_DIR
unset _GRUB_UEFI_DATAROOT_DIR
unset _GRUB_UEFI_NAME
unset _GRUB_UEFI_MENU_CONFIG
unset _GRUB_UEFI_APP_PREFIX
unset _GRUB_UEFI_SYSTEM_PART_DIR
unset _GRUB_UEFI_BOOTDIR_ACTUAL
unset _GRUB_UNIFONT_PATH
unset __WD

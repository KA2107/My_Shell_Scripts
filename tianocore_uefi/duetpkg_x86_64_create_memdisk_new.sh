#!/bin/bash

set -x -e

_SOURCE_CODES_DIR="/media/Source_Codes/Source_Codes"
_WD="${_SOURCE_CODES_DIR}/Firmware/UEFI/TianoCore_Sourceforge"

source "${_WD}/tianocore_uefi_duetpkg_common.sh"

_CREATE_MEMDISK() {
	
	echo
	
	rm -f "${_WD}/duet_x86_64_memdisk.bin" || true
	dd if=/dev/zero of="${_WD}/duet_x86_64_memdisk.bin" bs=512 count=2880
	mkfs.vfat -F12 -S 512 -n "UEFI_DUETPKG" "${_WD}/duet_x86_64_memdisk.bin"
	chmod -x "${_WD}/duet_x86_64_memdisk.bin" || true
	
	echo
	
}

_COMPILE_MEMDISK() {
	
	echo
	
	# _CREATE_MEMDISK
	
	echo
	
	_MIGLE_BOOTDUET_COMPILE
	
	echo
	
	sudo modprobe loop
	LOOP_DEVICE=$(losetup --show --find "${_WD}/duet_x86_64_memdisk.bin")
	
	echo
	
	sudo "${_ROD_SMITH_DUET_INSTALL_DIR}/duet-install" -b "${MIGLE_BOOTDUET_COMPILE_DIR}" -s "${_SYSLINUX_LIB_DIR}" -u "${_UEFI_DUET_INSTALLER_DIR}" "${LOOP_DEVICE}"
	
	echo
	
	_MIGLE_BOOTDUET_CLEAN
	
	echo
	
	losetup --detach "${LOOP_DEVICE}"
	
	echo
	
}

echo

_COPY_MEMDISK_SYSLINUX

echo

_CREATE_MEMDISK

echo

_COMPILE_MEMDISK

echo

_COPY_EFILDR_MEMDISK

echo

unset _SOURCE_CODES_DIR
unset _WD
unset _UDK_DIR
unset _UDK_BUILD_TOOLS_DIR
unset _UDK_C_SOURCE_DIR
unset _UDK_DUETPKG_BOOTSECT_BIN_DIR
unset _UDK_BUILD_DIR
unset _BACKUP_BUILDS_DIR
unset _DUETPKG_EMUVARIABLE_BUILD_DIR
unset _DUETPKG_FSVARIABLE_BUILD_DIR
unset _DUETPKG_COMPILED_DIR
unset _UEFI_DUET_INSTALLER_DIR
unset _DUET_MEMDISK_COMPILED_DIR
unset _MEMDISK_DIR
unset _MIGLE_BOOTDUET_COMPILE_DIR
unset _ROD_SMITH_DUET_INSTALL_DIR
unset _BOOTPART
unset _UEFI_SYS_PART
unset _SYSLINUX_LIB_DIR

set +x +e

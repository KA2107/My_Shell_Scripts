#!/bin/bash

set -x -e

_SOURCE_CODES_DIR="/media/Source_Codes/Source_Codes"
_WD="${_SOURCE_CODES_DIR}/Firmware/UEFI/TianoCore_Sourceforge"

source "${_WD}/tianocore_uefi_duetpkg_common.sh"

_CREATE_FLOPPY_MEMDISK_EMUVARIABLE() {
	
	echo
	
	_SET_PYTHON2
	
	echo
	
	_UDK_BUILD_CLEAN
	
	echo
	
	cd "${_UDK_DIR}/"
	git checkout keshav_pr
	
	echo
	
	_COPY_BUILDTOOLS_BASETOOLS
	
	echo
	
	_CORRECT_WERROR
	
	echo
	
	export WORKSPACE="${_UDK_DIR}/"
	
	echo
	
	mkdir -p "${_UDK_BUILD_OUTER_DIR}"
	cp -r "${_DUETPKG_EMUVARIABLE_BUILD_DIR}" "${_UDK_BUILD_DIR}"
	
	echo
	
	cd "${EDK_TOOLS_PATH}"
	make
	
	echo
	
	"${WORKSPACE}/DuetPkg/CreateBootDisk.sh" file "${_DUETPKG_EMUVARIABLE_BUILD_DIR}/floppy.img" /dev/null FAT12 X64 GCC45 RELEASE
	chmod -x "${_DUETPKG_EMUVARIABLE_BUILD_DIR}/floppy.img" || true
	
	_UDK_BUILD_CLEAN
	
	echo
	
	_SET_PYTHON3
	
	echo
}

_CREATE_FLOPPY_MEMDISK_FSVARIABLE() {
	
	echo
	
	_SET_PYTHON2
	
	echo
	
	_UDK_BUILD_CLEAN
	
	echo
	
	cd "${_UDK_DIR}/"
	git checkout duet_fsvariable
	
	echo
	
	_COPY_BUILDTOOLS_BASETOOLS
	
	echo
	
	_CORRECT_WERROR
	
	echo
	
	export WORKSPACE="${_UDK_DIR}/"
	
	echo
	
	mkdir -p "${_UDK_BUILD_OUTER_DIR}"
	cp -r "${_DUETPKG_FSVARIABLE_BUILD_DIR}" "${_UDK_BUILD_DIR}"
	
	echo
	
	cd "${EDK_TOOLS_PATH}"
	make
	
	echo
	
	"${WORKSPACE}/DuetPkg/CreateBootDisk.sh" file "${_DUETPKG_FSVARIABLE_BUILD_DIR}/floppy.img" /dev/null FAT12 X64 GCC45 RELEASE
	chmod -x "${_DUETPKG_FSVARIABLE_BUILD_DIR}/floppy.img" || true
	
	echo
	
	_UDK_BUILD_CLEAN
	
	echo
	
	_SET_PYTHON3
	
	echo
}

echo

_COPY_MEMDISK_SYSLINUX

echo

_CREATE_FLOPPY_MEMDISK_EMUVARIABLE

echo

# _CREATE_FLOPPY_MEMDISK_FSVARIABLE

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
unset WORKSPACE

set +x +e

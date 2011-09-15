#!/bin/bash

set -x -e

SOURCE_CODES_DIR="/media/Source_Codes/Source_Codes"
WD="${SOURCE_CODES_DIR}/Firmware/UEFI/TianoCore_Sourceforge"

source "${WD}/tianocore_duet_common.sh"

_CREATE_FLOPPY_MEMDISK_EMUVARIABLE() {
	
	echo
	
	_SET_PYTHON2
	
	echo
	
	_EDK2_BUILD_CLEAN
	
	echo
	
	cd "${EDK2_DIR}/"
	git checkout keshav_pr
	
	echo
	
	_COPY_BUILDTOOLS_BASETOOLS
	
	echo
	
	_CORRECT_WERROR
	
	echo
	
	export WORKSPACE="${EDK2_DIR}/"
	
	echo
	
	mkdir -p "${EDK2_BUILD_OUTER_DIR}"
	cp -r "${DUET_EMUVARIABLE_BUILD_DIR}" "${EDK2_BUILD_DIR}"
	
	echo
	
	cd "${EDK_TOOLS_PATH}"
	make
	
	echo
	
	"${WORKSPACE}/DuetPkg/CreateBootDisk.sh" file "${DUET_EMUVARIABLE_BUILD_DIR}/floppy.img" /dev/null FAT12 X64 GCC45 RELEASE
	chmod -x "${DUET_EMUVARIABLE_BUILD_DIR}/floppy.img" || true
	
	_EDK2_BUILD_CLEAN
	
	echo
	
	_SET_PYTHON3
	
	echo
}

_CREATE_FLOPPY_MEMDISK_FSVARIABLE() {
	
	echo
	
	_SET_PYTHON2
	
	echo
	
	_EDK2_BUILD_CLEAN
	
	echo
	
	cd "${EDK2_DIR}/"
	git checkout duet_fsvariable
	
	echo
	
	_COPY_BUILDTOOLS_BASETOOLS
	
	echo
	
	_CORRECT_WERROR
	
	echo
	
	export WORKSPACE="${EDK2_DIR}/"
	
	echo
	
	mkdir -p "${EDK2_BUILD_OUTER_DIR}"
	cp -r "${DUET_FSVARIABLE_BUILD_DIR}" "${EDK2_BUILD_DIR}"
	
	echo
	
	cd "${EDK_TOOLS_PATH}"
	make
	
	echo
	
	"${WORKSPACE}/DuetPkg/CreateBootDisk.sh" file "${DUET_FSVARIABLE_BUILD_DIR}/floppy.img" /dev/null FAT12 X64 GCC45 RELEASE
	chmod -x "${DUET_FSVARIABLE_BUILD_DIR}/floppy.img" || true
	
	echo
	
	_EDK2_BUILD_CLEAN
	
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

unset SOURCE_CODES_DIR
unset WD
unset EDK2_DIR
unset EDK2_BUILD_TOOLS_DIR
unset EDK2_C_SOURCE_DIR
unset EDK2_DUET_BOOTSECT_BIN_DIR
unset EDK2_BUILD_DIR
unset BACKUP_BUILDS_DIR
unset DUET_EMUVARIABLE_BUILD_DIR
unset DUET_FSVARIABLE_BUILD_DIR
unset DUET_COMPILED_DIR
unset UEFI_DUET_INSTALLER_DIR
unset DUET_MEMDISK_COMPILED_DIR
unset MEMDISK_DIR
unset _MIGLE_BOOTDUET_COMPILE_DIR
unset SRS5694_DUET_INSTALL_DIR
unset BOOTPART
unset EFISYS
unset SYSLINUX_DIR
unset WORKSPACE

set +x +e

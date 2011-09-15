#!/bin/bash

set -x -e

SOURCE_CODES_DIR="/media/Source_Codes/Source_Codes"
WD="${SOURCE_CODES_DIR}/Firmware/UEFI/TianoCore_Sourceforge"

source "${WD}/tianocore_duet_common.sh"

_COMPILE_DUET_EMUVARIABLE_BRANCH() {
	
	echo
	
	_SET_PYTHON2
	
	echo
	
	_EDK2_BUILD_CLEAN
	
	echo
	
	cd "${EDK2_DIR}/"
	git checkout keshav_pr
	
	echo
	
	# _COPY_BUILDTOOLS_BASETOOLS
	
	echo
	
	_CORRECT_WERROR
	
	echo
	
	_APPLY_PATCHES
	
	echo
	
	_APPLY_CHANGES
	
	echo
	
	cd "${EDK2_DIR}/DuetPkg"
	"${EDK2_DIR}/DuetPkg/build64.sh"
	
	echo
	
	cp -r "${EDK2_BUILD_DIR}" "${DUET_EMUVARIABLE_BUILD_DIR}"
	install -D -m644 "${EDK2_BUILD_OUTER_DIR}/floppy.img" "${DUET_EMUVARIABLE_BUILD_DIR}/floppy.img"
	
	echo
	
	_EDK2_BUILD_CLEAN
	
	echo
	
	_SET_PYTHON3
	
	echo
	
}

_COMPILE_DUET_FSVARIABLE_BRANCH() {
	
	echo
	
	_SET_PYTHON2
	
	echo
	
	_EDK2_BUILD_CLEAN
	
	echo
	
	cd "${EDK2_DIR}/"
	git checkout duet_fsvariable
	
	echo
	
	# _COPY_BUILDTOOLS_BASETOOLS
	
	echo
	
	_CORRECT_WERROR
	
	echo
	
	_APPLY_PATCHES
	
	echo
	
	_APPLY_CHANGES
	
	echo
	
	cd "${EDK2_DIR}/DuetPkg"
	"${EDK2_DIR}/DuetPkg/build64.sh"
	
	echo
	
	cp -r "${EDK2_BUILD_DIR}" "${DUET_FSVARIABLE_BUILD_DIR}"
	install -D -m644 "${EDK2_BUILD_OUTER_DIR}/floppy.img" "${DUET_FSVARIABLE_BUILD_DIR}/floppy.img"
	
	echo
	
	_EDK2_BUILD_CLEAN
	
	echo
	
	_SET_PYTHON3
	
	echo
	
}

echo

_COMPILE_DUET_EMUVARIABLE_BRANCH

echo

_COMPILE_DUET_FSVARIABLE_BRANCH

echo

_COPY_EFILDR_DUET_PART

echo

_COPY_UEFI_SHELL_EFISYS_PART

echo

_COPY_EFILDR_MEMDISK

echo

cd "${WD}/"
# "${WD}/post_duet_x64_compile.sh"

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
unset DUET_PART_FS_UUID
unset DUET_PART_MP

set +x +e

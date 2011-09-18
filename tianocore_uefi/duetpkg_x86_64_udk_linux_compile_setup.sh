#!/bin/bash

set -x -e

_SOURCE_CODES_DIR="/media/Source_Codes/Source_Codes"
_WD="${_SOURCE_CODES_DIR}/Firmware/UEFI/TianoCore_Sourceforge"

source "${_WD}/tianocore_uefi_duetpkg_common.sh"

_COMPILE_DUETPKG_EMUVARIABLE_BRANCH() {
	
	echo
	
	_SET_PYTHON2
	
	echo
	
	_UDK_BUILD_CLEAN
	
	echo
	
	cd "${_UDK_DIR}/"
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
	
	cd "${_UDK_DIR}/DuetPkg"
	"${_UDK_DIR}/DuetPkg/build64.sh"
	
	echo
	
	cp -r "${_UDK_BUILD_DIR}" "${_DUETPKG_EMUVARIABLE_BUILD_DIR}"
	install -D -m644 "${_UDK_BUILD_OUTER_DIR}/floppy.img" "${_DUETPKG_EMUVARIABLE_BUILD_DIR}/floppy.img"
	
	echo
	
	_UDK_BUILD_CLEAN
	
	echo
	
	_SET_PYTHON3
	
	echo
	
}

_COMPILE_DUETPKG_FSVARIABLE_BRANCH() {
	
	echo
	
	_SET_PYTHON2
	
	echo
	
	_UDK_BUILD_CLEAN
	
	echo
	
	cd "${_UDK_DIR}/"
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
	
	cd "${_UDK_DIR}/DuetPkg"
	"${_UDK_DIR}/DuetPkg/build64.sh"
	
	echo
	
	cp -r "${_UDK_BUILD_DIR}" "${_DUETPKG_FSVARIABLE_BUILD_DIR}"
	install -D -m644 "${_UDK_BUILD_OUTER_DIR}/floppy.img" "${_DUETPKG_FSVARIABLE_BUILD_DIR}/floppy.img"
	
	echo
	
	_UDK_BUILD_CLEAN
	
	echo
	
	_SET_PYTHON3
	
	echo
	
}

echo

_COMPILE_DUETPKG_EMUVARIABLE_BRANCH

echo

_COMPILE_DUETPKG_FSVARIABLE_BRANCH

echo

_COPY_EFILDR_DUET_PART

echo

_COPY_UEFI_SHELL_UEFI_SYS_PART

echo

_COPY_EFILDR_MEMDISK

echo

cd "${_WD}/"
# "${_WD}/post_duet_x64_compile.sh"

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
unset _DUET_PART_FS_UUID
unset _DUET_PART_MP

set +x +e

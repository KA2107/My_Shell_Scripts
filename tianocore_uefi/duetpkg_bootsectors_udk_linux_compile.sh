#!/usr/bin/env bash

set -x -e

_SOURCE_CODES_DIR='/media/Source_Codes/Source_Codes'

_WD="${_SOURCE_CODES_DIR}/Firmware/UEFI/TianoCore_Sourceforge"

source "${_WD}/tianocore_uefi_duetpkg_common.sh"

_UDK_BUILD_OUTER_DIR="${_UDK_DIR}/Build/DuetPkgIA32/"
_UDK_BUILD_DIR="${_UDK_BUILD_OUTER_DIR}/DEBUG_GCC46/"

_BOOTSECTOR_BUILD_DIR="${_BACKUP_BUILDS_DIR}/BOOTSECTOR_BUILD"

_COMPILE_DUETPKG_BOOTSECTOR() {
	
	echo
	
	_UDK_BUILD_CLEAN
	
	echo
	
	cd "${_UDK_DIR}/"
	git checkout keshav_pr
	
	echo
	
	# _COPY_BUILDTOOLS_BASETOOLS
	
	echo
	
	_SET_PYTHON2
	
	echo
	
	_CORRECT_WERROR
	
	echo
	
	_APPLY_PATCHES
	
	echo
	
	_APPLY_CHANGES
	
	echo
	
	_COMPILE_BASETOOLS_MANUAL
	
	echo
	
	sed 's|ACTIVE_PLATFORM       = Nt32Pkg/Nt32Pkg.dsc|ACTIVE_PLATFORM       = DuetPkg/DuetPkgIa32.dsc|g' -i "${_UDK_DIR}/Conf/target.txt"
	
	echo
	
	build -p "${_UDK_DIR}/DuetPkg/DuetPkgIa32.dsc" -m "${_UDK_DIR}/DuetPkg/BootSector/BootSector.inf" -a IA32 -b RELEASE -t GCC46
	
	echo
	
	cp -r "${_UDK_BUILD_DIR}" "${_BOOTSECTOR_BUILD_DIR}"
	
	echo
	
	_UDK_BUILD_CLEAN
	
	echo
	
	# _SET_PYTHON3
	
	echo
	
}

echo

_COMPILE_DUETPKG_BOOTSECTOR

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

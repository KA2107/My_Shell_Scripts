#!/bin/bash

set -x -e

SOURCE_CODES_DIR="/media/Source_Codes/Source_Codes"
WD="${SOURCE_CODES_DIR}/Firmware/UEFI/TianoCore_Sourceforge"

source "${WD}/tianocore_common.sh"

EDK2_BUILD_OUTER_DIR="${EDK2_DIR}/Build/Shell/"
EDK2_BUILD_DIR="${EDK2_BUILD_OUTER_DIR}/DEBUG_GCC45/"

_SHELLPKG_BUILD_DIR="${BACKUP_BUILDS_DIR}/SHELLPKG_BUILD"

_COMPILE_SHELLPKG() {
	
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
	
	_APPLY_PATCHES
	
	echo
	
	_APPLY_CHANGES
	
	echo
	
	_COMPILE_BASETOOLS_MANUAL
	
	echo
	
	build -p "${EDK2_DIR}/ShellPkg/ShellPkg.dsc" -a X64 -b DEBUG -t GCC45
	
	echo
	
	cp -r "${EDK2_BUILD_DIR}" "${_SHELLPKG_BUILD_DIR}"
	
	echo
	
	_EDK2_BUILD_CLEAN
	
	echo
	
	_SET_PYTHON3
	
	echo
	
}

echo

_COMPILE_SHELLPKG

echo

unset SOURCE_CODES_DIR
unset WD
unset EDK2_DIR
unset EDK2_BUILD_TOOLS_DIR
unset EDK2_C_SOURCE_DIR
unset EDK_TOOLS_PATH
unset _SHELLPKG_BUILD_DIR
unset BACKUP_BUILDS_DIR

set +x +e

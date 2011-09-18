#!/bin/bash

set -x -e

SOURCE_CODES_DIR="/media/Source_Codes/Source_Codes"
WD="${SOURCE_CODES_DIR}/Firmware/UEFI/TianoCore_Sourceforge"

source "${WD}/tianocore_common.sh"

EDK2_BUILD_OUTER_DIR="${EDK2_DIR}/Build/UnixX64/"
EDK2_BUILD_DIR="${EDK2_BUILD_OUTER_DIR}/DEBUG_ELFGCC/"

UNIXPKG_BUILD_DIR="${BACKUP_BUILDS_DIR}/UNIXPKG_BUILD"

_COMPILE_UNIXPKG() {
	
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
	
	cd "${EDK2_DIR}/UnixPkg/"
	"${EDK2_DIR}/UnixPkg/build64.sh"
	
	echo
	
	cp -r "${EDK2_BUILD_DIR}" "${UNIXPKG_BUILD_DIR}"
	
	echo
	
	_EDK2_BUILD_CLEAN
	
	echo
	
	_SET_PYTHON3
	
	echo
	
}

echo

_COMPILE_UNIXPKG

echo

unset SOURCE_CODES_DIR
unset WD
unset EDK2_DIR
unset EDK2_BUILD_TOOLS_DIR
unset EDK2_C_SOURCE_DIR
unset EDK_TOOLS_PATH
unset UNIXPKG_BUILD_DIR
unset BACKUP_BUILDS_DIR

set +x +e

#!/bin/bash

set -x -e

_SOURCE_CODES_DIR='/media/Source_Codes/Source_Codes'

_WD="${_SOURCE_CODES_DIR}/Firmware/UEFI/TianoCore_Sourceforge"

source "${_WD}/tianocore_uefi_common.sh"

_UDK_BUILD_OUTER_DIR="${_UDK_DIR}/Build/UnixX64/"
_UDK_BUILD_DIR="${_UDK_BUILD_OUTER_DIR}/DEBUG_ELFGCC/"

_UNIXPKG_BUILD_DIR="${_BACKUP_BUILDS_DIR}/UNIXPKG_BUILD"

_COMPILE_UNIXPKG() {
	
	echo
	
	_UDK_BUILD_CLEAN
	
	echo
	
	cd "${_UDK_DIR}/"
	git checkout keshav_pr
	
	echo
	
	_COPY_BUILDTOOLS_BASETOOLS
	
	echo
	
	_SET_PYTHON2
	
	echo
	
	_CORRECT_WERROR
	
	echo
	
	_APPLY_PATCHES
	
	echo
	
	_APPLY_CHANGES
	
	echo
	
	cd "${_UDK_DIR}/UnixPkg/"
	"${_UDK_DIR}/UnixPkg/build64.sh"
	
	echo
	
	cp -r "${_UDK_BUILD_DIR}" "${_UNIXPKG_BUILD_DIR}"
	
	echo
	
	_UDK_BUILD_CLEAN
	
	echo
	
	# _SET_PYTHON3
	
	echo
	
}

echo

_COMPILE_UNIXPKG

echo

unset _SOURCE_CODES_DIR
unset _WD
unset _UDK_DIR
unset _UDK_BUILD_TOOLS_DIR
unset _UDK_C_SOURCE_DIR
unset EDK_TOOLS_PATH
unset _UNIXPKG_BUILD_DIR
unset _BACKUP_BUILDS_DIR

set +x +e

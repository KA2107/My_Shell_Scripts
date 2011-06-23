#!/bin/bash

set -x -e

SOURCE_CODES_DIR="/media/Data_2/Source_Codes"
WD="${SOURCE_CODES_DIR}/Firmware/UEFI/TianoCore_Sourceforge"

source "${WD}/tianocore_common.sh"

EDK2_BUILD_OUTER_DIR="${EDK2_DIR}/Build/UnixX64/"
EDK2_BUILD_DIR="${EDK2_BUILD_OUTER_DIR}/DEBUG_ELFGCC/"

UNIXPKG_BUILD_DIR="${WD}/UNIXPKG_BUILD"

COMPILE_UNIXPKG() {
	
	echo
	
	SET_PYTHON2
	
	echo
	
	EDK2_BUILD_CLEAN
	
	echo
	
	cd "${EDK2_DIR}/"
	git checkout keshav_pr
	
	echo
	
	COPY_BUILDTOOLS_BASETOOLS
	
	echo
	
	CORRECT_WERROR
	
	echo
	
	APPLY_PATCHES
	
	echo
	
	cd "${EDK2_DIR}/UnixPkg/"
	"${EDK2_DIR}/UnixPkg/build64.sh"
	
	echo
	
	cp -r "${EDK2_BUILD_DIR}" "${UNIXPKG_BUILD_DIR}"
	
	echo
	
	EDK2_BUILD_CLEAN
	
	echo
	
	SET_PYTHON3
	
	echo
	
}

echo

COMPILE_UNIXPKG

echo

unset SOURCE_CODES_DIR
unset WD
unset EDK2_DIR
unset EDK2_BUILD_TOOLS_DIR
unset EDK2_C_SOURCE_DIR
unset EDK_TOOLS_PATH
unset UNIXPKG_BUILD_DIR

set +x +e

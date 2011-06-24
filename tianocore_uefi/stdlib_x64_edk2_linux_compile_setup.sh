#!/bin/bash

set -x -e

SOURCE_CODES_DIR="/media/Source_Codes/Source_Codes"
WD="${SOURCE_CODES_DIR}/Firmware/UEFI/TianoCore_Sourceforge"

source "${WD}/tianocore_common.sh"

EDK2_BUILD_OUTER_DIR="${EDK2_DIR}/Build/StdLib/"
EDK2_BUILD_DIR="${EDK2_BUILD_OUTER_DIR}/DEBUG_GCC45/"

STDLIB_BUILD_DIR="${BACKUP_BUILDS_DIR}/STDLIB_BUILD"

COMPILE_STDLIB() {
	
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
	
	COMPILE_BASETOOLS_MANUAL
	
	echo
	
	build -p "${EDK2_DIR}/StdLib/StdLib.dsc" -a X64 -b DEBUG -t GCC45
	
	echo
	
	cp -r "${EDK2_BUILD_DIR}" "${STDLIB_BUILD_DIR}"
	
	echo
	
	EDK2_BUILD_CLEAN
	
	echo
	
	SET_PYTHON3
	
	echo
	
}

echo

COMPILE_STDLIB

echo

unset SOURCE_CODES_DIR
unset WD
unset EDK2_DIR
unset EDK2_BUILD_TOOLS_DIR
unset EDK2_C_SOURCE_DIR
unset EDK_TOOLS_PATH
unset STDLIB_BUILD_DIR
unset BACKUP_BUILDS_DIR

set +x +e

#!/bin/bash

set -x -e

SOURCE_CODES_DIR="/media/Source_Codes/Source_Codes"
WD="${SOURCE_CODES_DIR}/Firmware/UEFI/TianoCore_Sourceforge"

source "${WD}/tianocore_duet_common.sh"

EDK2_BUILD_OUTER_DIR="${EDK2_DIR}/Build/StdLib/"
EDK2_BUILD_DIR="${EDK2_BUILD_OUTER_DIR}/DEBUG_GCC45/"

ISO9660_BUILD_DIR="${BACKUP_BUILDS_DIR}/ISO9660_BUILD"

_COMPILE_ISO9660() {
	
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
	
	sed -i 's|TARGET_ARCH           = IA32|TARGET_ARCH           = X64|g' "${EDK2_DIR}/Conf/target.txt"
	sed -i 's|ACTIVE_PLATFORM       = Nt32Pkg/Nt32Pkg.dsc|ACTIVE_PLATFORM       = DuetPkg/DuetPkgX64.dsc|g' "${EDK2_DIR}/Conf/target.txt"
	
	echo
	
	build -p "${EDK2_DIR}/DuetPkg/DuetPkgX64.dsc" -m "${EDK2_DIR}/VBoxPkg/VBoxFsDxe/VBoxIso9660.inf" -a X64 -b RELEASE -t GCC45
	
	echo
	
	cp -r "${EDK2_BUILD_DIR}" "${ISO9660_BUILD_DIR}"
	
	echo
	
	_EDK2_BUILD_CLEAN
	
	echo
	
	_SET_PYTHON3
	
	echo
	
}

echo

_COMPILE_ISO9660

echo

unset SOURCE_CODES_DIR
unset WD
unset EDK2_DIR
unset EDK2_BUILD_TOOLS_DIR
unset EDK2_C_SOURCE_DIR
unset EDK_TOOLS_PATH
unset ISO9660_BUILD_DIR
unset BACKUP_BUILDS_DIR

set +x +e

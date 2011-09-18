#!/bin/bash

set -x -e

SOURCE_CODES_DIR="/media/Source_Codes/Source_Codes"
WD="${SOURCE_CODES_DIR}/Firmware/UEFI/TianoCore_Sourceforge"
BACKUP_BUILDS_DIR="${WD}/BACKUP_BUILDS"

EDK2_DIR="${WD}/edk2_GIT"
EDK2_BUILD_TOOLS_DIR="${WD}/buildtools-BaseTools_GIT"

export EDK_TOOLS_PATH="${EDK2_DIR}/BaseTools"

EDK2_C_SOURCE_DIR="${EDK2_BUILD_TOOLS_DIR}/Source/C"

_EDK2_TOOLS_PATH_CLEAN() {
	
	rm -rf "${EDK_TOOLS_PATH}" || true
	
}

_EDK2_BUILD_CLEAN() {
	
	echo
	
	_EDK2_TOOLS_PATH_CLEAN
	
	echo
	
	rm -rf "${EDK2_BUILD_OUTER_DIR}" || true
	rm -rf "${EDK2_DIR}/Build" || true
	rm -rf "${EDK2_DIR}/Conf" || true
	
	echo
	
	cd "${EDK2_DIR}/"
	git reset --hard
	git checkout keshav_pr
	
	echo
	
}

_COPY_BUILDTOOLS_BASETOOLS() {
	
	echo
	
	_EDK2_TOOLS_PATH_CLEAN
	
	echo
	
	cp -r "${EDK2_BUILD_TOOLS_DIR}" "${EDK_TOOLS_PATH}"
	
	echo
	
}

_COMPILE_BASETOOLS_MANUAL() {
	
	echo
	
	cd "${EDK2_DIR}/"
	source "${EDK2_DIR}/edksetup.sh" BaseTools
	
	echo
	
	cd "${EDK2_DIR}/"
	make -C "${EDK2_DIR}/BaseTools"
	
	echo
	
}

_CORRECT_WERROR() {
	
	echo
	
	sed -i 's|-Werror|-Wno-error|g' "${EDK2_DIR}/BaseTools/Source/C/Makefiles"/*
	sed -i 's|-Werror|-Wno-error|g' "${EDK2_DIR}/BaseTools/Conf/tools_def.template"
	sed -i 's|--64||g' "${EDK2_DIR}/BaseTools/Conf/tools_def.template"
	
	echo
	
}

_SET_PYTHON2() {
	
	echo
	
	# _PYTHON_="$(which python)"
	# sudo rm -f "${_PYTHON_}"
	# sudo ln -s "$(which python2)" "${_PYTHON_}"
	# unset _PYTHON_
	
	export PYTHON="python2"
	
	echo
	
}

_SET_PYTHON3() {
	
	echo
	
	# _PYTHON_="$(which python)"
	# sudo rm -f "${_PYTHON_}"
	# sudo ln -s "$(which python3)" "${_PYTHON_}"
	# unset _PYTHON_
	
	export PYTHON="python3"
	
	echo
	
}

_APPLY_PATCHES() {
	
	echo
	
}

_APPLY_CHANGES() {
	
	echo
	
	## DuetPkg
	# sed -i 's|#define EFI_PAGE_BASE_OFFSET_IN_LDR 0x70000|#define EFI_PAGE_BASE_OFFSET_IN_LDR 0x80000|g' "${EDK_TOOLS_PATH}/Source/C/GenPage/GenPage.c" || true
	
	## EmulatorPkg
	sed -i 's|export LIB_ARCH_SFX=64|export LIB_ARCH_SFX=""|g' "${EDK2_DIR}/EmulatorPkg/build.sh"
	# sed -i 's|UNIXPKG_TOOLS=GCC44|UNIXPKG_TOOLS=GCC45|g' "${EDK2_DIR}/EmulatorPkg/build.sh"
	
	echo
	
}

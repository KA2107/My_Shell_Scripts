#!/bin/bash

set -x -e

SOURCE_CODES_DIR="/media/Data_2/Source_Codes"
WD="${SOURCE_CODES_DIR}/Firmware/UEFI/TianoCore_Sourceforge"
BACKUP_BUILDS_DIR="${WD}/BACKUP_BUILDS"

EDK2_DIR="${WD}/edk2_GIT"
EDK2_BUILD_TOOLS_DIR="${WD}/buildtools-BaseTools_GIT"

export EDK_TOOLS_PATH="${EDK2_DIR}/BaseTools"

EDK2_C_SOURCE_DIR="${EDK2_BUILD_TOOLS_DIR}/Source/C"

EDK2_BUILD_CLEAN() {
	
	echo
	
	rm -rf "${EDK_TOOLS_PATH}" || true
	rm -rf "${EDK2_BUILD_OUTER_DIR}" || true
	rm -rf "${EDK2_DIR}/Build" || true
	rm -rf "${EDK2_DIR}/Conf" || true
	
	echo
	
	cd "${EDK2_DIR}/"
	git reset --hard
	git checkout keshav_pr
	
	echo
	
}

COPY_BUILDTOOLS_BASETOOLS() {
	
	echo
	
	rm -rf "${EDK_TOOLS_PATH}" || true
	cp -r "${EDK2_BUILD_TOOLS_DIR}" "${EDK2_DIR}/BaseTools"
	
	echo
	
}

COMPILE_BASETOOLS_MANUAL() {
	
	echo
	
	cd "${EDK2_DIR}/"
	source "${EDK2_DIR}/edksetup.sh" BaseTools
	
	echo
	
	cd "${EDK2_DIR}/"
	make -C "${EDK2_DIR}/BaseTools"
	
	echo
	
}

CORRECT_WERROR() {
	
	echo
	
	sed -i 's|-Werror||g' "${EDK2_DIR}/BaseTools/Source/C/Makefiles"/*
	sed -i 's|-Werror||g' "${EDK2_DIR}/BaseTools/Conf/tools_def.template"
	sed -i 's|--64||g' "${EDK2_DIR}/BaseTools/Conf/tools_def.template"
	
	echo
	
}

SET_PYTHON2() {
	
	echo
	
	_PYTHON_="$(which python)"
	sudo rm "${_PYTHON_}"
	sudo ln -s "$(which python2)" "${_PYTHON_}"
	unset _PYTHON_
	
	echo
	
}

SET_PYTHON3() {
	
	echo
	
	_PYTHON_="$(which python)"
	sudo rm "${_PYTHON_}"
	sudo ln -s "$(which python3)" "${_PYTHON_}"
	unset _PYTHON_
	
	echo
	
}

APPLY_PATCHES() {
	
	echo
	
}

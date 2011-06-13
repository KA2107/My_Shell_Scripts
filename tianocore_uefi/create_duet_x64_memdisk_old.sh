#!/bin/sh

set -x -e

SOURCE_CODES_DIR="/media/Data_2/Source_Codes"
WD="${SOURCE_CODES_DIR}/Firmware/UEFI/TianoCore_Sourceforge"

source "${WD}/tianocore_duet_common.sh"

CREATE_FLOPPY_MEMDISK_EMUVARIABLE() {
	
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
	
	export WORKSPACE="${EDK2_DIR}/"
	
	echo
	
	mkdir -p "${EDK2_BUILD_OUTER_DIR}"
	cp -r "${DUET_EMUVARIABLE_BUILD_DIR}" "${EDK2_BUILD_DIR}"
	
	echo
	
	cd "${EDK_TOOLS_PATH}"
	make
	
	echo
	
	"${WORKSPACE}/DuetPkg/CreateBootDisk.sh" file "${DUET_EMUVARIABLE_BUILD_DIR}/floppy.img" /dev/null FAT12 X64 GCC45 RELEASE
	
	EDK2_BUILD_CLEAN
	
	echo
	
	SET_PYTHON3
	
	echo
}

CREATE_FLOPPY_MEMDISK_FSVARIABLE() {
	
	echo
	
	SET_PYTHON2
	
	echo
	
	EDK2_BUILD_CLEAN
	
	echo
	
	cd "${EDK2_DIR}/"
	git checkout duet_fsvariable
	
	echo
	
	COPY_BUILDTOOLS_BASETOOLS
	
	echo
	
	CORRECT_WERROR
	
	echo
	
	export WORKSPACE="${EDK2_DIR}/"
	
	echo
	
	mkdir -p "${EDK2_BUILD_OUTER_DIR}"
	cp -r "${DUET_FSVARIABLE_BUILD_DIR}" "${EDK2_BUILD_DIR}"
	
	echo
	
	cd "${EDK_TOOLS_PATH}"
	make
	
	echo
	
	"${WORKSPACE}/DuetPkg/CreateBootDisk.sh" file "${DUET_FSVARIABLE_BUILD_DIR}/floppy.img" /dev/null FAT12 X64 GCC45 RELEASE
	
	echo
	
	EDK2_BUILD_CLEAN
	
	echo
	
	SET_PYTHON3
	
	echo
}

echo

CREATE_FLOPPY_MEMDISK_EMUVARIABLE

echo

# CREATE_FLOPPY_MEMDISK_FSVARIABLE

echo

unset SOURCE_CODES_DIR
unset WD
unset EDK2_DIR
unset EDK2_BUILD_TOOLS_DIR
unset EDK2_C_SOURCE_DIR
unset EDK2_DUET_BOOTSECT_BIN_DIR
unset EDK2_BUILD_DIR
unset DUET_EMUVARIABLE_BUILD_DIR
unset DUET_FSVARIABLE_BUILD_DIR
unset COMPILED_DIR
unset EFI_DUET_GIT_DIR
unset MEMDISK_COMPILED_DIR
unset MEMDISK_DIR
unset MIGLE_BOOTDUET_COMPILE_DIR
unset SRS5694_DUET_INSTALL_DIR
unset BOOTPART
unset EFISYS
unset SYSLINUX_DIR
unset WORKSPACE

set +x +e

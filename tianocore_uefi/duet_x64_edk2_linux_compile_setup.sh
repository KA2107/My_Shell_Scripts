#!/bin/sh

set -x -e

SOURCE_CODES_DIR="/media/Data_2/Source_Codes"
WD="${SOURCE_CODES_DIR}/Firmware/UEFI/TianoCore_Sourceforge"

source "${WD}/tianocore_duet_common.sh"

DUET_PART_FS_UUID="5FA3-2472"
DUET_PART_MP="/media/DUET"

COPY_EFILDR_DUET_PART() {
	
	echo
	
	sudo umount "${DUET_PART_MP}" || true
	sudo mount -t vfat -o rw,users,exec -U "${DUET_PART_FS_UUID}" "${DUET_PART_MP}"
	sudo rm "${DUET_PART_MP}/EFILDR20" || true
	sudo cp "${EDK2_BUILD_DIR}/FV/Efildr20" "${DUET_PART_MP}/EFILDR20"
	sudo umount "${DUET_PART_MP}"
	
	echo
	
}

COPY_UEFI_SHELL_EFISYS_PART() {
	
	echo
	
	sudo rm "${EFISYS}/shellx64.efi" || true
	sudo rm "${EFISYS}/shellx64_old.efi" || true
	
	echo
	
	sudo cp "${EDK2_DIR}/ShellBinPkg/UefiShell/X64/Shell.efi" "${EFISYS}/shellx64.efi"
	sudo cp "${EDK2_DIR}/EdkShellBinPkg/FullShell/X64/Shell_Full.efi" "${EFISYS}/shellx64_old.efi"
	
	echo
	
}

COMPILE_DUET_EMUVARIABLE_BRANCH() {
	
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
	
	cd "${EDK2_DIR}/DuetPkg"
	"${EDK2_DIR}/DuetPkg/build64.sh"
	
	echo
	
	cp -r "${EDK2_BUILD_DIR}" "${DUET_EMUVARIABLE_BUILD_DIR}"
	cp "${EDK2_BUILD_OUTER_DIR}/floppy.img" "${DUET_EMUVARIABLE_BUILD_DIR}/floppy.img"
	
	echo
	
	EDK2_BUILD_CLEAN
	
	echo
	
	SET_PYTHON3
	
	echo
}

COMPILE_DUET_FSVARIABLE_BRANCH() {
	
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
	
	APPLY_PATCHES
	
	echo
	
	cd "${EDK2_DIR}/DuetPkg"
	"${EDK2_DIR}/DuetPkg/build64.sh"
	
	echo
	
	cp -r "${EDK2_BUILD_DIR}" "${DUET_FSVARIABLE_BUILD_DIR}"
	cp "${EDK2_BUILD_OUTER_DIR}/floppy.img" "${DUET_FSVARIABLE_BUILD_DIR}/floppy.img"
	
	echo
	
	EDK2_BUILD_CLEAN
	
	echo
	
	SET_PYTHON3
	
	echo
}

echo

COMPILE_DUET_EMUVARIABLE_BRANCH

echo

COMPILE_DUET_FSVARIABLE_BRANCH

echo

COPY_EFILDR_DUET_PART

echo

COPY_UEFI_SHELL_EFISYS_PART

echo

cd "${WD}/"
# "${WD}/post_duet_x64_compile.sh"

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
unset DUET_PART_FS_UUID
unset DUET_PART_MP

set +x +e

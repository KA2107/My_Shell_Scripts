#!/bin/bash

set -x -e

export SOURCE_CODES_DIR="/media/Source_Codes/Source_Codes"
export SCRIPTS_DIR="${SOURCE_CODES_DIR}/My_Shell_Scripts"

export GRUB2_SCRIPTS_DIR="${SCRIPTS_DIR}/grub2"
export TIANO_SCRIPTS_DIR="${SCRIPTS_DIR}/tianocore_uefi"

export GRUB2_DIR="${SOURCE_CODES_DIR}/Utilities/Boot_Managers__UEFI_GPT/grub2"
export GRUB2_SOURCE_DIR="${GRUB2_DIR}/Source"
export TIANO_SOURCE_DIR="${SOURCE_CODES_DIR}/Firmware/UEFI/TianoCore_Sourceforge"

export GRUB2_BIOS_DIR="${GRUB2_SOURCE_DIR}/grub2_bios_linux_scripts"
export GRUB2_UEFI_DIR="${GRUB2_SOURCE_DIR}/grub2_uefi_linux_scripts"

echo

CREATE_SYMLINK() {
	
	echo
	
	rm "${LINK_DIR}/${LINK_FILE}" || true
	ln -s "${SOURCE_DIR}/${LINK_FILE}" "${LINK_DIR}/${LINK_FILE}"
	
	echo
	
}

COPY_FILE() {
	
	echo
	
	rm "${LINK_DIR}/${LINK_FILE}" || true
	cp "${SOURCE_DIR}/${LINK_FILE}" "${LINK_DIR}/${LINK_FILE}"
	
	echo
	
}

GRUB2() {
	
	echo
	
	SOURCE_DIR="${GRUB2_SCRIPTS_DIR}/"
	LINK_DIR="${GRUB2_SOURCE_DIR}/"
	LINK_FILE="compile_grub2.sh"
	CREATE_SYMLINK
	
	echo
	
	SOURCE_DIR="${GRUB2_SCRIPTS_DIR}/"
	LINK_DIR="${GRUB2_SOURCE_DIR}/"
	LINK_FILE="grub.default"
	COPY_FILE
	
	echo
	
	SOURCE_DIR="${GRUB2_SCRIPTS_DIR}/"
	LINK_DIR="${GRUB2_UEFI_DIR}/"
	LINK_FILE="grub2_uefi.sh"
	CREATE_SYMLINK
	
	echo
	
	SOURCE_DIR="${GRUB2_SCRIPTS_DIR}/"
	LINK_DIR="${GRUB2_UEFI_DIR}/"
	LINK_FILE="grub2_uefi_mkimage_x64_linux.sh"
	CREATE_SYMLINK
	
	echo
	
	SOURCE_DIR="${GRUB2_SCRIPTS_DIR}/"
	LINK_DIR="${GRUB2_BIOS_DIR}/"
	LINK_FILE="grub2_bios.sh"
	CREATE_SYMLINK
	
	echo
	
	SOURCE_DIR="${GRUB2_SCRIPTS_DIR}/"
	LINK_DIR="${GRUB2_DIR}/Source_BZR/"
	LINK_FILE="grub2_bzr_export.sh"
	CREATE_SYMLINK
	
	echo
	
	SOURCE_DIR="${SCRIPTS_DIR}/xmanutility/"
	LINK_DIR="${GRUB2_SOURCE_DIR}/"
	LINK_FILE="xman_dos2unix.sh"
	CREATE_SYMLINK
	
	echo
	
	SOURCE_DIR="${SCRIPTS_DIR}/bzr/"
	LINK_DIR="${GRUB2_DIR}/Source_BZR/"
	LINK_FILE="bzr_update.sh"
	CREATE_SYMLINK
	
	echo
	
	unset SOURCE_DIR
	unset LINK_DIR
	unset LINK_FILE
	
	echo
	
}

TIANOCORE() {
	
	echo
	
	SOURCE_DIR="${TIANO_SCRIPTS_DIR}/"
	LINK_DIR="${TIANO_SOURCE_DIR}/"
	
	LINK_FILE="tianocore_common.sh"
	CREATE_SYMLINK
	
	LINK_FILE="tianocore_duet_common.sh"
	CREATE_SYMLINK
	
	LINK_FILE="duet_x64_edk2_linux_compile_setup.sh"
	CREATE_SYMLINK
	
	LINK_FILE="post_duet_x64_compile.sh"
	CREATE_SYMLINK
	
	LINK_FILE="create_duet_x64_memdisk_old.sh"
	CREATE_SYMLINK
	
	LINK_FILE="create_duet_x64_memdisk_new.sh"
	CREATE_SYMLINK
	
	echo
	
	SOURCE_DIR="${TIANO_SCRIPTS_DIR}/"
	LINK_DIR="${TIANO_SOURCE_DIR}/"
	
	LINK_FILE="ovmf_x64_edk2_linux_compile_setup.sh"
	CREATE_SYMLINK
	
	LINK_FILE="stdlib_x64_edk2_linux_compile_setup.sh"
	CREATE_SYMLINK
	
	LINK_FILE="unixpkg_x64_edk2_linux_compile_setup.sh"
	CREATE_SYMLINK
	
	LINK_FILE="iso9660_vbox_x64_edk2_linux_compile_setup.sh"
	CREATE_SYMLINK
	
	echo
	
	SOURCE_DIR="${TIANO_SCRIPTS_DIR}/"
	LINK_DIR="${TIANO_SOURCE_DIR}/"
	
	LINK_FILE="compile_edk2_duet_x64.cmd"
	COPY_FILE
	
	LINK_FILE="compile_edk2_ovmf_x64.cmd"
	COPY_FILE
	
	LINK_FILE="compile_edk_duet_uefi64.cmd"
	COPY_FILE
	
	LINK_FILE="compile_edk2_nt32pkg.cmd"
	COPY_FILE
	
	echo
	
	unset SOURCE_DIR
	unset LINK_DIR
	unset LINK_FILE
	
	echo
	
}

echo

SOURCE_DIR="${SCRIPTS_DIR}/git/"
LINK_DIR="${SOURCE_CODES_DIR}/"
LINK_FILE="git_update.sh"
CREATE_SYMLINK

echo

SOURCE_DIR="${SCRIPTS_DIR}/bzr/"
LINK_DIR="${SOURCE_CODES_DIR}/"
LINK_FILE="bzr_update.sh"
CREATE_SYMLINK

echo

TIANOCORE

echo

GRUB2

echo

unset SOURCE_CODES_DIR
unset SCRIPTS_DIR
unset GRUB2_SCRIPTS_DIR
unset TIANO_SCRIPTS_DIR
unset GRUB2_DIR
unset GRUB2_SOURCE_DIR
unset TIANO_SOURCE_DIR
unset GRUB2_BIOS_DIR
unset GRUB2_UEFI_DIR

set +x +e

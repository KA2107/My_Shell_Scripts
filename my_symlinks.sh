#!/bin/sh

set -x -e

export SOURCE_CODES_DIR="/media/Data_2/Source_Codes"
export SCRIPTS_DIR="${SOURCE_CODES_DIR}/My_Shell_Scripts"

export GRUB2_SCRIPTS_DIR="${SCRIPTS_DIR}/grub2"
export TIANO_SCRIPTS_DIR="${SCRIPTS_DIR}/tianocore_uefi"

export GRUB2_DIR="${SOURCE_CODES_DIR}/Utilities/Boot_Managers__UEFI_GPT/grub2"
export GRUB2_SOURCE_DIR="${GRUB2_DIR}/Source"
export TIANO_SOURCE_DIR="${SOURCE_CODES_DIR}/Firmware/UEFI/TianoCore_Sourceforge"

export GRUB2_BIOS_DIR="${GRUB2_SOURCE_DIR}/grub2_bios_linux_scripts"
export GRUB2_UEFI_DIR="${GRUB2_SOURCE_DIR}/grub2_uefi_linux_scripts"

echo

BASIC_COMMANDS() {
	
	echo
	
	rm "${LINK_DIR}/${LINK_FILE}" || true
	ln -s "${SOURCE_DIR}/${LINK_FILE}" "${GRUB2_SOURCE_DIR}/${LINK_FILE}"
	
	echo
	
}

GRUB2() {
	
	echo
	
	SOURCE_DIR="${GRUB2_SCRIPTS_DIR}/"
	LINK_DIR="${GRUB2_SOURCE_DIR}/"
	
	LINK_FILE="compile_grub2.sh"
	BASIC_COMMANDS
	
	LINK_FILE="grub.default"
	BASIC_COMMANDS
	
	echo
	
	rm "${GRUB2_SOURCE_DIR}/xman_dos2unix.sh" || true
	ln -s "${SCRIPTS_DIR}/xmanutility/xman_dos2unix.sh" "${GRUB2_SOURCE_DIR}/xman_dos2unix.sh"
	
	echo
	
	rm "${GRUB2_BIOS_DIR}/grub2_bios.sh" || true
	ln -s "${GRUB2_SCRIPTS_DIR}/grub2_bios.sh" "${GRUB2_BIOS_DIR}/grub2_bios.sh"
	
	rm "${GRUB2_UEFI_DIR}/grub2_uefi.sh" || true
	ln -s "${GRUB2_SCRIPTS_DIR}/grub2_uefi.sh" "${GRUB2_UEFI_DIR}/grub2_uefi.sh"
	
	rm "${GRUB2_UEFI_DIR}/grub2_uefi_mkimage_x64_linux.sh" || true
	ln -s "${GRUB2_SCRIPTS_DIR}/grub2_uefi_mkimage_x64_linux.sh" "${GRUB2_UEFI_DIR}/grub2_uefi_mkimage_x64_linux.sh"
	
	rm "${GRUB2_DIR}/Source_BZR/grub2_bzr_export.sh" || true
	ln -s "${GRUB2_SCRIPTS_DIR}/grub2_bzr_export.sh" "${GRUB2_DIR}/Source_BZR/grub2_bzr_export.sh"
	
	echo
	
}

TIANOCORE() {
	
	echo
	
	SOURCE_DIR="${TIANO_SCRIPTS_DIR}/"
	LINK_DIR="${TIANO_SOURCE_DIR}/"
	
	LINK_FILE="tianocore_common.sh"
	BASIC_COMMANDS
	
	LINK_FILE="tianocore_duet_common.sh"
	BASIC_COMMANDS
	
	LINK_FILE="duet_x64_edk2_linux_compile_setup.sh"
	BASIC_COMMANDS
	
	LINK_FILE="post_duet_x64_compile.sh"
	BASIC_COMMANDS
	
	LINK_FILE="create_duet_x64_memdisk_old"
	BASIC_COMMANDS
	
	LINK_FILE="create_duet_x64_memdisk_new.sh"
	BASIC_COMMANDS
	
	LINK_FILE="ovmf_x64_edk2_linux_compile_setup.sh"
	BASIC_COMMANDS
	
	LINK_FILE="stdlib_x64_edk2_linux_compile_setup.sh"
	BASIC_COMMANDS
	
	LINK_FILE="unix_x64_edk2_linux_compile_setup.sh"
	BASIC_COMMANDS
	
	LINK_FILE="vbox_x64_edk2_linux_compile_setup.sh"
	BASIC_COMMANDS
	
	echo
	
}

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

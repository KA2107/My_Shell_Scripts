#!/bin/bash

set -x -e

WD="${PWD}/"

export SOURCE_CODES_DIR="/media/Source_Codes/Source_Codes"
export SCRIPTS_DIR="${SOURCE_CODES_DIR}/My_Shell_Scripts"

export GRUB2_SCRIPTS_DIR="${SCRIPTS_DIR}/grub2"
export TIANO_SCRIPTS_DIR="${SCRIPTS_DIR}/tianocore_uefi"

export GRUB2_DIR="${SOURCE_CODES_DIR}/Utilities/Boot_Managers__UEFI_GPT/grub2"
export GRUB2_SOURCE_DIR="${GRUB2_DIR}/Source"
export TIANO_SOURCE_DIR="${SOURCE_CODES_DIR}/Firmware/UEFI/TianoCore_Sourceforge"

export GRUB2_BIOS_SCRIPTS_DIR="${GRUB2_SOURCE_DIR}/grub2_bios_linux_scripts"
export GRUB2_UEFI_SCRIPTS_DIR="${GRUB2_SOURCE_DIR}/grub2_uefi_linux_scripts"

echo

CREATE_SYMLINK() {
	
	echo
	
	if [ ! -d "${LINK_DIR}/${LINK_FILE}" ]
	then
		rm -f "${LINK_DIR}/${LINK_FILE}" || true
		ln -s "${SOURCE_DIR}/${SOURCE_FILE}" "${LINK_DIR}/${LINK_FILE}"
	fi
	
	echo
	
}

SUDO_CREATE_SYMLINK() {
	
	echo
	
	if [ ! -d "${LINK_DIR}/${LINK_FILE}" ]
	then
		sudo rm -f "${LINK_DIR}/${LINK_FILE}" || true
		sudo ln -s "${SOURCE_DIR}/${SOURCE_FILE}" "${LINK_DIR}/${LINK_FILE}"
	fi
	
	echo
	
}

COPY_FILE() {
	
	echo
	
	if [ ! -d "${LINK_DIR}/${LINK_FILE}" ]
	then
		rm -f "${LINK_DIR}/${LINK_FILE}" || true
		cp "${SOURCE_DIR}/${SOURCE_FILE}" "${LINK_DIR}/${LINK_FILE}"
	fi
	
	echo
	
}

SUDO_COPY_FILE() {
	
	echo
	
	if [ ! -d "${LINK_DIR}/${LINK_FILE}" ]
	then
		sudo rm -f "${LINK_DIR}/${LINK_FILE}" || true
		sudo cp "${SOURCE_DIR}/${SOURCE_FILE}" "${LINK_DIR}/${LINK_FILE}"
	fi
	
	echo
	
}

GRUB2() {
	
	echo
	
	SOURCE_DIR="${GRUB2_SCRIPTS_DIR}/"
	SOURCE_FILE="compile_grub2.sh"
	LINK_DIR="${GRUB2_SOURCE_DIR}/"
	LINK_FILE="${SOURCE_FILE}"
	CREATE_SYMLINK
	
	echo
	
	SOURCE_DIR="${GRUB2_SCRIPTS_DIR}/"
	SOURCE_FILE="grub.default"
	LINK_DIR="${GRUB2_SOURCE_DIR}/"
	LINK_FILE="${SOURCE_FILE}"
	COPY_FILE
	
	echo
	
	SOURCE_DIR="${GRUB2_SCRIPTS_DIR}/"
	SOURCE_FILE="grub2_uefi.sh"
	LINK_DIR="${GRUB2_UEFI_SCRIPTS_DIR}/"
	LINK_FILE="${SOURCE_FILE}"
	CREATE_SYMLINK
	
	echo
	
	SOURCE_DIR="${GRUB2_SCRIPTS_DIR}/"
	SOURCE_FILE="grub2_uefi_mkimage_x64_linux.sh"
	LINK_DIR="${GRUB2_UEFI_SCRIPTS_DIR}/"
	LINK_FILE="${SOURCE_FILE}"
	CREATE_SYMLINK
	
	echo
	
	SOURCE_DIR="${GRUB2_SCRIPTS_DIR}/"
	SOURCE_FILE="grub2_bios.sh"
	LINK_DIR="${GRUB2_BIOS_SCRIPTS_DIR}/"
	LINK_FILE="${SOURCE_FILE}"
	CREATE_SYMLINK
	
	echo
	
	SOURCE_DIR="${GRUB2_SCRIPTS_DIR}/"
	SOURCE_FILE="grub2_bzr_export.sh"
	LINK_DIR="${GRUB2_DIR}/Source_BZR/"
	LINK_FILE="${SOURCE_FILE}"
	CREATE_SYMLINK
	
	echo
	
	SOURCE_DIR="${SCRIPTS_DIR}/xmanutility/"
	SOURCE_FILE="xman_dos2unix.sh"
	LINK_DIR="${GRUB2_SOURCE_DIR}/"
	LINK_FILE="${SOURCE_FILE}"
	CREATE_SYMLINK
	
	echo
	
	SOURCE_DIR="${SCRIPTS_DIR}/bzr/"
	SOURCE_FILE="grub2_bzr_export.sh"
	LINK_DIR="${GRUB2_DIR}/Source_BZR/"
	LINK_FILE="${SOURCE_FILE}"
	CREATE_SYMLINK
	
	echo
	
	unset SOURCE_DIR
	unset SOURCE_FILE
	unset LINK_DIR
	unset LINK_FILE
	
	echo
	
}

TIANOCORE() {
	
	echo
	
	SOURCE_DIR="${TIANO_SCRIPTS_DIR}/"
	LINK_DIR="${TIANO_SOURCE_DIR}/"
	
	SOURCE_FILE="tianocore_common.sh"
	LINK_FILE="${SOURCE_FILE}"
	CREATE_SYMLINK
	
	SOURCE_FILE="tianocore_duet_common.sh"
	LINK_FILE="${SOURCE_FILE}"
	CREATE_SYMLINK
	
	SOURCE_FILE="duet_x64_edk2_linux_compile_setup.sh"
	LINK_FILE="${SOURCE_FILE}"
	CREATE_SYMLINK
	
	SOURCE_FILE="post_duet_x64_compile.sh"
	LINK_FILE="${SOURCE_FILE}"
	CREATE_SYMLINK
	
	SOURCE_FILE="create_duet_x64_memdisk_old.sh"
	LINK_FILE="${SOURCE_FILE}"
	CREATE_SYMLINK
	
	SOURCE_FILE="create_duet_x64_memdisk_new.sh"
	LINK_FILE="${SOURCE_FILE}"
	CREATE_SYMLINK
	
	echo
	
	SOURCE_DIR="${TIANO_SCRIPTS_DIR}/"
	LINK_DIR="${TIANO_SOURCE_DIR}/"
	
	SOURCE_FILE="ovmf_x64_edk2_linux_compile_setup.sh"
	LINK_FILE="${SOURCE_FILE}"
	CREATE_SYMLINK
	
	SOURCE_FILE="stdlib_x64_edk2_linux_compile_setup.sh"
	LINK_FILE="${SOURCE_FILE}"
	CREATE_SYMLINK
	
	SOURCE_FILE="emulatorpkg_unix_x64_edk2_linux_compile_setup.sh"
	LINK_FILE="${SOURCE_FILE}"
	CREATE_SYMLINK
	
	SOURCE_FILE="unixpkg_x64_edk2_linux_compile_setup.sh"
	LINK_FILE="${SOURCE_FILE}"
	CREATE_SYMLINK
	
	SOURCE_FILE="iso9660_vbox_x64_edk2_linux_compile_setup.sh"
	LINK_FILE="${SOURCE_FILE}"
	CREATE_SYMLINK
	
	echo
	
	SOURCE_DIR="${TIANO_SCRIPTS_DIR}/"
	LINK_DIR="${TIANO_SOURCE_DIR}/"
	
	SOURCE_FILE="compile_edk2_duet_x64.cmd"
	LINK_FILE="${SOURCE_FILE}"
	COPY_FILE
	
	SOURCE_FILE="compile_edk2_ovmf_x64.cmd"
	LINK_FILE="${SOURCE_FILE}"
	COPY_FILE
	
	SOURCE_FILE="compile_edk_duet_uefi64.cmd"
	LINK_FILE="${SOURCE_FILE}"
	COPY_FILE
	
	SOURCE_FILE="compile_edk2_nt32pkg.cmd"
	LINK_FILE="${SOURCE_FILE}"
	COPY_FILE
	
	echo
	
	unset SOURCE_DIR
	unset SOURCE_FILE
	unset LINK_DIR
	unset LINK_FILE
	
	echo
	
}

COPY_BIOS_BOOTLOADER_FILES() {
	
	echo
	
	BOOT_PART="/boot"
	
	SOURCE_DIR="${GRUB2_BIOS_SCRIPTS_DIR}/"
	
	SOURCE_FILE="syslinux_bios.cfg"
	LINK_DIR="${BOOT_PART}/syslinux/"
	LINK_FILE="syslinux.cfg"
	[ -d "${LINK_DIR}/" ] && SUDO_COPY_FILE
	
	SOURCE_FILE="grub2_bios.cfg"
	LINK_DIR="${BOOT_PART}/grub2_bios/"
	LINK_FILE="grub.cfg"
	[ -d "${LINK_DIR}/" ] && SUDO_COPY_FILE
	
	SOURCE_FILE="grub2_bios.cfg"
	LINK_DIR="${BOOT_PART}/grub/"
	LINK_FILE="grub.cfg"
	[ -d "${LINK_DIR}/" ] && SUDO_COPY_FILE
	
	echo
	
	unset BOOT_PART
	unset SOURCE_DIR
	unset SOURCE_FILE
	unset LINK_DIR
	unset LINK_FILE
	
	echo
	
}

COPY_UEFI_BOOTLOADER_FILES() {
	
	echo
	
	UEFI_SYS_PART_DIR="/boot/efi/efi"
	
	SOURCE_DIR="${GRUB2_UEFI_SCRIPTS_DIR}/"
	
	SOURCE_FILE="grub2_uefi.cfg"
	LINK_DIR="${UEFI_SYS_PART_DIR}/grub2_uefi_x86_64/"
	LINK_FILE="grub.cfg"
	[ -d "${LINK_DIR}/" ] && SUDO_COPY_FILE
	
	SOURCE_FILE="grub2_uefi.cfg"
	LINK_DIR="${UEFI_SYS_PART_DIR}/grub/"
	LINK_FILE="grub.cfg"
	[ -d "${LINK_DIR}/" ] && SUDO_COPY_FILE
	
	SOURCE_FILE="grub-legacy_uefi.conf"
	LINK_DIR="${UEFI_SYS_PART_DIR}/grub-legacy/"
	LINK_FILE="grub-legacy.conf"
	[ -d "${LINK_DIR}/" ] && SUDO_COPY_FILE
	
	SOURCE_FILE="elilo.conf"
	LINK_DIR="${UEFI_SYS_PART_DIR}/elilo/"
	LINK_FILE="${SOURCE_FILE}"
	[ -d "${LINK_DIR}/" ] && SUDO_COPY_FILE
	
	echo
	
	unset UEFI_SYS_PART_DIR
	unset SOURCE_DIR
	unset SOURCE_FILE
	unset LINK_DIR
	unset LINK_FILE
	
	echo
	
}

echo

SOURCE_DIR="${SCRIPTS_DIR}/git/"
SOURCE_FILE="git_update.sh"
LINK_DIR="${SOURCE_CODES_DIR}/"
LINK_FILE="${SOURCE_FILE}"
CREATE_SYMLINK

echo

SOURCE_DIR="${SCRIPTS_DIR}/bzr/"
SOURCE_FILE="bzr_update.sh"
LINK_DIR="${SOURCE_CODES_DIR}/"
LINK_FILE="${SOURCE_FILE}"
CREATE_SYMLINK

echo

TIANOCORE

echo

GRUB2

echo

COPY_BIOS_BOOTLOADER_FILES

echo

COPY_UEFI_BOOTLOADER_FILES

echo

ls --color=none -1 "/var/lib/pacman/local/" | sed 's#\/##g' > "/media/Source_Codes/Source_Codes/Pacman_Installed_Packages_List.txt"
ls --color=none -1 "/var/cache/pacman/pkg/" > "/media/Source_Codes/Source_Codes/Pacman_Packages_Cache_List.txt"

echo

unset WD
unset SOURCE_CODES_DIR
unset SCRIPTS_DIR
unset GRUB2_SCRIPTS_DIR
unset TIANO_SCRIPTS_DIR
unset GRUB2_DIR
unset GRUB2_SOURCE_DIR
unset TIANO_SOURCE_DIR
unset GRUB2_BIOS_SCRIPTS_DIR
unset GRUB2_UEFI_SCRIPTS_DIR

set +x +e

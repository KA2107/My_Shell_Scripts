#!/bin/bash

set -x -e

_WD="${PWD}/"

export _SOURCE_CODES_DIR="/media/Source_Codes/Source_Codes"
export _SCRIPTS_DIR="${_SOURCE_CODES_DIR}/My_Shell_Scripts"

export _GRUB2_SCRIPTS_DIR="${_SCRIPTS_DIR}/grub2"
export _GRUB2_DIR="${_SOURCE_CODES_DIR}/Utilities/Boot_Managers__UEFI_GPT/grub2"
export _GRUB2_SOURCE_DIR="${_GRUB2_DIR}/Source__GIT_BZR"

export _GRUB2_BIOS_SCRIPTS_DIR="${_GRUB2_SOURCE_DIR}/grub2_bios_linux_scripts"
export _GRUB2_UEFI_SCRIPTS_DIR="${_GRUB2_SOURCE_DIR}/grub2_uefi_linux_scripts"

export _BOOTLOADER_CONFIG_FILES_DIR="${_SOURCE_CODES_DIR}/My_Files/Bootloader_Config_Files/"

export _TIANOCORE_UEFI_SCRIPTS_DIR="${_SCRIPTS_DIR}/tianocore_uefi"
export _TIANOCORE_UEFI_SOURCE_CODES_DIR="${_SOURCE_CODES_DIR}/Firmware/UEFI/TianoCore_Sourceforge"

echo

_CREATE_SYMLINK() {
	
	echo
	
	if [ ! -d "${_LINK_DIR}/${_LINK_FILE}" ]
	then
		rm -f "${_LINK_DIR}/${_LINK_FILE}" || true
		ln -s "${_SOURCE_DIR}/${_SOURCE_FILE}" "${_LINK_DIR}/${_LINK_FILE}"
	fi
	
	echo
	
}

_SUDO_CREATE_SYMLINK() {
	
	echo
	
	if [ ! -d "${_LINK_DIR}/${_LINK_FILE}" ]
	then
		sudo rm -f "${_LINK_DIR}/${_LINK_FILE}" || true
		sudo ln -s "${_SOURCE_DIR}/${_SOURCE_FILE}" "${_LINK_DIR}/${_LINK_FILE}"
	fi
	
	echo
	
}

_COPY_FILE() {
	
	echo
	
	if [ ! -d "${_LINK_DIR}/${_LINK_FILE}" ]
	then
		rm -f "${_LINK_DIR}/${_LINK_FILE}" || true
		cp "${_SOURCE_DIR}/${_SOURCE_FILE}" "${_LINK_DIR}/${_LINK_FILE}"
	fi
	
	echo
	
}

_SUDO_COPY_FILE() {
	
	echo
	
	if [ ! -d "${_LINK_DIR}/${_LINK_FILE}" ]
	then
		sudo rm -f "${_LINK_DIR}/${_LINK_FILE}" || true
		sudo cp "${_SOURCE_DIR}/${_SOURCE_FILE}" "${_LINK_DIR}/${_LINK_FILE}"
	fi
	
	echo
	
}

_GRUB2() {
	
	echo
	
	_SOURCE_DIR="${_GRUB2_SCRIPTS_DIR}/"
	_SOURCE_FILE="compile_grub2.sh"
	_LINK_DIR="${_GRUB2_SOURCE_DIR}/"
	_LINK_FILE="${_SOURCE_FILE}"
	_CREATE_SYMLINK
	
	echo
	
	_SOURCE_DIR="${_GRUB2_SCRIPTS_DIR}/"
	_SOURCE_FILE="grub.default"
	_LINK_DIR="${_GRUB2_SOURCE_DIR}/"
	_LINK_FILE="${_SOURCE_FILE}"
	_COPY_FILE
	
	echo
	
	_SOURCE_DIR="${_GRUB2_SCRIPTS_DIR}/"
	_SOURCE_FILE="grub2_uefi.sh"
	_LINK_DIR="${_GRUB2_UEFI_SCRIPTS_DIR}/"
	_LINK_FILE="${_SOURCE_FILE}"
	_CREATE_SYMLINK
	
	echo
	
	_SOURCE_DIR="${_GRUB2_SCRIPTS_DIR}/"
	_SOURCE_FILE="grub2_uefi_mkimage_x64_linux.sh"
	_LINK_DIR="${_GRUB2_UEFI_SCRIPTS_DIR}/"
	_LINK_FILE="${_SOURCE_FILE}"
	_CREATE_SYMLINK
	
	echo
	
	_SOURCE_DIR="${_GRUB2_SCRIPTS_DIR}/"
	_SOURCE_FILE="grub2_bios.sh"
	_LINK_DIR="${_GRUB2_BIOS_SCRIPTS_DIR}/"
	_LINK_FILE="${_SOURCE_FILE}"
	_CREATE_SYMLINK
	
	echo
	
	_SOURCE_DIR="${_GRUB2_SCRIPTS_DIR}/"
	_SOURCE_FILE="grub2_bzr_export.sh"
	_LINK_DIR="${_GRUB2_DIR}/Source_BZR/"
	_LINK_FILE="${_SOURCE_FILE}"
	_CREATE_SYMLINK
	
	echo
	
	_SOURCE_DIR="${_SCRIPTS_DIR}/xmanutility/"
	_SOURCE_FILE="xman_dos2unix.sh"
	_LINK_DIR="${_GRUB2_SOURCE_DIR}/"
	_LINK_FILE="${_SOURCE_FILE}"
	_CREATE_SYMLINK
	
	echo
	
	_SOURCE_DIR="${_SCRIPTS_DIR}/bzr/"
	_SOURCE_FILE="grub2_bzr_export.sh"
	_LINK_DIR="${_GRUB2_DIR}/Source_BZR/"
	_LINK_FILE="${_SOURCE_FILE}"
	_CREATE_SYMLINK
	
	echo
	
	unset _SOURCE_DIR
	unset _SOURCE_FILE
	unset _LINK_DIR
	unset _LINK_FILE
	
	echo
	
}

_TIANOCORE_UEFI() {
	
	echo
	
	_SOURCE_DIR="${_TIANOCORE_UEFI_SCRIPTS_DIR}/"
	_LINK_DIR="${_TIANOCORE_UEFI_SOURCE_CODES_DIR}/"
	
	_SOURCE_FILE="tianocore_uefi_common.sh"
	_LINK_FILE="${_SOURCE_FILE}"
	_CREATE_SYMLINK
	
	_SOURCE_FILE="tianocore_uefi_duetpkg_common.sh"
	_LINK_FILE="${_SOURCE_FILE}"
	_CREATE_SYMLINK
	
	_SOURCE_FILE="duetpkg_x86_64_udk_linux_compile_setup.sh"
	_LINK_FILE="${_SOURCE_FILE}"
	_CREATE_SYMLINK
	
	_SOURCE_FILE="duetpkg_x86_64_post_compile.sh"
	_LINK_FILE="${_SOURCE_FILE}"
	_CREATE_SYMLINK
	
	_SOURCE_FILE="duetpkg_x86_64_create_memdisk_old.sh"
	_LINK_FILE="${_SOURCE_FILE}"
	_CREATE_SYMLINK
	
	_SOURCE_FILE="ovmfpkg_x86_64_udk_linux_compile_setup.sh"
	_LINK_FILE="${_SOURCE_FILE}"
	_CREATE_SYMLINK
	
	_SOURCE_FILE="emulatorpkg_unix_x86_64_udk_linux_compile_setup.sh"
	_LINK_FILE="${_SOURCE_FILE}"
	_CREATE_SYMLINK
	
	_SOURCE_FILE="shellpkg_x86_64_udk_linux_compile_setup.sh"
	_LINK_FILE="${_SOURCE_FILE}"
	_CREATE_SYMLINK
	
	echo
	
	unset _SOURCE_DIR
	unset _SOURCE_FILE
	unset _LINK_DIR
	unset _LINK_FILE
	
	echo
	
}

_COPY_BIOS_BOOTLOADER_FILES() {
	
	echo
	
	_BOOT_PART="/boot"
	
	_SOURCE_DIR="${_BOOTLOADER_CONFIG_FILES_DIR}/BIOS/"
	
	_SOURCE_FILE="syslinux_bios.cfg"
	_LINK_DIR="${_BOOT_PART}/syslinux/"
	_LINK_FILE="syslinux.cfg"
	[ -d "${_LINK_DIR}/" ] && _SUDO_COPY_FILE
	
	_SOURCE_FILE="grub2_bios.cfg"
	_LINK_DIR="${_BOOT_PART}/grub2_bios/"
	_LINK_FILE="grub.cfg"
	[ -d "${_LINK_DIR}/" ] && _SUDO_COPY_FILE
	
	_SOURCE_FILE="grub2_bios.cfg"
	_LINK_DIR="${_BOOT_PART}/grub/"
	_LINK_FILE="grub.cfg"
	[ -d "${_LINK_DIR}/" ] && _SUDO_COPY_FILE
	
	echo
	
	unset _BOOT_PART
	unset _SOURCE_DIR
	unset _SOURCE_FILE
	unset _LINK_DIR
	unset _LINK_FILE
	
	echo
	
}

_COPY_UEFI_BOOTLOADER_FILES() {
	
	echo
	
	_UEFI_SYS_PART_DIR="/boot/efi/efi"
	
	_SOURCE_DIR="${_BOOTLOADER_CONFIG_FILES_DIR}/UEFI/"
	
	_SOURCE_FILE="grub2_uefi.cfg"
	_LINK_DIR="${_UEFI_SYS_PART_DIR}/grub2_uefi_x86_64/"
	_LINK_FILE="grub.cfg"
	[ -d "${_LINK_DIR}/" ] && _SUDO_COPY_FILE
	
	_SOURCE_FILE="grub2_uefi.cfg"
	_LINK_DIR="${_UEFI_SYS_PART_DIR}/grub/"
	_LINK_FILE="grub.cfg"
	[ -d "${_LINK_DIR}/" ] && _SUDO_COPY_FILE
	
	_SOURCE_FILE="grub-legacy_uefi.conf"
	_LINK_DIR="${_UEFI_SYS_PART_DIR}/grub-legacy/"
	_LINK_FILE="grub-legacy.conf"
	[ -d "${_LINK_DIR}/" ] && _SUDO_COPY_FILE
	
	_SOURCE_FILE="elilo.conf"
	_LINK_DIR="${_UEFI_SYS_PART_DIR}/elilo/"
	_LINK_FILE="${_SOURCE_FILE}"
	[ -d "${_LINK_DIR}/" ] && _SUDO_COPY_FILE
	
	echo
	
	unset _UEFI_SYS_PART_DIR
	unset _SOURCE_DIR
	unset _SOURCE_FILE
	unset _LINK_DIR
	unset _LINK_FILE
	
	echo
	
}

_PACMAN() {
	
	echo
	
	ls --color=none -1 "/var/lib/pacman/local/" | sed 's#\/##g' > "${_SOURCE_CODES_DIR}/Pacman_Installed_Packages_List.txt"
	ls --color=none -1 "/var/cache/pacman/pkg/" > "${_SOURCE_CODES_DIR}/Pacman_Packages_Cache_List.txt"
	
	echo
	
}

echo

_SOURCE_DIR="${_SCRIPTS_DIR}/git/"
_SOURCE_FILE="git_update.sh"
_LINK_DIR="${_SOURCE_CODES_DIR}/"
_LINK_FILE="${_SOURCE_FILE}"
_CREATE_SYMLINK

echo

_SOURCE_DIR="${_SCRIPTS_DIR}/hg/"
_SOURCE_FILE="hg_update.sh"
_LINK_DIR="${_SOURCE_CODES_DIR}/"
_LINK_FILE="${_SOURCE_FILE}"
_CREATE_SYMLINK

echo

_SOURCE_DIR="${_SCRIPTS_DIR}/bzr/"
_SOURCE_FILE="bzr_update.sh"
_LINK_DIR="${_SOURCE_CODES_DIR}/"
_LINK_FILE="${_SOURCE_FILE}"
_CREATE_SYMLINK

echo

_TIANOCORE_UEFI

echo

_GRUB2

echo

_COPY_BIOS_BOOTLOADER_FILES

echo

_COPY_UEFI_BOOTLOADER_FILES

echo

_PACMAN

echo

unset _WD
unset _SOURCE_CODES_DIR
unset _SCRIPTS_DIR
unset _GRUB2_SCRIPTS_DIR
unset _TIANOCORE_UEFI_SCRIPTS_DIR
unset _GRUB2_DIR
unset _GRUB2_SOURCE_DIR
unset _TIANOCORE_UEFI_SOURCE_CODES_DIR
unset _GRUB2_BIOS_SCRIPTS_DIR
unset _GRUB2_UEFI_SCRIPTS_DIR

set +x +e

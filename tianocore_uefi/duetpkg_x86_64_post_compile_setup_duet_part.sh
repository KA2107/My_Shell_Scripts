#!/bin/bash

set -x -e

_SOURCE_CODES_DIR='/media/Source_Codes/Source_Codes'

_WD="${_SOURCE_CODES_DIR}/Firmware/UEFI/TianoCore_Sourceforge"

source "${_WD}/tianocore_uefi_duetpkg_common.sh"

_COPY_EFILDR_DUET_PART() {
	
	echo
	
	if [[ -d "${_DUET_PART_MP}" ]]; then
		sudo umount "${_DUET_PART_MP}" || true
	else
		sudo mkdir -p "${_DUET_PART_MP}"
	fi
	
	if [[ -e "${_DUETPKG_EMUVARIABLE_BUILD_DIR}/FV/Efildr20" ]]; then
		if [[ "$(file "${_DUETPKG_EMUVARIABLE_BUILD_DIR}/FV/Efildr20" | grep "Efildr20: x86 boot sector")" ]]; then
			sudo mount -t vfat -o rw,users,exec -U "${_DUET_PART_FS_UUID}" "${_DUET_PART_MP}"
			sudo rm -f "${_DUET_PART_MP}/EFILDR20" || true
			sudo install -D -m0644 "${_DUETPKG_EMUVARIABLE_BUILD_DIR}/FV/Efildr20" "${_DUET_PART_MP}/EFILDR20"
			sudo umount "${_DUET_PART_MP}"
		fi
	fi
	
	echo
	
}

_COPY_UEFI_SHELL_UEFI_SYS_PART() {
	
	echo
	
	sudo rm -f "${_UEFI_SYS_PART}/shellx64.efi" || true
	sudo rm -f "${_UEFI_SYS_PART}/shellx64_old.efi" || true
	
	echo
	
	sudo install -D -m0644 "${_UDK_DIR}/ShellBinPkg/UefiShell/X64/Shell.efi" "${_UEFI_SYS_PART}/shellx64.efi"
	sudo install -D -m0644 "${_UDK_DIR}/EdkShellBinPkg/FullShell/X64/Shell_Full.efi" "${_UEFI_SYS_PART}/shellx64_old.efi"
	
	echo
	
}

_COPY_EFILDR_MEMDISK() {
	
	echo
	
	if [[ -e "${_DUETPKG_EMUVARIABLE_BUILD_DIR}/floppy.img" ]]; then
		if [[ -e "${_DUETPKG_EMUVARIABLE_BUILD_DIR}/FV/Efildr" ]]; then
			if [[ "$(file "${_DUETPKG_EMUVARIABLE_BUILD_DIR}/FV/Efildr" | grep "Efildr: x86 boot sector")" ]]; then
				sudo rm -f "${_BOOTPART}/Tianocore_UEFI_UDK_DUET_X86_64.img" || true
				sudo install -D -m0644 "${_DUETPKG_EMUVARIABLE_BUILD_DIR}/floppy.img" "${_BOOTPART}/Tianocore_UEFI_UDK_DUET_X86_64.img"
				
				echo
				
				_COPY_MEMDISK_SYSLINUX_BOOTPART
				
				echo
			fi
		fi
	fi
	
	echo
	
}

echo

_COPY_EFILDR_DUET_PART

echo

_COPY_UEFI_SHELL_UEFI_SYS_PART

echo

_COPY_EFILDR_MEMDISK

echo

unset _SOURCE_CODES_DIR
unset _WD
unset _UDK_DIR
unset _UDK_BUILD_TOOLS_DIR
unset EDK_TOOLS_PATH
unset _UDK_C_SOURCE_DIR
unset _UDK_DUETPKG_BOOTSECT_BIN_DIR
unset _UDK_BUILD_DIR
unset _DUETPKG_EMUVARIABLE_BUILD_DIR
unset _DUETPKG_FSVARIABLE_BUILD_DIR
unset _DUETPKG_COMPILED_DIR
unset _UEFI_DUET_INSTALLER_DIR
unset _DUET_MEMDISK_COMPILED_DIR
unset _DUET_MEMDISK_TOOLS_DIR
unset _MIGLE_BOOTDUET_COMPILE_DIR
unset _ROD_SMITH_DUET_INSTALL_DIR
unset _BOOTPART
unset _UEFI_SYS_PART
unset _SYSLINUX_LIB_DIR

set +x +e

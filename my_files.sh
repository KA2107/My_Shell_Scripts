#!/usr/bin/env bash

set -x -e

_WD="${PWD}/"

export _SOURCE_CODES_DIR="/media/Source_Codes_Partition/Source_Codes/"
export _SCRIPTS_DIR="${_SOURCE_CODES_DIR}/My_Shell_Scripts/"

export _GRUB_SCRIPTS_DIR="${_SCRIPTS_DIR}/grub/"
export _GRUB_DIR="${_SOURCE_CODES_DIR}/Boot_Managers/ALL/grub/"
export _GRUB_SOURCE_DIR="${_GRUB_DIR}/Source__GIT_BZR/"

export _BOOTLOADER_CONFIG_FILES_DIR="${_SOURCE_CODES_DIR}/My_Files/Bootloader_Config_Files/"

export _TIANOCORE_UEFI_SCRIPTS_DIR="${_SCRIPTS_DIR}/tianocore_uefi/"
export _TIANOCORE_UEFI_SOURCE_CODES_DIR="${_SOURCE_CODES_DIR}/Firmware/UEFI/TianoCore_Sourceforge/"

export _TIANOCORE_UEFI_SHELL_2_PATH_COMPILED="${_TIANOCORE_UEFI_SOURCE_CODES_DIR}/BACKUP_BUILDS/SHELLPKG_BUILD/X64/"
export _TIANOCORE_UEFI_SHELL_2_PATH="${_TIANOCORE_UEFI_SOURCE_CODES_DIR}/UDK_GIT/ShellBinPkg/UefiShell/X64/"
export _TIANOCORE_UEFI_SHELL_1_PATH="${_TIANOCORE_UEFI_SOURCE_CODES_DIR}/UDK_GIT/EdkShellBinPkg/FullShell/X64/"

echo

_CREATE_SYMLINK() {
	
	echo
	
	if [[ ! -d "${_DEST_DIR}/${_DEST_FILE}" ]]; then
		rm -f "${_DEST_DIR}/${_DEST_FILE}" || true
		ln -s "${_SOURCE_DIR}/${_SOURCE_FILE}" "${_DEST_DIR}/${_DEST_FILE}"
	fi
	
	echo
	
}

_SUDO_CREATE_SYMLINK() {
	
	echo
	
	if [[ ! -d "${_DEST_DIR}/${_DEST_FILE}" ]]; then
		sudo rm -f "${_DEST_DIR}/${_DEST_FILE}" || true
		sudo ln -s "${_SOURCE_DIR}/${_SOURCE_FILE}" "${_DEST_DIR}/${_DEST_FILE}"
	fi
	
	echo
	
}

_COPY_FILE() {
	
	echo
	
	if [[ ! -d "${_DEST_DIR}/${_DEST_FILE}" ]]; then
		rm -f "${_DEST_DIR}/${_DEST_FILE}" || true
		install -D -m0644 "${_SOURCE_DIR}/${_SOURCE_FILE}" "${_DEST_DIR}/${_DEST_FILE}"
	fi
	
	echo
	
}

_SUDO_COPY_FILE() {
	
	echo
	
	if [[ ! -d "${_DEST_DIR}/${_DEST_FILE}" ]]; then
		sudo rm -f "${_DEST_DIR}/${_DEST_FILE}" || true
		sudo install -D -m0644 "${_SOURCE_DIR}/${_SOURCE_FILE}" "${_DEST_DIR}/${_DEST_FILE}"
	fi
	
	echo
	
}

_GRUB2() {
	
	echo
	
	_SOURCE_DIR="${_GRUB_SCRIPTS_DIR}/"
	_SOURCE_FILE="compile_grub.sh"
	_DEST_DIR="${_GRUB_SOURCE_DIR}/"
	_DEST_FILE="${_SOURCE_FILE}"
	_CREATE_SYMLINK
	
	echo
	
	_SOURCE_DIR="${_GRUB_SCRIPTS_DIR}/"
	_SOURCE_FILE="grub_git_bzr_export.sh"
	_DEST_DIR="${_GRUB_SOURCE_DIR}/"
	_DEST_FILE="${_SOURCE_FILE}"
	_CREATE_SYMLINK
	
	echo
	
	_SOURCE_DIR="${_GRUB_SCRIPTS_DIR}/"
	_SOURCE_FILE="grub.default"
	_DEST_DIR="${_GRUB_SOURCE_DIR}/"
	_DEST_FILE="${_SOURCE_FILE}"
	_COPY_FILE
	
	echo
	
	_SOURCE_DIR="${_GRUB_SCRIPTS_DIR}/"
	_SOURCE_FILE="grub_bzr_export.sh"
	_DEST_DIR="${_GRUB_DIR}/Source_BZR/"
	_DEST_FILE="${_SOURCE_FILE}"
	_CREATE_SYMLINK
	
	echo
	
	_SOURCE_DIR="${_SCRIPTS_DIR}/xmanutility/"
	_SOURCE_FILE="xman_dos2unix.sh"
	_DEST_DIR="${_GRUB_SOURCE_DIR}/"
	_DEST_FILE="${_SOURCE_FILE}"
	_CREATE_SYMLINK
	
	echo
	
	unset _SOURCE_DIR
	unset _SOURCE_FILE
	unset _DEST_DIR
	unset _DEST_FILE
	
	echo
	
}

_TIANOCORE_UEFI() {
	
	echo
	
	_SOURCE_DIR="${_TIANOCORE_UEFI_SCRIPTS_DIR}/"
	_DEST_DIR="${_TIANOCORE_UEFI_SOURCE_CODES_DIR}/"
	
	_SOURCE_FILE="tianocore_uefi_common.sh"
	_DEST_FILE="${_SOURCE_FILE}"
	_CREATE_SYMLINK
	
	_SOURCE_FILE="tianocore_uefi_duetpkg_common.sh"
	_DEST_FILE="${_SOURCE_FILE}"
	_CREATE_SYMLINK
	
	_SOURCE_FILE="duetpkg_x86_64_udk_linux_compile.sh"
	_DEST_FILE="${_SOURCE_FILE}"
	_CREATE_SYMLINK
	
	_SOURCE_FILE="duetpkg_x86_64_post_compile_setup_duet_part.sh"
	_DEST_FILE="${_SOURCE_FILE}"
	_CREATE_SYMLINK
	
	_SOURCE_FILE="duetpkg_x86_64_post_compile_setup_git_repos.sh"
	_DEST_FILE="${_SOURCE_FILE}"
	_CREATE_SYMLINK
	
	_SOURCE_FILE="duetpkg_x86_64_create_memdisk_old.sh"
	_DEST_FILE="${_SOURCE_FILE}"
	_CREATE_SYMLINK
	
	_SOURCE_FILE="ovmfpkg_x86_64_udk_linux_compile.sh"
	_DEST_FILE="${_SOURCE_FILE}"
	_CREATE_SYMLINK
	
	_SOURCE_FILE="emulatorpkg_unix_x86_64_udk_linux_compile.sh"
	_DEST_FILE="${_SOURCE_FILE}"
	_CREATE_SYMLINK
	
	_SOURCE_FILE="shellpkg_x86_64_udk_linux_compile.sh"
	_DEST_FILE="${_SOURCE_FILE}"
	_CREATE_SYMLINK
	
	echo
	
	unset _SOURCE_DIR
	unset _SOURCE_FILE
	unset _DEST_DIR
	unset _DEST_FILE
	
	echo
	
}

_COPY_BIOS_BOOTLOADER_FILES() {
	
	echo
	
	_BOOT_PART="/boot"
	
	_SOURCE_DIR="${_BOOTLOADER_CONFIG_FILES_DIR}/UEFI/"
	
	_SOURCE_FILE="grub_uefi.cfg"
	_DEST_DIR="${_BOOT_PART}/grub_bios/"
	_DEST_FILE="grub.cfg"
	[[ -d "${_DEST_DIR}/" ]] && _SUDO_COPY_FILE
	
	_SOURCE_FILE="grub_uefi.cfg"
	_DEST_DIR="${_BOOT_PART}/grub/"
	_DEST_FILE="grub.cfg"
	[[ -d "${_DEST_DIR}/" ]] && _SUDO_COPY_FILE
	
	_SOURCE_DIR="${_BOOTLOADER_CONFIG_FILES_DIR}/BIOS/"
	_SOURCE_FILE="syslinux_bios.cfg"
	_DEST_DIR="${_BOOT_PART}/syslinux/"
	_DEST_FILE="syslinux.cfg"
	[[ -d "${_DEST_DIR}/" ]] && _SUDO_COPY_FILE
	
	echo
	
	unset _BOOT_PART
	unset _SOURCE_DIR
	unset _SOURCE_FILE
	unset _DEST_DIR
	unset _DEST_FILE
	
	echo
	
}

_COPY_UEFI_BOOTLOADER_FILES() {
	
	echo
	
	_UEFI_SYS_PART_DIR="/boot/efi/efi"
	
	_SOURCE_DIR="${_BOOTLOADER_CONFIG_FILES_DIR}/UEFI/"
	
	_SOURCE_FILE="grub_uefi.cfg"
	_DEST_DIR="${_UEFI_SYS_PART_DIR}/grub_uefi_x86_64/"
	_DEST_FILE="grub.cfg"
	[[ -d "${_DEST_DIR}/" ]] && _SUDO_COPY_FILE
	
	_SOURCE_FILE="grub_uefi.cfg"
	_DEST_DIR="${_UEFI_SYS_PART_DIR}/grub/"
	_DEST_FILE="grub.cfg"
	[[ -d "${_DEST_DIR}/" ]] && _SUDO_COPY_FILE
	
	_SOURCE_FILE="grub-legacy_uefi.conf"
	_DEST_DIR="${_UEFI_SYS_PART_DIR}/arch_grub-legacy/"
	_DEST_FILE="grub-legacy-x64.conf"
	[[ -d "${_DEST_DIR}/" ]] && _SUDO_COPY_FILE
	
	_SOURCE_FILE="elilo_uefi.conf"
	_DEST_DIR="${_UEFI_SYS_PART_DIR}/arch_elilo/"
	_DEST_FILE="elilo.conf"
	[[ -d "${_DEST_DIR}/" ]] && _SUDO_COPY_FILE
	
	_SOURCE_FILE="efilinux_uefi.cfg"
	_DEST_DIR="${_UEFI_SYS_PART_DIR}/arch_efilinux/"
	_DEST_FILE="efilinux.cfg"
	[[ -d "${_DEST_DIR}/" ]] && _SUDO_COPY_FILE
	
	_SOURCE_DIR="${_BOOTLOADER_CONFIG_FILES_DIR}/UEFI/refind_uefi"
	
	_SOURCE_FILE="refind_uefi.conf"
	_DEST_DIR="${_UEFI_SYS_PART_DIR}/arch_refind/"
	_DEST_FILE="refind.conf"
	[[ -d "${_DEST_DIR}/" ]] && _SUDO_COPY_FILE
	
	_SOURCE_FILE="refind_uefi_linux.conf"
	_DEST_DIR="${_UEFI_SYS_PART_DIR}/arch_linux_core/"
	_DEST_FILE="refind_linux.conf"
	[[ -d "${_DEST_DIR}/" ]] && _SUDO_COPY_FILE
	
	_SOURCE_FILE="refind_uefi_linux.conf"
	_DEST_DIR="${_UEFI_SYS_PART_DIR}/arch_linux_mainline/"
	_DEST_FILE="refind_linux.conf"
	[[ -d "${_DEST_DIR}/" ]] && _SUDO_COPY_FILE
	
	echo
	
	unset _UEFI_SYS_PART_DIR
	unset _SOURCE_DIR
	unset _SOURCE_FILE
	unset _DEST_DIR
	unset _DEST_FILE
	
	echo
	
}

_COPY_UEFI_SHELL_FILES() {
	
	echo
	
	_UEFI_SYS_PART_DIR="/boot/efi/efi"
	
	#######
	
	if [[ -e "${_TIANOCORE_UEFI_SHELL_2_PATH_COMPILED}/Shell.efi" ]]; then
		_SOURCE_DIR="${_TIANOCORE_UEFI_SHELL_2_PATH_COMPILED}"
	else
		_SOURCE_DIR="${_TIANOCORE_UEFI_SHELL_2_PATH}"
	fi
	
	_SOURCE_FILE="Shell.efi"
	_DEST_FILE="shellx64.efi"
	
	_DEST_DIR="${_UEFI_SYS_PART_DIR}/shell/"
	[[ -d "${_DEST_DIR}/" ]] && _SUDO_COPY_FILE
	
	_DEST_DIR="/media/Data_3/Operating_Systems/Unix_Based/Linux/Archlinux/Archboot/"
	[[ -d "${_DEST_DIR}/" ]] && _COPY_FILE
	
	#######
	
	_SOURCE_DIR="${_TIANOCORE_UEFI_SHELL_1_PATH}"
	_SOURCE_FILE="Shell_Full.efi"
	_DEST_DIR="${_UEFI_SYS_PART_DIR}/shell/"
	_DEST_FILE="shellx64_old.efi"
	[[ -d "${_DEST_DIR}/" ]] && _SUDO_COPY_FILE
	
	echo
	
	unset _UEFI_SYS_PART_DIR
	unset _SOURCE_DIR
	unset _SOURCE_FILE
	unset _DEST_DIR
	unset _DEST_FILE
	
	echo
	
}

_COPY_EFISTUB_KERNELS_UEFISYS_PART() {
	
	echo
	
	_UEFI_SYS_PART_DIR="/boot/efi/efi"
	
	echo
	
	sudo rm -rf "${_UEFI_SYS_PART_DIR}/arch_linux_core"/ || true
	sudo install -d "${_UEFI_SYS_PART_DIR}/arch_linux_core"/ || true
	
	echo
	
	for _FILE_ in "/boot"/vmlinuz* "/boot"/bz{I,i}mage* ; do
		if [[ -f "${_FILE_}" ]]; then
			_BASENAME="$(basename "${_FILE_}")"
			
			dd if="/boot/${_BASENAME}" of="/tmp/${_BASENAME}_check.bin" bs=512 count=1
			
			echo
			
			if [[ "$(file "/tmp/${_BASENAME}_check.bin" | grep 'PE32+ executable (EFI application) x86-64')" ]]; then
				if [[ ! "$(grep '\.efi' "${_BASENAME}")" ]]; then
					sudo install -D -m0644 "/boot/${_BASENAME}" "${_UEFI_SYS_PART_DIR}/arch_linux_core/${_BASENAME}.efi" || true
					echo
				fi
			else
				sudo install -D -m0644 "/boot/${_BASENAME}" "${_UEFI_SYS_PART_DIR}/arch_linux_core/${_BASENAME}" || true
				echo
			fi
			
			sudo rm -f "/tmp/${_BASENAME}_check.bin" || true
		fi
	done
	
	sudo install -D -m0644 "/boot"/init{ramfs,rd}*.img "${_UEFI_SYS_PART_DIR}/arch_linux_core"/ || true
	
	echo
	
	sudo install -D -m0644 "${_UEFI_SYS_PART_DIR}/arch_linux_core"/vmlinuz-{linux,ARCH-core}.efi
	sudo install -D -m0644 "${_UEFI_SYS_PART_DIR}/arch_linux_core"/initramfs-{linux,ARCH-core}.img
	sudo install -D -m0644 "${_UEFI_SYS_PART_DIR}/arch_linux_core"/initramfs-{linux,ARCH-core}-fallback.img
	sudo rm -f "${_UEFI_SYS_PART_DIR}/arch_linux_core"/vmlinuz-linux.efi
	sudo rm -f "${_UEFI_SYS_PART_DIR}/arch_linux_core"/initramfs-linux{,-fallback}.img
	
	echo
	
	sudo rm -rf "${_UEFI_SYS_PART_DIR}/arch_linux_mainline"/ || true
	sudo install -d "${_UEFI_SYS_PART_DIR}/arch_linux_mainline"/ || true
	
	echo
	
	sudo install -D -m0644 "${_UEFI_SYS_PART_DIR}/arch_linux_core"/vmlinuz-linux-mainline.efi "${_UEFI_SYS_PART_DIR}/arch_linux_mainline"/vmlinuz-arch-mainline.efi
	sudo install -D -m0644 "${_UEFI_SYS_PART_DIR}/arch_linux_core"/initramfs-linux-mainline.img "${_UEFI_SYS_PART_DIR}/arch_linux_mainline"/initramfs-arch-mainline.img
	sudo install -D -m0644 "${_UEFI_SYS_PART_DIR}/arch_linux_core"/initramfs-linux-mainline-fallback.img "${_UEFI_SYS_PART_DIR}/arch_linux_mainline"/initramfs-arch-mainline-fallback.img
	sudo rm -f "${_UEFI_SYS_PART_DIR}/arch_linux_core"/vmlinuz-linux-mainline.efi
	sudo rm -f "${_UEFI_SYS_PART_DIR}/arch_linux_core"/initramfs-linux-mainline{,-fallback}.img
	
	echo
	
	# $(sudo pacman -Qi linux | grep 'Version' | awk '{print $3}')
	
}

_REFIND_UEFI() {
	
	echo
	
	_UEFI_SYS_PART_DIR="/boot/efi/efi"
	
	echo
	
	sudo rm -f "${_UEFI_SYS_PART_DIR}/boot/bootx64.efi" || true
	sudo rm -rf "${_UEFI_SYS_PART_DIR}/boot/icons"/ || true
	sudo rm -f "${_UEFI_SYS_PART_DIR}/boot/refind.conf" || true
	sudo rm -f "${_UEFI_SYS_PART_DIR}/boot/grub.cfg" || true
	
	echo
	
	sudo install -D -m0644 "${_UEFI_SYS_PART_DIR}/arch_refind/refindx64.efi" "${_UEFI_SYS_PART_DIR}/boot/bootx64.efi"
	sudo install -D -m0644 "${_UEFI_SYS_PART_DIR}/arch_refind/refind.conf" "${_UEFI_SYS_PART_DIR}/boot/refind.conf"
	sudo cp -r "${_UEFI_SYS_PART_DIR}/arch_refind/icons" "${_UEFI_SYS_PART_DIR}/boot/icons"
	
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
_DEST_DIR="${_SOURCE_CODES_DIR}/"
_DEST_FILE="${_SOURCE_FILE}"
_CREATE_SYMLINK

echo

_SOURCE_DIR="${_SCRIPTS_DIR}/hg/"
_SOURCE_FILE="hg_update.sh"
_DEST_DIR="${_SOURCE_CODES_DIR}/"
_DEST_FILE="${_SOURCE_FILE}"
_CREATE_SYMLINK

echo

_SOURCE_DIR="${_SCRIPTS_DIR}/bzr/"
_SOURCE_FILE="bzr_update.sh"
_DEST_DIR="${_SOURCE_CODES_DIR}/"
_DEST_FILE="${_SOURCE_FILE}"
_CREATE_SYMLINK

echo

_TIANOCORE_UEFI

echo

_GRUB2

echo

_COPY_BIOS_BOOTLOADER_FILES

echo

_COPY_EFISTUB_KERNELS_UEFISYS_PART

echo

_COPY_UEFI_SHELL_FILES

echo

_COPY_UEFI_BOOTLOADER_FILES

echo

_REFIND_UEFI

echo

_PACMAN

echo

unset _WD
unset _SOURCE_CODES_DIR
unset _SCRIPTS_DIR
unset _GRUB_SCRIPTS_DIR
unset _TIANOCORE_UEFI_SCRIPTS_DIR
unset _GRUB_DIR
unset _GRUB_SOURCE_DIR
unset _TIANOCORE_UEFI_SOURCE_CODES_DIR
unset _TIANOCORE_UEFI_SHELL_2_PATH_COMPILED
unset _TIANOCORE_UEFI_SHELL_2_PATH
unset _TIANOCORE_UEFI_SHELL_1_PATH

set +x +e

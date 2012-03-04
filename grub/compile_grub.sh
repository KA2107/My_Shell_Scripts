#!/usr/bin/env bash

_PROCESS_CONTINUE_UEFI='FALSE'
_PROCESS_CONTINUE_BIOS='FALSE'

_GRUB_SCRIPTS_DIR="/media/Source_Codes/Source_Codes/My_Shell_Scripts/grub"
_BOOTLOADER_CONFIG_FILES_DIR='/media/Source_Codes/Source_Codes/My_Files/Bootloader_Config_Files/'
_WD_OUTER="${PWD}/"
_X86_32_CHROOT='/opt/arch32'

if [[ \
	"${1}" == '' || \
	"${1}" == '-h' || \
	"${1}" == '-u' || \
	"${1}" == '-help' || \
	"${1}" == '-usage' || \
	"${1}" == '--help' || \
	"${1}" == '--usage' \
	]]
then
	echo
	echo '1 for EFI-MAIN and BIOS-MAIN'
	echo '2 for EFI-EXP and BIOS-MAIN'
	echo '3 for EFI-MAIN and BIOS-EXP'
	echo '4 for EFI-EXP and BIOS-EXP'
	echo
	echo '5 for EFI-MAIN alone'
	echo '6 for EFI-EXP alone'
	echo '7 for BIOS-MAIN alone'
	echo '8 for BIOS-EXP alone'
	echo
	export _PROCESS_CONTINUE_UEFI='FALSE'
	export _PROCESS_CONTINUE_BIOS='FALSE'
fi

if [[ "${1}" == '1' ]]; then
	export _GRUB_UEFI='-efi-main'
	export _GRUB_BIOS='-bios-main'
	
elif [[ "${1}" == '2' ]]; then
	export _GRUB_UEFI='-efi-exp'
	export _GRUB_BIOS='-bios-main'
	
elif [[ "${1}" == '3' ]]; then
	export _GRUB_UEFI='-efi-main'
	export _GRUB_BIOS='-bios-exp'
	
elif [[ "${1}" == '4' ]]; then
	export _GRUB_UEFI='-efi-exp'
	export _GRUB_BIOS='-bios-exp'
	
elif [[ "${1}" == '5' ]]; then
	export _GRUB_UEFI='-efi-main'
	export _GRUB_BIOS='NULL'
	
elif [[ "${1}" == '6' ]]; then
	export _GRUB_UEFI='-efi-exp'
	export _GRUB_BIOS='NULL'
	
elif [[ "${1}" == '7' ]]; then
	export _GRUB_UEFI='NULL'
	export _GRUB_BIOS='-bios-main'
	
elif [[ "${1}" == '8' ]]; then
	export _GRUB_UEFI='NULL'
	export _GRUB_BIOS='-bios-exp'
	
fi

if [[ "${_GRUB_UEFI}" == '-efi-exp' ]]; then
	export _GRUB_UEFI_Source_DIR_Name='grub_experimental__GIT_BZR'
	export _PROCESS_CONTINUE_UEFI='TRUE'
	
elif [[ "${_GRUB_UEFI}" == '-efi-main' ]]; then
	export _GRUB_UEFI_Source_DIR_Name='grub__GIT_BZR'
	export _PROCESS_CONTINUE_UEFI='TRUE'
	
fi

if [[ "${_GRUB_BIOS}" == '-bios-exp' ]]; then
	export _GRUB_BIOS_Source_DIR_Name='grub_experimental__GIT_BZR'
	export _PROCESS_CONTINUE_BIOS='TRUE'
	
elif [[ "${_GRUB_BIOS}" == '-bios-main' ]]; then
	export _GRUB_BIOS_Source_DIR_Name='grub__GIT_BZR'
	export _PROCESS_CONTINUE_BIOS='TRUE'
	
fi

echo

_APPLY_PATCHES() {
	
	patch -Np1 -i "${_WD_OUTER}/archlinux_grub_mkconfig_fixes.patch"
	echo
	
	# patch -Np0 -i "${_WD_OUTER}/grub-mactel.patch"
	echo
	
}

if [[ "${_PROCESS_CONTINUE_UEFI}" == 'TRUE' ]] && [[ "${_PROCESS_CONTINUE_BIOS}" == 'TRUE' ]]; then
	if [[ "${_GRUB_UEFI_Source_DIR_Name}" == "${_GRUB_BIOS_Source_DIR_Name}" ]]; then
		cd "${_WD_OUTER}/${_GRUB_UEFI_Source_DIR_Name}/"
		echo
	fi
fi

if [[ "${_PROCESS_CONTINUE_UEFI}" == 'TRUE' ]]; then
	
	set -x -e
	
	# "${_WD_OUTER}/xman_dos2unix.sh" * || true
	
	## First compile GRUB for UEFI x86_64
	
	rm -rf "${_WD_OUTER}/${_GRUB_UEFI_Source_DIR_Name}/grub_extras__GIT_BZR" || true
	
	cp -r "${_WD_OUTER}/grub_extras__GIT_BZR" "${_WD_OUTER}/${_GRUB_UEFI_Source_DIR_Name}/grub_extras__GIT_BZR" || true
	rm -rf "${_WD_OUTER}/${_GRUB_UEFI_Source_DIR_Name}/grub_extras__GIT_BZR/zfs" || true
	rm -rf "${_WD_OUTER}/${_GRUB_UEFI_Source_DIR_Name}/grub_extras__GIT_BZR/915resolution" || true
	rm -rf "${_WD_OUTER}/${_GRUB_UEFI_Source_DIR_Name}/grub_extras__GIT_BZR/ntldr-img" || true
	
	if [[ "${_GRUB_UEFI_Source_DIR_Name}" != "${_GRUB_BIOS_Source_DIR_Name}" ]]; then
		cd "${_WD_OUTER}/${_GRUB_UEFI_Source_DIR_Name}/"
		echo
	fi
	
	cp --verbose "${_GRUB_SCRIPTS_DIR}/grub_uefi.sh" "${_GRUB_SCRIPTS_DIR}/grub_uefi_linux_my.sh" "${_WD_OUTER}/${_GRUB_UEFI_Source_DIR_Name}/"
	cp --verbose "${_WD_OUTER}/xman_dos2unix.sh" "${_WD_OUTER}/grub.default" "${_WD_OUTER}/${_GRUB_UEFI_Source_DIR_Name}/" || true
	echo
	
	rm -f "${_WD_OUTER}/${_GRUB_UEFI_Source_DIR_Name}/grub.cfg" || true
	cp --verbose "${_BOOTLOADER_CONFIG_FILES_DIR}/UEFI/grub_uefi.cfg" "${_WD_OUTER}/${_GRUB_UEFI_Source_DIR_Name}/grub.cfg" || true
	echo
	
	cd "${_WD_OUTER}/${_GRUB_UEFI_Source_DIR_Name}/"
	
	rm -f "${_WD_OUTER}/${_GRUB_UEFI_Source_DIR_Name}/ChangeLog_Keshav" || true
	echo
	
	git reset --hard
	echo
	
	git checkout master
	echo
	
	_APPLY_PATCHES
	
	"${PWD}/grub_uefi_linux_my.sh"
	echo
	cd ..
	
	cp -r "${_WD_OUTER}/${_GRUB_UEFI_Source_DIR_Name}/GRUB_UEFI_BUILD_DIR_x86_64" "${_WD_OUTER}/GRUB_UEFI_BUILD_DIR_x86_64" || true
	sudo rm -rf "${_WD_OUTER}/${_GRUB_UEFI_Source_DIR_Name}/GRUB_UEFI_BUILD_DIR_x86_64" || true
	echo
	
	set +x +e
	
fi

if [[ "${_PROCESS_CONTINUE_BIOS}" == 'TRUE' ]]; then
	
	set -x -e
	
	# "${_WD_OUTER}/xman_dos2unix.sh" * || true
	
	## Second compile GRUB for BIOS
	
	rm -rf "${_WD_OUTER}/${_GRUB_BIOS_Source_DIR_Name}/grub_extras__GIT_BZR" || true
	
	cp -r "${_WD_OUTER}/grub_extras__GIT_BZR" "${_WD_OUTER}/${_GRUB_BIOS_Source_DIR_Name}/grub_extras__GIT_BZR" || true
	rm -rf "${_WD_OUTER}/${_GRUB_BIOS_Source_DIR_Name}/grub_extras__GIT_BZR/zfs" || true
	# rm -rf "${_WD_OUTER}/${_GRUB_BIOS_Source_DIR_Name}/grub_extras__GIT_BZR/915resolution" || true
	# rm -rf "${_WD_OUTER}/${_GRUB_BIOS_Source_DIR_Name}/grub_extras__GIT_BZR/ntldr-img" || true
	
	if [[ "${_GRUB_BIOS_Source_DIR_Name}" != "${_GRUB_UEFI_Source_DIR_Name}" ]]; then
		cd "${_WD_OUTER}/${_GRUB_BIOS_Source_DIR_Name}/"
		echo
	fi
	
	cp --verbose "${_GRUB_SCRIPTS_DIR}/grub_bios.sh" "${_GRUB_SCRIPTS_DIR}/grub_bios_linux_my.sh" "${_WD_OUTER}/${_GRUB_BIOS_Source_DIR_Name}/"
	cp --verbose "${_WD_OUTER}/xman_dos2unix.sh" "${_WD_OUTER}/grub.default" "${_WD_OUTER}/${_GRUB_BIOS_Source_DIR_Name}/" || true
	echo
	
	rm -f "${_WD_OUTER}/${_GRUB_BIOS_Source_DIR_Name}/grub.cfg" || true
	cp --verbose "${_BOOTLOADER_CONFIG_FILES_DIR}/UEFI/grub_uefi.cfg" "${_WD_OUTER}/${_GRUB_BIOS_Source_DIR_Name}/grub.cfg" || true
	echo
	
	cd "${_WD_OUTER}/${_GRUB_BIOS_Source_DIR_Name}/"
	
	rm -f "${_WD_OUTER}/${_GRUB_BIOS_Source_DIR_Name}/ChangeLog_Keshav" || true
	echo
	
	git reset --hard
	echo
	
	git checkout master
	echo
	
	_APPLY_PATCHES
	
	## CHROOT into the arch32 system for compiling GRUB BIOS i386
	# export _BCHROOT_DIR="${_WD_OUTER}"
	# sudo chroot "${_X86_32_CHROOT}" || exit 1
	# cd "${_BCHROOT_DIR}"
	# unset _BCHROOT_DIR
	
	# schroot --automatic-session --preserve-environment --directory ${_WD_OUTER}
	echo
	
	"${PWD}/grub_bios_linux_my.sh"
	echo
	cd ..
	
	cp -r "${_WD_OUTER}/${_GRUB_BIOS_Source_DIR_Name}/GRUB_BIOS_BUILD_DIR" "${_WD_OUTER}/GRUB_BIOS_BUILD_DIR" || true
	sudo rm -rf "${_WD_OUTER}/${_GRUB_BIOS_Source_DIR_Name}/GRUB_BIOS_BUILD_DIR" || true
	echo
	
	set +x +e
	
fi

unset _PROCESS_CONTINUE_UEFI
unset _PROCESS_CONTINUE_BIOS
unset _GRUB_SCRIPTS_DIR
unset _BOOTLOADER_CONFIG_FILES_DIR
unset _WD_OUTER
unset _GRUB_UEFI
unset _GRUB_BIOS
unset _GRUB_UEFI_Source_DIR_Name
unset _GRUB_BIOS_Source_DIR_Name
unset _X86_32_CHROOT

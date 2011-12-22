#!/bin/bash

export _PROCESS_CONTINUE_UEFI='FALSE'
export _PROCESS_CONTINUE_BIOS='FALSE'

export _BOOTLOADER_CONFIG_FILES_DIR='/media/Source_Codes/Source_Codes/My_Files/Bootloader_Config_Files/'
export _WD_OUTER="${PWD}/"
export _X86_32_CHROOT='/opt/arch32'

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
	export _GRUB2_UEFI='-efi-main'
	export _GRUB2_BIOS='-bios-main'
	
elif [[ "${1}" == '2' ]]; then
	export _GRUB2_UEFI='-efi-exp'
	export _GRUB2_BIOS='-bios-main'
	
elif [[ "${1}" == '3' ]]; then
	export _GRUB2_UEFI='-efi-main'
	export _GRUB2_BIOS='-bios-exp'
	
elif [[ "${1}" == '4' ]]; then
	export _GRUB2_UEFI='-efi-exp'
	export _GRUB2_BIOS='-bios-exp'
	
elif [[ "${1}" == '5' ]]; then
	export _GRUB2_UEFI='-efi-main'
	export _GRUB2_BIOS='NULL'
	
elif [[ "${1}" == '6' ]]; then
	export _GRUB2_UEFI='-efi-exp'
	export _GRUB2_BIOS='NULL'
	
elif [[ "${1}" == '7' ]]; then
	export _GRUB2_UEFI='NULL'
	export _GRUB2_BIOS='-bios-main'
	
elif [[ "${1}" == '8' ]]; then
	export _GRUB2_UEFI='NULL'
	export _GRUB2_BIOS='-bios-exp'
	
fi

if [[ "${_GRUB2_UEFI}" == '-efi-exp' ]]; then
	export _GRUB2_UEFI_Source_DIR_Name='grub2_experimental__GIT_BZR'
	export _PROCESS_CONTINUE_UEFI='TRUE'
	
elif [[ "${_GRUB2_UEFI}" == '-efi-main' ]]; then
	export _GRUB2_UEFI_Source_DIR_Name='grub2__GIT_BZR'
	export _PROCESS_CONTINUE_UEFI='TRUE'
	
fi

if [[ "${_GRUB2_BIOS}" == '-bios-exp' ]]; then
	export _GRUB2_BIOS_Source_DIR_Name='grub2_experimental__GIT_BZR'
	export _PROCESS_CONTINUE_BIOS='TRUE'
	
elif [[ "${_GRUB2_BIOS}" == '-bios-main' ]]; then
	export _GRUB2_BIOS_Source_DIR_Name='grub2__GIT_BZR'
	export _PROCESS_CONTINUE_BIOS='TRUE'
	
fi

echo

if [[ "${_PROCESS_CONTINUE_UEFI}" == 'TRUE' ]] && [[ "${_PROCESS_CONTINUE_BIOS}" == 'TRUE' ]]; then
	if [[ "${_GRUB2_UEFI_Source_DIR_Name}" == "${_GRUB2_BIOS_Source_DIR_Name}" ]]; then
		cd "${_WD_OUTER}/${_GRUB2_UEFI_Source_DIR_Name}/"
		echo
	fi
fi

if [[ "${_PROCESS_CONTINUE_UEFI}" == 'TRUE' ]]; then
	
	set -x -e
	
	# "${_WD_OUTER}/xman_dos2unix.sh" * || true
	
	## First compile GRUB2 for UEFI x86_64
	
	rm -rf "${_WD_OUTER}/${_GRUB2_UEFI_Source_DIR_Name}/grub2_extras__GIT_BZR" || true
	
	cp -r "${_WD_OUTER}/grub2_extras__GIT_BZR" "${_WD_OUTER}/${_GRUB2_UEFI_Source_DIR_Name}/grub2_extras__GIT_BZR" || true
	rm -rf "${_WD_OUTER}/${_GRUB2_UEFI_Source_DIR_Name}/grub2_extras__GIT_BZR/zfs" || true
	rm -rf "${_WD_OUTER}/${_GRUB2_UEFI_Source_DIR_Name}/grub2_extras__GIT_BZR/915resolution" || true
	rm -rf "${_WD_OUTER}/${_GRUB2_UEFI_Source_DIR_Name}/grub2_extras__GIT_BZR/ntldr-img" || true
	
	if [[ "${_GRUB2_UEFI_Source_DIR_Name}" != "${_GRUB2_BIOS_Source_DIR_Name}" ]]; then
		cd "${_WD_OUTER}/${_GRUB2_UEFI_Source_DIR_Name}/"
		echo
	fi
	
	cp --verbose "${_WD_OUTER}/grub2_uefi_linux_scripts/grub2_uefi.sh" "${_WD_OUTER}/grub2_uefi_linux_scripts/grub2_uefi_linux_my.sh" "${_WD_OUTER}/${_GRUB2_UEFI_Source_DIR_Name}/"
	cp --verbose "${_WD_OUTER}/xman_dos2unix.sh" "${_WD_OUTER}/grub.default" "${_WD_OUTER}/${_GRUB2_UEFI_Source_DIR_Name}/" || true
	echo
	
	rm -f "${_WD_OUTER}/${_GRUB2_UEFI_Source_DIR_Name}/grub.cfg" || true
	cp --verbose "${_BOOTLOADER_CONFIG_FILES_DIR}/UEFI/grub_uefi.cfg" "${_WD_OUTER}/${_GRUB2_UEFI_Source_DIR_Name}/grub.cfg" || true
	echo
	
	cd "${_WD_OUTER}/${_GRUB2_UEFI_Source_DIR_Name}/"
	"${PWD}/grub2_uefi_linux_my.sh"
	echo
	cd ..
	
	cp -r "${_WD_OUTER}/${_GRUB2_UEFI_Source_DIR_Name}/GRUB2_UEFI_BUILD_DIR_x86_64" "${_WD_OUTER}/GRUB2_UEFI_BUILD_DIR_x86_64" || true
	sudo rm -rf "${_WD_OUTER}/${_GRUB2_UEFI_Source_DIR_Name}/GRUB2_UEFI_BUILD_DIR_x86_64" || true
	echo
	
	set +x +e
	
fi

if [[ "${_PROCESS_CONTINUE_BIOS}" == 'TRUE' ]]; then
	
	set -x -e
	
	# "${_WD_OUTER}/xman_dos2unix.sh" * || true
	
	## Second compile GRUB2 for BIOS
	
	rm -rf "${_WD_OUTER}/${_GRUB2_BIOS_Source_DIR_Name}/grub2_extras__GIT_BZR" || true
	
	cp -r "${_WD_OUTER}/grub2_extras__GIT_BZR" "${_WD_OUTER}/${_GRUB2_BIOS_Source_DIR_Name}/grub2_extras__GIT_BZR" || true
	rm -rf "${_WD_OUTER}/${_GRUB2_BIOS_Source_DIR_Name}/grub2_extras__GIT_BZR/zfs" || true
	rm -rf "${_WD_OUTER}/${_GRUB2_BIOS_Source_DIR_Name}/grub2_extras__GIT_BZR/915resolution" || true
	rm -rf "${_WD_OUTER}/${_GRUB2_BIOS_Source_DIR_Name}/grub2_extras__GIT_BZR/ntldr-img" || true
	
	if [[ "${_GRUB2_BIOS_Source_DIR_Name}" != "${_GRUB2_UEFI_Source_DIR_Name}" ]]; then
		cd "${_WD_OUTER}/${_GRUB2_BIOS_Source_DIR_Name}/"
		echo
	fi
	
	cp --verbose "${_WD_OUTER}/xman_dos2unix.sh" "${_WD_OUTER}/grub.default ${_WD_OUTER}/${_GRUB2_BIOS_Source_DIR_Name}/" || true
	cp --verbose "${_WD_OUTER}/grub2_bios_linux_scripts/grub2_bios.sh" "${_WD_OUTER}/grub2_bios_linux_scripts/grub2_bios_linux_my.sh" "${_WD_OUTER}/${_GRUB2_BIOS_Source_DIR_Name}/"
	echo
	
	rm -f "${_WD_OUTER}/${_GRUB2_BIOS_Source_DIR_Name}/grub.cfg" || true
	cp --verbose "${_BOOTLOADER_CONFIG_FILES_DIR}/BIOS/grub_bios.cfg" "${_WD_OUTER}/${_GRUB2_BIOS_Source_DIR_Name}/grub.cfg" || true
	echo
	
	cd "${_WD_OUTER}/${_GRUB2_BIOS_Source_DIR_Name}/"
	
	## CHROOT into the arch32 system for compiling GRUB2 BIOS i386
	# export _BCHROOT_DIR="${_WD_OUTER}"
	# sudo chroot "${_X86_32_CHROOT}" || exit 1
	# cd "${_BCHROOT_DIR}"
	# unset _BCHROOT_DIR
	
	# schroot --automatic-session --preserve-environment --directory ${_WD_OUTER}
	echo
	
	"${PWD}/grub2_bios_linux_my.sh"
	echo
	cd ..
	
	cp -r "${_WD_OUTER}/${_GRUB2_BIOS_Source_DIR_Name}/GRUB2_BIOS_BUILD_DIR" "${_WD_OUTER}/GRUB2_BIOS_BUILD_DIR" || true
	sudo rm -rf "${_WD_OUTER}/${_GRUB2_BIOS_Source_DIR_Name}/GRUB2_BIOS_BUILD_DIR" || true
	echo
	
	set +x +e
	
fi

unset _PROCESS_CONTINUE_UEFI
unset _PROCESS_CONTINUE_BIOS
unset _BOOTLOADER_CONFIG_FILES_DIR
unset _WD_OUTER
unset _GRUB2_UEFI
unset _GRUB2_BIOS
unset _GRUB2_UEFI_Source_DIR_Name
unset _GRUB2_BIOS_Source_DIR_Name
unset _X86_32_CHROOT

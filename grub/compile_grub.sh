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
	echo '1 for EFI-MAIN alone'
	echo '2 for EFI-EXP alone'
	echo '3 for BIOS-MAIN alone'
	echo '4 for BIOS-EXP alone'
	echo
	export _PROCESS_CONTINUE_UEFI='FALSE'
	export _PROCESS_CONTINUE_BIOS='FALSE'
fi

_DO="${1}"

if [[ "${_DO}" == '1' ]]; then
	export _GRUB_UEFI_SRCDIR='grub__GIT_BZR'
	export _PROCESS_CONTINUE_UEFI='TRUE'
	
elif [[ "${_DO}" == '2' ]]; then
	export _GRUB_UEFI_SRCDIR='grub_experimental__GIT_BZR'
	export _PROCESS_CONTINUE_UEFI='TRUE'
	
elif [[ "${_DO}" == '3' ]]; then
	export _GRUB_BIOS_SRCDIR='grub__GIT_BZR'
	export _PROCESS_CONTINUE_BIOS='TRUE'
	
elif [[ "${_DO}" == '4' ]]; then
	export _GRUB_BIOS_SRCDIR='grub_experimental__GIT_BZR'
	export _PROCESS_CONTINUE_BIOS='TRUE'
	
fi

echo

_APPLY_PATCHES() {
	
	patch -Np1 -i "${_WD_OUTER}/archlinux_grub_mkconfig_fixes.patch"
	echo
	
	patch -Np1 -i "${_WD_OUTER}/grub_extras_lua_args_fix.patch"
	echo
	
	# patch -Np0 -i "${_WD_OUTER}/grub-mactel.patch"
	echo
	
}

_CLEAN_GRUB_SRCDIR() {
	
	echo
	
	cp -r "${_WD_OUTER}/${_GRUB_SRCDIR}/.git" "${_WD_OUTER}/.git_grub_src"
	rm -rf "${_WD_OUTER}/${_GRUB_SRCDIR}"/* || true
	rm -rf "${_WD_OUTER}/${_GRUB_SRCDIR}"/.* || true
	echo
	
	if [[ ! -d "${_WD_OUTER}/${_GRUB_SRCDIR}/.git" ]]; then
		cp -r "${_WD_OUTER}/.git_grub_src" "${_WD_OUTER}/${_GRUB_SRCDIR}/.git"
	fi
	echo
	
	rm -rf "${_WD_OUTER}/.git_grub_src" || true
	echo
	
	cd "${_WD_OUTER}/${_GRUB_SRCDIR}/"
	git reset --hard
	echo
	
	git checkout master
	echo
	
}

_SCHROOT() {
	
	## CHROOT into the arch32 system for compiling GRUB BIOS i386
	# export _BCHROOT_DIR="${_WD_OUTER}"
	# sudo chroot "${_X86_32_CHROOT}" || exit 1
	# cd "${_BCHROOT_DIR}"
	# unset _BCHROOT_DIR
	
	# schroot --automatic-session --preserve-environment --directory ${_WD_OUTER}
	echo
	
}

_COMPILE_GRUB() {
	
	_CLEAN_GRUB_SRCDIR
	echo
	
	cp -r "${_WD_OUTER}/grub_extras__GIT_BZR" "${_WD_OUTER}/${_GRUB_SRCDIR}/grub_extras__GIT_BZR" || true
	# rm -rf "${_WD_OUTER}/${_GRUB_SRCDIR}/grub_extras__GIT_BZR/lua" || true
	rm -rf "${_WD_OUTER}/${_GRUB_SRCDIR}/grub_extras__GIT_BZR/gpxe" || true
	echo
	
	if [[ "${_GRUB_PLATFORM}" == "uefi" ]]; then
		rm -rf "${_WD_OUTER}/${_GRUB_SRCDIR}/grub_extras__GIT_BZR/ntldr-img" || true
		rm -rf "${_WD_OUTER}/${_GRUB_SRCDIR}/grub_extras__GIT_BZR/915resolution" || true
		echo
	fi
	
	if [[ "${_GRUB_PLATFORM}" == "bios" ]]; then
		# rm -rf "${_WD_OUTER}/${_GRUB_SRCDIR}/grub_extras__GIT_BZR/ntldr-img" || true
		# rm -rf "${_WD_OUTER}/${_GRUB_SRCDIR}/grub_extras__GIT_BZR/915resolution" || true
		echo
	fi
	
	_APPLY_PATCHES
	echo
	
	cp --verbose "${_GRUB_SCRIPTS_DIR}/grub_${_GRUB_PLATFORM}.sh" "${_GRUB_SCRIPTS_DIR}/grub_${_GRUB_PLATFORM}_linux_my.sh" "${_WD_OUTER}/${_GRUB_SRCDIR}/"
	cp --verbose "${_WD_OUTER}/xman_dos2unix.sh" "${_WD_OUTER}/grub.default" "${_WD_OUTER}/${_GRUB_SRCDIR}/" || true
	cp --verbose "${_BOOTLOADER_CONFIG_FILES_DIR}/UEFI/grub_uefi.cfg" "${_WD_OUTER}/${_GRUB_SRCDIR}/grub.cfg" || true
	echo
	
	# "${_WD_OUTER}/xman_dos2unix.sh" * || true
	
	"${PWD}/grub_${_GRUB_PLATFORM}_linux_my.sh"
	echo
	
}

if [[ "${_PROCESS_CONTINUE_UEFI}" == 'TRUE' ]]; then
	
	set -x -e
	
	echo
	
	_GRUB_PLATFORM="uefi"
	_GRUB_SRCDIR="${_GRUB_UEFI_SRCDIR}"
	_COMPILE_GRUB
	
	echo
	
	cp -r "${_WD_OUTER}/${_GRUB_SRCDIR}/GRUB_UEFI_BUILD_DIR_x86_64" "${_WD_OUTER}/GRUB_UEFI_BUILD_DIR_x86_64" || true
	rm -rf "${_WD_OUTER}/${_GRUB_SRCDIR}/GRUB_UEFI_BUILD_DIR_x86_64" || true
	
	echo
	
	_CLEAN_GRUB_SRCDIR
	
	echo
	
	set +x +e
	
fi

if [[ "${_PROCESS_CONTINUE_BIOS}" == 'TRUE' ]]; then
	
	set -x -e
	
	echo
	
	_GRUB_PLATFORM="bios"
	_GRUB_SRCDIR="${_GRUB_BIOS_SRCDIR}"
	_COMPILE_GRUB
	
	echo
	
	cp -r "${_WD_OUTER}/${_GRUB_BIOS_SRCDIR}/GRUB_BIOS_BUILD_DIR" "${_WD_OUTER}/GRUB_BIOS_BUILD_DIR" || true
	rm -rf "${_WD_OUTER}/${_GRUB_BIOS_SRCDIR}/GRUB_BIOS_BUILD_DIR" || true
	
	echo
	
	_CLEAN_GRUB_SRCDIR
	
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
unset _GRUB_SRCDIR
unset _GRUB_UEFI_SRCDIR
unset _GRUB_BIOS_SRCDIR
unset _X86_32_CHROOT

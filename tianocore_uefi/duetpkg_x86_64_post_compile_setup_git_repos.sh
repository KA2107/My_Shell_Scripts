#!/bin/bash

set -x -e

_SOURCE_CODES_DIR='/media/Source_Codes/Source_Codes'

_WD="${_SOURCE_CODES_DIR}/Firmware/UEFI/TianoCore_Sourceforge"

source "${_WD}/tianocore_uefi_duetpkg_common.sh"

_MIGLE_BOOTDUET_COPY() {
	
	echo
	
	_MIGLE_BOOTDUET_COMPILE
	
	echo
	
	rm -f "${_UEFI_DUET_INSTALLER_DIR}/BootSector"/bd*.bin || true
	install -D -m644 "${_MIGLE_BOOTDUET_COMPILE_DIR}"/bd*.bin "${_UEFI_DUET_INSTALLER_DIR}/BootSector/"
	
	echo
	
	_MIGLE_BOOTDUET_CLEAN
	
	echo
	
	rm -f "${_UEFI_DUET_INSTALLER_DIR}/Migle_BootDuet_INSTALL.txt" || true
	install -D -m644 "${_MIGLE_BOOTDUET_COMPILE_DIR}/INSTALL" "${_UEFI_DUET_INSTALLER_DIR}/Migle_BootDuet_INSTALL.txt"
	
	echo
	
	rm -f "${_UEFI_DUET_INSTALLER_DIR}/Licenses/Migle_BootDuet_LICENSE.txt" || true
	install -D -m644 "${_MIGLE_BOOTDUET_COMPILE_DIR}/COPYING" "${_UEFI_DUET_INSTALLER_DIR}/Licenses/Migle_BootDuet_LICENSE.txt"
	
	echo
	
}

_ROD_SMITH_DUET_INSTALL() {
	
	echo
	
	rm -f "${_UEFI_DUET_INSTALLER_DIR}/duet-install" || true
	install -D -m644 "${_ROD_SMITH_DUET_INSTALL_DIR}/duet-install" "${_UEFI_DUET_INSTALLER_DIR}/duet-install"
	
	echo
	
	rm -f "${_UEFI_DUET_INSTALLER_DIR}/duet-install.8" || true
	install -D -m644 "${_ROD_SMITH_DUET_INSTALL_DIR}/duet-install.8" "${_UEFI_DUET_INSTALLER_DIR}/duet-install.8"
	
	echo
	
	sed 's|https://github.com/skodabenz/EFI_DUETPKG|https://gitorious.org/tianocore_uefi_duet_builds/tianocore_uefi_duet_installer|g' -i "${_UEFI_DUET_INSTALLER_DIR}/duet-install.8" || true
	sed 's|BootDuet source code and UEFI DUETPKG binaries can be obtained from GitHub|BootDuet source code can be obtained from GitHub and UEFI DUETPKG binaries can be obtained from Gitorious|g' -i "${_UEFI_DUET_INSTALLER_DIR}/duet-install.8" || true
	
	echo
	
	rm -f "${_UEFI_DUET_INSTALLER_DIR}/Licenses/srs5694_duet-install_LICENSE.txt" || true
	install -D -m644 "${_ROD_SMITH_DUET_INSTALL_DIR}/COPYING" "${_UEFI_DUET_INSTALLER_DIR}/Licenses/srs5694_duet-install_LICENSE.txt"
	
	echo
	
}

_UEFI_DUET_INSTALLER_GIT() {
	
	echo
	echo "Tianocore_UEFI_DUET_Installer_GIT"
	echo
	
	if [[ -e "${_DUETPKG_EMUVARIABLE_BUILD_DIR}/FV/Efildr20" ]]; then
		if [[ "$(file "${_DUETPKG_EMUVARIABLE_BUILD_DIR}/FV/Efildr20" | grep "Efildr20: x86 boot sector")" ]]; then
			rm -f "${_UEFI_DUET_INSTALLER_DIR}/Efildr/UDK_X64/Efildr20" || true
			install -D -m644 "${_DUETPKG_EMUVARIABLE_BUILD_DIR}/FV/Efildr20" "${_UEFI_DUET_INSTALLER_DIR}/Efildr/UDK_X64/Efildr20"
		fi
	fi
	
	echo
	
	if [[ -e "${_DUETPKG_FSVARIABLE_BUILD_DIR}/FV/Efildr20" ]]; then
		if [[ "$(file "${_DUETPKG_FSVARIABLE_BUILD_DIR}/FV/Efildr20" | grep "Efildr20: x86 boot sector")" ]]; then
			rm -f "${_UEFI_DUET_INSTALLER_DIR}/Efildr/UDK_X64/Efildr20_FSVariable" || true
			install -D -m644 "${_DUETPKG_FSVARIABLE_BUILD_DIR}/FV/Efildr20" "${_UEFI_DUET_INSTALLER_DIR}/Efildr/UDK_X64/Efildr20_FSVariable"
		fi
	fi
	
	echo
	
	rm -f "${_UEFI_DUET_INSTALLER_DIR}/Shell/UDK_X64/Shell_Full.efi" || true
	rm -f "${_UEFI_DUET_INSTALLER_DIR}/Shell/UDK_X64/Shell_Full_old.efi" || true
	install -D -m644 "${_UDK_DIR}/ShellBinPkg/UefiShell/X64/Shell.efi" "${_UEFI_DUET_INSTALLER_DIR}/Shell/UDK_X64/Shell_Full.efi"
	install -D -m644 "${_UDK_DIR}/EdkShellBinPkg/FullShell/X64/Shell_Full.efi" "${_UEFI_DUET_INSTALLER_DIR}/Shell/UDK_X64/Shell_Full_old.efi"
	
	echo
	
	_MIGLE_BOOTDUET_COPY
	
	echo
	
	_ROD_SMITH_DUET_INSTALL
	
	echo
	
	rm -f "${_UEFI_DUET_INSTALLER_DIR}/BootSector"/{bs32,Gpt,Mbr}.com || true
	install -D -m644 "${_UDK_DUETPKG_BOOTSECT_BIN_DIR}"/{bs32,Gpt,Mbr}.com "${_UEFI_DUET_INSTALLER_DIR}/BootSector/"
	
	echo
	
	rm -rf "${_UEFI_DUET_INSTALLER_DIR}/Linux_Source" || true
	mkdir -p "${_UEFI_DUET_INSTALLER_DIR}/Linux_Source"
	cp -r "${_UDK_C_SOURCE_DIR}" "${_UEFI_DUET_INSTALLER_DIR}/Linux_Source/C"
	# chmod -R -x "${_UEFI_DUET_INSTALLER_DIR}/Linux_Source/C" || true
	
	echo
	
	rm -f "${_UEFI_DUET_INSTALLER_DIR}/Windows_Binaries"/{BootSectImage,GenBootSector}.exe || true
	install -D -m644 "${_UDK_DIR}/BaseTools/Bin/Win32"/{BootSectImage,GenBootSector}.exe "${_UEFI_DUET_INSTALLER_DIR}/Windows_Binaries/"
	
	echo
	
	cd "${_UDK_DIR}/"
	rm -f "${_UEFI_DUET_INSTALLER_DIR}/UDK_EDK2_DuetPkg_Changes_to_Makefiles.patch" || true
	git diff remotes/origin/master...keshav_pr > "${_UEFI_DUET_INSTALLER_DIR}/UDK_EDK2_DuetPkg_Changes_to_Makefiles.patch"
	chmod -x "${_UEFI_DUET_INSTALLER_DIR}/UDK_EDK2_DuetPkg_Changes_to_Makefiles.patch" || true
	
	echo
	
	cd "${_UEFI_DUET_INSTALLER_DIR}/"
	git add *
	git status
	git commit -a -m "$(date +%d-%b-%Y)" || true
	
	echo
	echo "Tianocore_UEFI_DUET_Installer_GIT done"
	echo
	
}

_DUET_MEMDISK_COMPILED_GIT() {
	
	echo
	echo "Tianocore_UEFI_DUET_memdisk_compiled_GIT"
	echo
	
	if [[ -e "${_DUETPKG_EMUVARIABLE_BUILD_DIR}/floppy.img" ]]; then
		if [[ "$(file "${_DUETPKG_EMUVARIABLE_BUILD_DIR}/FV/Efildr" | grep "Efildr: x86 boot sector")" ]]; then
			rm -f "${_DUET_MEMDISK_COMPILED_DIR}/Tianocore_UEFI_UDK_DUET_X86_64.img" || true
			install -D -m644 "${_DUETPKG_EMUVARIABLE_BUILD_DIR}/floppy.img" "${_DUET_MEMDISK_COMPILED_DIR}/Tianocore_UEFI_UDK_DUET_X86_64.img"
			# [[ -e "${_WD}/duet_x86_64_memdisk.bin" ]] && install -D -m644 "${_WD}/duet_x86_64_memdisk.bin" "${_DUET_MEMDISK_COMPILED_DIR}/Tianocore_UEFI_UDK_DUET_X86_64.img"
		fi
	fi
	
	echo
	
	cd "${_DUET_MEMDISK_COMPILED_DIR}/"
	git add *
	git status
	git commit -a -m "$(date +%d-%b-%Y)" || true
	
	echo
	echo "Tianocore_UEFI_DUET_memdisk_compiled_GIT done"
	echo
	
}

_DUET_MEMDISK_TOOLS_GIT() {
	
	echo
	echo "Tianocore_UEFI_DUET_memdisk_tools_GIT"
	echo
	
	rm -rf "${_DUET_MEMDISK_TOOLS_DIR}/Linux_Source" || true
	mkdir -p "${_DUET_MEMDISK_TOOLS_DIR}/Linux_Source"
	cp -r "${_UDK_C_SOURCE_DIR}" "${_DUET_MEMDISK_TOOLS_DIR}/Linux_Source/C"
	# chmod -R -x "${_DUET_MEMDISK_TOOLS_DIR}/Linux_Source/C" || true
	
	echo
	
	rm -f "${_DUET_MEMDISK_TOOLS_DIR}/Windows"/{BootSectImage,GenBootSector}.exe || true
	install -D -m644 "${_UDK_DIR}/BaseTools/Bin/Win32"/{BootSectImage,GenBootSector}.exe "${_DUET_MEMDISK_TOOLS_DIR}/Windows/"
	
	echo
	
	rm -f "${_DUET_MEMDISK_TOOLS_DIR}/bootsect.com.unmod" || true
	install -D -m644 "${_UDK_DUETPKG_BOOTSECT_BIN_DIR}/bootsect.com" "${_DUET_MEMDISK_TOOLS_DIR}/bootsect.com.unmod"
	
	if [[ -e "${_DUETPKG_EMUVARIABLE_BUILD_DIR}/FV/Efildr" ]]; then
		if [[ "$(file "${_DUETPKG_EMUVARIABLE_BUILD_DIR}/FV/Efildr" | grep "Efildr: x86 boot sector")" ]]; then
			rm -f "${_DUET_MEMDISK_TOOLS_DIR}/Efildr" || true
			install -D -m644 "${_DUETPKG_EMUVARIABLE_BUILD_DIR}/FV/Efildr" "${_DUET_MEMDISK_TOOLS_DIR}/Efildr"
		fi
	fi
	
	echo
	
	cd "${_DUET_MEMDISK_TOOLS_DIR}/"
	git add *
	git status
	git commit -a -m "$(date +%d-%b-%Y)" || true
	
	echo
	echo "Tianocore_UEFI_DUET_memdisk_tools_GIT"
	echo
	
}

echo

_UEFI_DUET_INSTALLER_GIT

echo

# _POST_DUET_MEMDISK

echo

_DUET_MEMDISK_COMPILED_GIT

echo

_DUET_MEMDISK_TOOLS_GIT

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

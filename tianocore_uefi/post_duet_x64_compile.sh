#!/bin/bash

set -x -e

SOURCE_CODES_DIR="/media/Source_Codes/Source_Codes"
WD="${SOURCE_CODES_DIR}/Firmware/UEFI/TianoCore_Sourceforge"

source "${WD}/tianocore_duet_common.sh"

MIGLE_BOOTDUET_COPY() {
	
	echo
	
	MIGLE_BOOTDUET_COMPILE
	
	echo
	
	rm -f "${UEFI_DUET_INSTALLER_DIR}/BootSector"/bd*.bin || true
	install -D -m644 "${MIGLE_BOOTDUET_COMPILE_DIR}"/bd*.bin "${UEFI_DUET_INSTALLER_DIR}/BootSector/"
	
	echo
	
	MIGLE_BOOTDUET_CLEAN
	
	echo
	
	rm -f "${UEFI_DUET_INSTALLER_DIR}/Migle_BootDuet_INSTALL.txt" || true
	install -D -m644 "${MIGLE_BOOTDUET_COMPILE_DIR}/INSTALL" "${UEFI_DUET_INSTALLER_DIR}/Migle_BootDuet_INSTALL.txt"
	
	echo
	
	sed -i 's|https://github.com/skodabenz/UEFI_DUET|https://gitorious.org/tianocore_uefi_duet_builds/tianocore_uefi_duet_installer|g' "${UEFI_DUET_INSTALLER_DIR}/Migle_BootDuet_INSTALL.txt" || true
	sed -i 's|https://github.com/skodabenz/EFI_DUET|https://gitorious.org/tianocore_uefi_duet_builds/tianocore_uefi_duet_installer|g' "${UEFI_DUET_INSTALLER_DIR}/Migle_BootDuet_INSTALL.txt" || true
	
	echo
	
	rm -f "${UEFI_DUET_INSTALLER_DIR}/Licenses/Migle_BootDuet_LICENSE.txt" || true
	install -D -m644 "${MIGLE_BOOTDUET_COMPILE_DIR}/COPYING" "${UEFI_DUET_INSTALLER_DIR}/Licenses/Migle_BootDuet_LICENSE.txt"
	
	echo
	
}

SRS5694_DUET_INSTALL() {
	
	echo
	
	rm -f "${UEFI_DUET_INSTALLER_DIR}/duet-install" || true
	install -D -m644 "${SRS5694_DUET_INSTALL_DIR}/duet-install" "${UEFI_DUET_INSTALLER_DIR}/duet-install"
	
	echo
	
	rm -f "${UEFI_DUET_INSTALLER_DIR}/duet-install.8" || true
	install -D -m644 "${SRS5694_DUET_INSTALL_DIR}/duet-install.8" "${UEFI_DUET_INSTALLER_DIR}/duet-install.8"
	
	echo
	
	sed -i 's|https://github.com/skodabenz/EFI_DUET|https://gitorious.org/tianocore_uefi_duet_builds/tianocore_uefi_duet_installer|g' "${UEFI_DUET_INSTALLER_DIR}/duet-install.8" || true
	sed -i 's|BootDuet source code and UEFI DUET binaries can be obtained from GitHub|BootDuet source code can be obtained from GitHub and UEFI DUET binaries can be obtained from Gitorious|g' "${UEFI_DUET_INSTALLER_DIR}/duet-install.8" || true
	
	echo
	
	rm -f "${UEFI_DUET_INSTALLER_DIR}/Licenses/srs5694_duet-install_LICENSE.txt" || true
	install -D -m644 "${SRS5694_DUET_INSTALL_DIR}/COPYING" "${UEFI_DUET_INSTALLER_DIR}/Licenses/srs5694_duet-install_LICENSE.txt"
	
	echo
	
}

UEFI_DUET_INSTALLER_GIT() {
	
	echo
	echo "Tianocore_UEFI_DUET_Installer_GIT"
	echo
	
	if [ -e "${DUET_EMUVARIABLE_BUILD_DIR}/FV/Efildr20" ]
	then
		rm -f "${UEFI_DUET_INSTALLER_DIR}/Efildr/UDK_X64/Efildr20" || true
		install -D -m644 "${DUET_EMUVARIABLE_BUILD_DIR}/FV/Efildr20" "${UEFI_DUET_INSTALLER_DIR}/Efildr/UDK_X64/Efildr20"
	fi
	
	echo
	
	if [ -e "${DUET_FSVARIABLE_BUILD_DIR}/FV/Efildr20" ]
	then
		rm -f "${UEFI_DUET_INSTALLER_DIR}/Efildr/UDK_X64/Efildr20_FSVariable" || true
		install -D -m644 "${DUET_FSVARIABLE_BUILD_DIR}/FV/Efildr20" "${UEFI_DUET_INSTALLER_DIR}/Efildr/UDK_X64/Efildr20_FSVariable"
	fi
	
	echo
	
	rm -f "${UEFI_DUET_INSTALLER_DIR}/Shell/UDK_X64/Shell_Full.efi" || true
	rm -f "${UEFI_DUET_INSTALLER_DIR}/Shell/UDK_X64/Shell_Full_old.efi" || true
	install -D -m644 "${EDK2_DIR}/ShellBinPkg/UefiShell/X64/Shell.efi" "${UEFI_DUET_INSTALLER_DIR}/Shell/UDK_X64/Shell_Full.efi"
	install -D -m644 "${EDK2_DIR}/EdkShellBinPkg/FullShell/X64/Shell_Full.efi" "${UEFI_DUET_INSTALLER_DIR}/Shell/UDK_X64/Shell_Full_old.efi"
	
	echo
	
	MIGLE_BOOTDUET_COPY
	
	echo
	
	SRS5694_DUET_INSTALL
	
	echo
	
	rm -f "${UEFI_DUET_INSTALLER_DIR}/BootSector"/{bs32,Gpt,Mbr}.com || true
	install -D -m644 "${EDK2_DUET_BOOTSECT_BIN_DIR}"/{bs32,Gpt,Mbr}.com "${UEFI_DUET_INSTALLER_DIR}/BootSector/"
	
	echo
	
	rm -rf "${UEFI_DUET_INSTALLER_DIR}/Linux_Source/C" || true
	install -Dd -m644 "${EDK2_C_SOURCE_DIR}" "${UEFI_DUET_INSTALLER_DIR}/Linux_Source/C"
	
	echo
	
	rm -f "${UEFI_DUET_INSTALLER_DIR}/Windows_Binaries"/{BootSectImage,GenBootSector}.exe || true
	install -D -m644 "${EDK2_DIR}/BaseTools/Bin/Win32"/{BootSectImage,GenBootSector}.exe "${UEFI_DUET_INSTALLER_DIR}/Windows_Binaries/"
	
	echo
	
	cd "${EDK2_DIR}/"
	rm -f "${UEFI_DUET_INSTALLER_DIR}/UDK_EDK2_DuetPkg_Changes_to_Makefiles.patch" || true
	git diff remotes/origin/master...keshav_pr > "${UEFI_DUET_INSTALLER_DIR}/UDK_EDK2_DuetPkg_Changes_to_Makefiles.patch"
	chmod -x "${UEFI_DUET_INSTALLER_DIR}/UDK_EDK2_DuetPkg_Changes_to_Makefiles.patch" || true
	
	echo
	
	cd "${UEFI_DUET_INSTALLER_DIR}/"
	git add *
	git status
	git commit -a -m "$(date +%d-%b-%Y)" || true
	
	echo
	echo "Tianocore_UEFI_DUET_Installer_GIT done"
	echo
	
}

DUET_MEMDISK_COMPILED_GIT() {
	
	echo
	echo "Tianocore_UEFI_DUET_memdisk_compiled_GIT"
	echo
	
	if [ -e "${DUET_EMUVARIABLE_BUILD_DIR}/floppy.img" ]
	then
		rm -f "${DUET_MEMDISK_COMPILED_DIR}/Tianocore_UEFI_UDK_DUET_X64.img" || true
		install -D -m644 "${DUET_EMUVARIABLE_BUILD_DIR}/floppy.img" "${DUET_MEMDISK_COMPILED_DIR}/Tianocore_UEFI_UDK_DUET_X64.img"
		# [ -e "${WD}/duet_x64_memdisk.bin" ] && install -D -m644 "${WD}/duet_x64_memdisk.bin" "${DUET_MEMDISK_COMPILED_DIR}/Tianocore_UEFI_UDK_DUET_X64.img"
	fi
	
	echo
	
	cd "${DUET_MEMDISK_COMPILED_DIR}/"
	git add *
	git status
	git commit -a -m "$(date +%d-%b-%Y)" || true
	
	echo
	echo "Tianocore_UEFI_DUET_memdisk_compiled_GIT done"
	echo
	
}

DUET_MEMDISK_TOOLS_GIT() {
	
	echo
	echo "Tianocore_UEFI_DUET_memdisk_tools_GIT"
	echo
	
	rm -rf "${DUET_MEMDISK_TOOLS_DIR}/Linux_Source/C" || true
	install -Dd -m644 "${EDK2_C_SOURCE_DIR}" "${DUET_MEMDISK_TOOLS_DIR}/Linux_Source/C"
	
	echo
	
	rm -f "${DUET_MEMDISK_TOOLS_DIR}/Windows"/{BootSectImage,GenBootSector}.exe || true
	install -D -m644 "${EDK2_DIR}/BaseTools/Bin/Win32"/{BootSectImage,GenBootSector}.exe "${DUET_MEMDISK_TOOLS_DIR}/Windows/"
	
	echo
	
	rm -f "${DUET_MEMDISK_TOOLS_DIR}/bootsect.com.unmod" || true
	install -D -m644 "${EDK2_DUET_BOOTSECT_BIN_DIR}/bootsect.com" "${DUET_MEMDISK_TOOLS_DIR}/bootsect.com.unmod"
	
	if [ -e "${DUET_EMUVARIABLE_BUILD_DIR}/FV/Efildr" ]
	then
		rm -f "${DUET_MEMDISK_TOOLS_DIR}/Efildr" || true
		install -D -m644 "${DUET_EMUVARIABLE_BUILD_DIR}/FV/Efildr" "${DUET_MEMDISK_TOOLS_DIR}/Efildr"
	fi
	
	echo
	
	cd "${DUET_MEMDISK_TOOLS_DIR}/"
	git add *
	git status
	git commit -a -m "$(date +%d-%b-%Y)" || true
	
	echo
	echo "Tianocore_UEFI_DUET_memdisk_tools_GIT"
	echo
	
}

echo

UEFI_DUET_INSTALLER_GIT

echo

# POST_DUET_MEMDISK

echo

DUET_MEMDISK_COMPILED_GIT

echo

DUET_MEMDISK_TOOLS_GIT

echo

unset SOURCE_CODES_DIR
unset WD
unset EDK2_DIR
unset EDK2_BUILD_TOOLS_DIR
unset EDK_TOOLS_PATH
unset EDK2_C_SOURCE_DIR
unset EDK2_DUET_BOOTSECT_BIN_DIR
unset EDK2_BUILD_DIR
unset DUET_EMUVARIABLE_BUILD_DIR
unset DUET_FSVARIABLE_BUILD_DIR
unset DUET_COMPILED_DIR
unset UEFI_DUET_INSTALLER_DIR
unset DUET_MEMDISK_COMPILED_DIR
unset DUET_MEMDISK_TOOLS_DIR
unset MIGLE_BOOTDUET_COMPILE_DIR
unset SRS5694_DUET_INSTALL_DIR
unset BOOTPART
unset EFISYS
unset SYSLINUX_DIR

set +x +e

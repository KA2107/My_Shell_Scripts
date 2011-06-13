#!/bin/sh

set -x -e

SOURCE_CODES_DIR="/media/Data_2/Source_Codes"
WD="${SOURCE_CODES_DIR}/Firmware/UEFI/TianoCore_Sourceforge"

source "${WD}/tianocore_duet_common.sh"

MIGLE_BOOTDUET_COPY() {
	
	echo
	
	MIGLE_BOOTDUET_COMPILE
	
	echo
	
	rm -rf "${EFI_DUET_GIT_DIR}/BootSector"/bd*.bin || true
	cp "${MIGLE_BOOTDUET_COMPILE_DIR}"/bd*.bin "${EFI_DUET_GIT_DIR}/BootSector/"
	
	echo
	
	MIGLE_BOOTDUET_CLEAN
	
	echo
	
	rm -rf "${EFI_DUET_GIT_DIR}/Migle_BootDuet_INSTALL.txt" || true
	cp "${MIGLE_BOOTDUET_COMPILE_DIR}/INSTALL" "${EFI_DUET_GIT_DIR}/Migle_BootDuet_INSTALL.txt"
	
	echo
	
	rm -rf "${EFI_DUET_GIT_DIR}/Licenses/Migle_BootDuet_LICENSE.txt" || true
	cp "${MIGLE_BOOTDUET_COMPILE_DIR}/COPYING" "${EFI_DUET_GIT_DIR}/Licenses/Migle_BootDuet_LICENSE.txt"
	
	echo
	
}

SRS5694_DUET_INSTALL() {
	
	echo
	
	rm -rf "${EFI_DUET_GIT_DIR}/duet-install" || true
	cp "${SRS5694_DUET_INSTALL_DIR}/duet-install" "${EFI_DUET_GIT_DIR}/duet-install"
	
	echo
	
	rm -rf "${EFI_DUET_GIT_DIR}/duet-install.8" || true
	cp "${SRS5694_DUET_INSTALL_DIR}/duet-install.8" "${EFI_DUET_GIT_DIR}/duet-install.8"
	
	echo
	
	rm -rf "${EFI_DUET_GIT_DIR}/Licenses/srs5694_duet-install_LICENSE.txt" || true
	cp "${SRS5694_DUET_INSTALL_DIR}/COPYING" "${EFI_DUET_GIT_DIR}/Licenses/srs5694_duet-install_LICENSE.txt"
	
	echo
	
}

EFI_DUET_GIT() {
	
	echo
	echo "EFI_DUET_GIT"
	echo
	
	rm -rf "${EFI_DUET_GIT_DIR}/Efildr/UDK_X64/Efildr20" || true
	cp "${DUET_EMUVARIABLE_BUILD_DIR}/FV/Efildr20" "${EFI_DUET_GIT_DIR}/Efildr/UDK_X64/Efildr20"
	
	echo
	
	rm -rf "${EFI_DUET_GIT_DIR}/Efildr/UDK_X64/Efildr20_FSVariable" || true
	cp "${DUET_FSVARIABLE_BUILD_DIR}/FV/Efildr20" "${EFI_DUET_GIT_DIR}/Efildr/UDK_X64/Efildr20_FSVariable"
	
	echo
	
	rm -rf "${EFI_DUET_GIT_DIR}/Shell/UDK_X64/Shell_Full.efi" || true
	cp "${EDK2_DIR}/ShellBinPkg/UefiShell/X64/Shell.efi" "${EFI_DUET_GIT_DIR}/Shell/UDK_X64/Shell_Full.efi"
	cp "${EDK2_DIR}/EdkShellBinPkg/FullShell/X64/Shell_Full.efi" "${EFI_DUET_GIT_DIR}/Shell/UDK_X64/Shell_Full_old.efi"
	
	echo
	
	MIGLE_BOOTDUET_COPY
	
	echo
	
	SRS5694_DUET_INSTALL
	
	echo
	
	rm -rf "${EFI_DUET_GIT_DIR}/BootSector"/{bs32,Gpt,Mbr}.com || true
	cp "${EDK2_DUET_BOOTSECT_BIN_DIR}"/{bs32,Gpt,Mbr}.com "${EFI_DUET_GIT_DIR}/BootSector/"
	
	echo
	
	rm -rf "${EFI_DUET_GIT_DIR}/Linux_Source/C" || true
	cp -r "${EDK2_C_SOURCE_DIR}" "${EFI_DUET_GIT_DIR}/Linux_Source/C"
	
	echo
	
	rm -rf "${EFI_DUET_GIT_DIR}/Windows_Binaries"/{BootSectImage,GenBootSector}.exe || true
	cp "${EDK2_DIR}/BaseTools/Bin/Win32"/{BootSectImage,GenBootSector}.exe "${EFI_DUET_GIT_DIR}/Windows_Binaries/"
	
	echo
	
	cd "${EDK2_DIR}/"
	rm -rf "${EFI_DUET_GIT_DIR}/UDK_EDK2_DuetPkg_Changes_to_Makefiles.patch" || true
	git diff remotes/origin/master...keshav_pr > "${EFI_DUET_GIT_DIR}/UDK_EDK2_DuetPkg_Changes_to_Makefiles.patch"
	
	echo
	
	cd "${EFI_DUET_GIT_DIR}/"
	git add *
	git status
	git commit -a -m "$(date +%d-%b-%Y)" || true
	
	echo
	echo "EFI_DUET_GIT done"
	echo
	
}

MEMDISK_COMPILED_GIT() {
	
	echo
	echo "Tiano_DUET_memdisk_compiled_GIT"
	echo
	
	rm -rf "${MEMDISK_COMPILED_DIR}/Tiano_EDK2_DUET_X64.img" || true
	cp "${DUET_EMUVARIABLE_BUILD_DIR}/floppy.img" "${MEMDISK_COMPILED_DIR}/Tiano_EDK2_DUET_X64.img"
	# cp "${WD}/duet_x64_memdisk.bin" "${MEMDISK_COMPILED_DIR}/Tiano_EDK2_DUET_X64.img"
	
	echo
	
	cd "${MEMDISK_COMPILED_DIR}/"
	git add *
	git status
	git commit -a -m "$(date +%d-%b-%Y)" || true
	
	echo
	echo "Tiano_DUET_memdisk_compiled_GIT done"
	echo
	
}

MEMDISK_GIT() {
	
	echo
	echo "Tiano_DUET_memdisk_GIT"
	echo
	
	rm -rf "${MEMDISK_DIR}/Linux_Source/C" || true
	cp -r "${EDK2_C_SOURCE_DIR}" "${MEMDISK_DIR}/Linux_Source/C"
	
	echo
	
	rm -rf "${MEMDISK_DIR}/Windows"/{BootSectImage,GenBootSector}.exe || true
	cp "${EDK2_DIR}/BaseTools/Bin/Win32"/{BootSectImage,GenBootSector}.exe "${MEMDISK_DIR}/Windows/"
	
	echo
	
	rm -rf "${MEMDISK_DIR}/bootsect.com.unmod" || true
	cp "${EDK2_DUET_BOOTSECT_BIN_DIR}/bootsect.com" "${MEMDISK_DIR}/bootsect.com.unmod"
	
	rm -rf "${MEMDISK_DIR}/Efildr" || true
	cp "${DUET_EMUVARIABLE_BUILD_DIR}/FV/Efildr" "${MEMDISK_DIR}/Efildr"
	
	echo
	
	cd "${MEMDISK_DIR}/"
	git add *
	git status
	git commit -a -m "$(date +%d-%b-%Y)" || true
	
	echo
	echo "Tiano_DUET_memdisk_GIT done"
	echo
	
}

echo

EFI_DUET_GIT

echo

# POST_DUET_MEMDISK

echo

MEMDISK_COMPILED_GIT

echo

MEMDISK_GIT

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
unset COMPILED_DIR
unset EFI_DUET_GIT_DIR
unset MEMDISK_COMPILED_DIR
unset MEMDISK_DIR
unset MIGLE_BOOTDUET_COMPILE_DIR
unset SRS5694_DUET_INSTALL_DIR
unset BOOTPART
unset EFISYS
unset SYSLINUX_DIR

set +x +e

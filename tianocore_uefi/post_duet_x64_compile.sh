#!/bin/sh

set -x -e

SOURCE_CODES_DIR="/media/Data_2/Source_Codes"
WD="${SOURCE_CODES_DIR}/Firmware/UEFI/TianoCore_Sourceforge"

EDK2_DIR="${WD}/edk2_GIT"
EDK2_BUILD_TOOLS_DIR="${WD}/buildtools-BaseTools_GIT"
EDK2_C_SOURCE_DIR="${EDK2_BUILD_TOOLS_DIR}/Source/C"

EDK2_DUET_BOOTSECT_BIN_DIR="${EDK2_DIR}/DuetPkg/BootSector/bin/"
EDK2_BUILD_OUTER_DIR="${EDK2_DIR}/Build/DuetPkgX64/"
EDK2_BUILD_DIR="${EDK2_BUILD_OUTER_DIR}/RELEASE_GCC45/"

DUET_EMUVARIABLE_BUILD_DIR="${WD}/DUET_EMUVARIABLE_BUILD"
DUET_FSVARIABLE_BUILD_DIR="${WD}/DUET_FSVARIABLE_BUILD"

COMPILED_DIR="${SOURCE_CODES_DIR}/Firmware/UEFI/UEFI_Compiled_Implementation/Tianocore_DUET/"
EFI_DUET_GIT_DIR="${COMPILED_DIR}/EFI_DUET_GIT/"
MEMDISK_COMPILED_DIR="${COMPILED_DIR}/Tiano_DUET_memdisk_compiled_GIT/"
MEMDISK_DIR="${COMPILED_DIR}/Tiano_DUET_memdisk_GIT/"

MIGLE_BOOTDUET_COMPILE_DIR="${WD}/migle_BootDuet_GIT"
SRS5694_DUET_INSTALL_DIR="${WD}/srs5694_duet-install_my_GIT"

MIGLE_BOOTDUET_CLEAN() {
	
	echo
	
	cd "${MIGLE_BOOTDUET_DIR}/"
	make clean
	
	echo
	
}

MIGLE_BOOTDUET_COMPILE() {
	
	echo
	echo "Compiling Migle's BootDuet"
	echo
	
	MIGLE_BOOTDUET_CLEAN
	
	echo
	
	make
	make lba64
	make hardcoded-drive
	
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
	
	rm -rf "${EFI_DUET_GIT_DIR}/Licenses/Srs5694_duet-install_LICENSE.txt" || true
	cp "${SRS5694_DUET_INSTALL_DIR}/COPYING" "${EFI_DUET_GIT_DIR}/Licenses/Srs5694_duet-install_LICENSE.txt"
	
	echo
	
}

POST_DUET_MEMDISK() {
	
	echo
	
	"${WD}/creata_duet_x64_memdisk.sh"
	
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
	
	MIGLE_BOOTDUET_COMPILE
	
	echo
	
	SRS5694_DUET_INSTALL
	
	echo
	
	rm -rf "${EFI_DUET_GIT_DIR}/BootSector"/{bs32,Gpt,Mbr}.com || true
	cp "${EDK2_DUET_BOOTSECT_BIN_DIR}"/{bs32,Gpt,Mbr}.com "${EFI_DUET_GIT_DIR}/BootSector/"
	
	echo
	
	rm -rf "${EFI_DUET_GIT_DIR}/Linux_Source/C" || true
	cp -r "${EDK2_C_SOURCE_DIR}" "${EFI_DUET_GIT_DIR}/Linux_Source/C"
	
	echo
	
	rm -rf "${EFI_DUET_GIT_DIR}/Win_Bin"/{BootSectImage,GenBootSector}.exe || true
	cp "${EDK2_DIR}/BaseTools/Bin/Win32"/{BootSectImage,GenBootSector}.exe "${EFI_DUET_GIT_DIR}/Win_Bin/"
	
	echo
	
	cd "${EDK2_DIR}/"
	rm -rf "${EFI_DUET_GIT_DIR}/UDK_EDK2_DuetPkg_Changes_to_Makefiles.patch" || true
	git diff remotes/origin/master...keshav_pr > "${EFI_DUET_GIT_DIR}/UDK_EDK2_DuetPkg_Changes_to_Makefiles.patch"
	
	echo
	
	rm -rf "${EFI_DUET_GIT_DIR}/Licenses"/* || true
	cp "${MIGLE_BOOTDUET_COMPILE_DIR}/COPYING" "${EFI_DUET_GIT_DIR}/Licenses/Migle_BootDuet_LICENSE.txt"
	cp 
	
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
	# cp "${EDK2_BUILD_OUTER_DIR}/floppy.img" "${MEMDISK_COMPILED_DIR}/Tiano_EDK2_DUET_X64.img"
	cp "${WD}/duet_x64_memdisk.bin" "${MEMDISK_COMPILED_DIR}/Tiano_EDK2_DUET_X64.img"
	
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

POST_DUET_MEMDISK

echo

MEMDISK_COMPILED_GIT

echo

MEMDISK_GIT

echo

unset SOURCE_CODES_DIR
unset WD
unset EDK2_DIR
unset EDK2_BUILD_TOOLS_DIR
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

set +x +e

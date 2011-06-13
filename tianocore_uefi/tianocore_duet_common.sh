#!/bin/sh

set -x -e

SOURCE_CODES_DIR="/media/Data_2/Source_Codes"
WD="${SOURCE_CODES_DIR}/Firmware/UEFI/TianoCore_Sourceforge"

source "${WD}/tianocore_common.sh"

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

BOOTPART="/boot/"
EFISYS="/boot/efi/"
SYSLINUX_DIR="/usr/lib/syslinux/"

MIGLE_BOOTDUET_CLEAN() {
	
	echo
	
	cd "${MIGLE_BOOTDUET_COMPILE_DIR}/"
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
	
}

POST_DUET_MEMDISK() {
	
	echo
	
	"${WD}/create_duet_x64_memdisk_old.sh"
	
	echo
	
}

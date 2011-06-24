#!/bin/bash

set -x -e

SOURCE_CODES_DIR="/media/Source_Codes/Source_Codes"
WD="${SOURCE_CODES_DIR}/Firmware/UEFI/TianoCore_Sourceforge"

source "${WD}/tianocore_common.sh"

EDK2_DUET_BOOTSECT_BIN_DIR="${EDK2_DIR}/DuetPkg/BootSector/bin/"
EDK2_BUILD_OUTER_DIR="${EDK2_DIR}/Build/DuetPkgX64/"
EDK2_BUILD_DIR="${EDK2_BUILD_OUTER_DIR}/RELEASE_GCC45/"

DUET_EMUVARIABLE_BUILD_DIR="${BACKUP_BUILDS_DIR}/DUET_EMUVARIABLE_BUILD"
DUET_FSVARIABLE_BUILD_DIR="${BACKUP_BUILDS_DIR}/DUET_FSVARIABLE_BUILD"

DUET_BUILDS_DIR="${SOURCE_CODES_DIR}/Firmware/UEFI/UEFI_Compiled_Implementation/Tianocore_UEFI_DUET_Builds/"
UEFI_DUET_INSTALLER_DIR="${DUET_BUILDS_DIR}/Tianocore_UEFI_DUET_Installer_GIT/"
DUET_MEMDISK_COMPILED_DIR="${DUET_BUILDS_DIR}/Tianocore_UEFI_DUET_memdisk_compiled_GIT/"
DUET_MEMDISK_TOOLS_DIR="${DUET_BUILDS_DIR}/Tianocore_UEFI_DUET_memdisk_tools_GIT/"

MIGLE_BOOTDUET_COMPILE_DIR="${WD}/migle_BootDuet_GIT"
SRS5694_DUET_INSTALL_DIR="${WD}/srs5694_duet-install_my_GIT"

BOOTPART="/boot/"
EFISYS="/boot/efi/"
SYSLINUX_DIR="/usr/lib/syslinux/"

DUET_PART_FS_UUID="5FA3-2472"
DUET_PART_MP="/media/DUET"

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

COPY_MEMDISK_SYSLINUX() {
	
	echo
	
	sudo rm -rf "${BOOTPART}/memdisk_syslinux" || true
	sudo cp "${SYSLINUX_DIR}/memdisk" "${BOOTPART}/memdisk_syslinux"
	
	echo
	
}

COPY_EFILDR_MEMDISK() {
	
	echo
	
	sudo rm "${BOOTPART}/Tianocore_UDK_DUET_X64.img" || true
	sudo cp "${DUET_EMUVARIABLE_BUILD_DIR}/floppy.img" "${BOOTPART}/Tianocore_UDK_DUET_X64.img"
	
	echo
	
}

COPY_EFILDR_DUET_PART() {
	
	echo
	
	if [-d "${DUET_PART_MP}" ]
	then
		sudo umount "${DUET_PART_MP}" || true
	else
		sudo mkdir -p "${DUET_PART_MP}"
	fi
	
	sudo mount -t vfat -o rw,users,exec -U "${DUET_PART_FS_UUID}" "${DUET_PART_MP}"
	sudo rm "${DUET_PART_MP}/EFILDR20" || true
	sudo cp "${DUET_EMUVARIABLE_BUILD_DIR}/FV/Efildr20" "${DUET_PART_MP}/EFILDR20"
	sudo umount "${DUET_PART_MP}"
	
	echo
	
}

COPY_UEFI_SHELL_EFISYS_PART() {
	
	echo
	
	sudo rm "${EFISYS}/shellx64.efi" || true
	sudo rm "${EFISYS}/shellx64_old.efi" || true
	
	echo
	
	sudo cp "${EDK2_DIR}/ShellBinPkg/UefiShell/X64/Shell.efi" "${EFISYS}/shellx64.efi"
	sudo cp "${EDK2_DIR}/EdkShellBinPkg/FullShell/X64/Shell_Full.efi" "${EFISYS}/shellx64_old.efi"
	
	echo
	
}

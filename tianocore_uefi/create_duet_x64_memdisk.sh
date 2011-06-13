#!/bin/sh

set -x -e

SOURCE_CODES_DIR="/media/Data_2/Source_Codes"
WD="${SOURCE_CODES_DIR}/Firmware/UEFI/TianoCore_Sourceforge"

EDK2_DIR="${WD}/edk2_GIT"

COMPILED_DIR="${SOURCE_CODES_DIR}/Firmware/UEFI/UEFI_Compiled_Implementation/Tianocore_DUET/"
EFI_DUET_GIT_DIR="${COMPILED_DIR}/EFI_DUET_GIT/"
MEMDISK_COMPILED_DIR="${COMPILED_DIR}/Tiano_DUET_memdisk_compiled_GIT/"
MEMDISK_DIR="${COMPILED_DIR}/Tiano_DUET_memdisk_GIT/"

MIGLE_BOOTDUET_DIR="${WD}/migle_BootDuet_GIT"
SRS5694_DUET_INSTALL_DIR="${WD}/srs5694_duet-install_my_GIT"

BOOTPART="/boot/"
EFISYS="/boot/efi/"
SYSLINUX_DIR="/usr/lib/syslinux/"

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
	
}

CREATE_MEMDISK() {
	
	echo
	
	sudo rm -rf "${BOOTPART}/memdisk_syslinux" || true
	sudo cp "${SYSLINUX_DIR}/memdisk" "${BOOTPART}/memdisk_syslinux"
	
	echo
	
	rm -rf "${WD}/duet_x64_memdisk.bin" || true
	dd if=/dev/zero of="${WD}/duet_x64_memdisk.bin" bs=512 count=2880
	mkfs.vfat -F12 -S 512 -n "EFI_DUET" "${WD}/duet_x64_memdisk.bin"
	
	echo
	
}

COMPILE_MEMDISK() {
	
	echo
	
	# CREATE_MEMDISK
	
	echo
	
	MIGLE_BOOTDUET_COMPILE
	
	echo
	
	sudo modprobe loop
	LOOP_DEVICE=$(losetup --show --find "${WD}/duet_x64_memdisk.bin")
	
	echo
	
	sudo "${SRS5694_DUET_INSTALL_DIR}/duet-install" -b "${MIGLE_BOOTDUET_DIR}" -s "${SYSLINUX_DIR}" -u "${EFI_DUET_GIT_DIR}" "${LOOP_DEVICE}"
	
	echo
	
	MIGLE_BOOTDUET_CLEAN
	
	echo
	
	losetup --detach "${LOOP_DEVICE}"
	
	echo
	
}

echo

CREATE_MEMDISK

echo

COMPILE_MEMDISK

echo

unset SOURCE_CODES_DIR
unset WD
unset EDK2_DIR
unset COMPILED_DIR
unset EFI_DUET_GIT_DIR
unset MEMDISK_COMPILED_DIR
unset MEMDISK_DIR
unset MIGLE_BOOTDUET_DIR
unset SRS5694_DUET_INSTALL_DIR
unset BOOTPART
unset EFISYS
unset SYSLINUX_DIR

set +x +e

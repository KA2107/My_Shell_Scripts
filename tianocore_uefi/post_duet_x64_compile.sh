#!/bin/sh

set -x -e

WD="${PWD}/"

EDK2_DIR="${WD}/edk2_GIT"
EDK2_BUILD_TOOLS_DIR="${WD}/buildtools-BaseTools_GIT"
EDK2_C_SOURCE_DIR="${EDK2_BUILD_TOOLS_DIR}/Source/C"

EDK2_DUET_BOOTSECT_BIN_DIR="${EDK2_DIR}/DuetPkg/BootSector/bin/"
EDK2_BUILD_OUTER_DIR="${EDK2_DIR}/Build/DuetPkgX64/"
EDK2_BUILD_DIR="${EDK2_BUILD_OUTER_DIR}/RELEASE_GCC45/"

COMPILED_DIR="/media/Data_2/Source_Codes/Firmware/UEFI/UEFI_Compiled_Implementation/Tianocore_DUET/"
EFI_DUET_GIT_DIR="${COMPILED_DIR}/EFI_DUET_GIT/"
MEMDISK_COMPILED_DIR="${COMPILED_DIR}/Tiano_DUET_memdisk_compiled_GIT/"
MEMDISK_DIR="${COMPILED_DIR}/Tiano_DUET_memdisk_GIT/"

MIGLE_BOOTDUET_DIR="${WD}/migle_BootDuet_GIT"

echo
echo "Compiling Migle's BootDuet"
echo

cd "${MIGLE_BOOTDUET_DIR}/"
make clean

echo

make
make lba64
make hardcoded-drive

echo
echo "EFI_DUET_GIT"
echo

rm "${EFI_DUET_GIT_DIR}/BootSector"/{bs32,Gpt,Mbr}.com || true
cp "${EDK2_DUET_BOOTSECT_BIN_DIR}"/{bs32,Gpt,Mbr}.com "${EFI_DUET_GIT_DIR}/BootSector/"

echo

rm "${EFI_DUET_GIT_DIR}/BootSector"/{bd32,bd32_64,bd32hd}.bin || true
cp "${MIGLE_BOOTDUET_DIR}"/{bd32,bd32_64,bd32hd}.bin "${EFI_DUET_GIT_DIR}/BootSector/"

echo

rm "${EFI_DUET_GIT_DIR}/Migle_BootDuet_INSTALL.txt" || true
cp "${MIGLE_BOOTDUET_DIR}/INSTALL" "${EFI_DUET_GIT_DIR}/Migle_BootDuet_INSTALL.txt"

echo

rm "${EFI_DUET_GIT_DIR}/Efildr/EDK2_X64/Efildr20" || true
cp "${EDK2_BUILD_DIR}/FV/Efildr20" "${EFI_DUET_GIT_DIR}/Efildr/EDK2_X64/Efildr20"

echo

rm "${EFI_DUET_GIT_DIR}/Shell/EDK2_X64/Shell_Full.efi" || true
cp "${EDK2_DIR}/ShellBinPkg/UefiShell/X64/Shell.efi" "${EFI_DUET_GIT_DIR}/Shell/EDK2_X64/Shell_Full.efi"
# cp "${EDK2_DIR}/EdkShellBinPkg/FullShell/X64/Shell_Full.efi" "${EFI_DUET_GIT_DIR}/Shell/EDK2_X64/Shell_Full.efi"

echo

rm -rf "${EFI_DUET_GIT_DIR}/Linux_Source/C" || true
cp -r "${EDK2_C_SOURCE_DIR}" "${EFI_DUET_GIT_DIR}/Linux_Source/C"

echo

rm "${EFI_DUET_GIT_DIR}/Win_Bin"/{BootSectImage,GenBootSector}.exe || true
cp "${EDK2_DIR}/BaseTools/Bin/Win32"/{BootSectImage,GenBootSector}.exe "${EFI_DUET_GIT_DIR}/Win_Bin/"

echo

cd "${EFI_DUET_GIT_DIR}/"
git add *
git status
git commit -a -m "$(date +%d-%b-%Y)" || true

echo

cd "${MIGLE_BOOTDUET_DIR}/"
make clean

echo
echo "EFI_DUET_GIT done"
echo

echo
echo "Tiano_DUET_memdisk_compiled_GIT"
echo

rm "${MEMDISK_COMPILED_DIR}/Tiano_EDK2_DUET_X64.img" || true
cp "${EDK2_BUILD_OUTER_DIR}/floppy.img" "${MEMDISK_COMPILED_DIR}/Tiano_EDK2_DUET_X64.img"

echo

cd "${MEMDISK_COMPILED_DIR}/"
git add *
git status
git commit -a -m "$(date +%d-%b-%Y)" || true

echo
echo "Tiano_DUET_memdisk_compiled_GIT done"
echo

echo
echo "Tiano_DUET_memdisk_GIT"
echo

rm -rf "${MEMDISK_DIR}/Linux_Source/C" || true
cp -r "${EDK2_C_SOURCE_DIR}" "${MEMDISK_DIR}/Linux_Source/C"

echo

rm "${MEMDISK_DIR}/Windows"/{BootSectImage,GenBootSector}.exe || true
cp "${EDK2_DIR}/BaseTools/Bin/Win32"/{BootSectImage,GenBootSector}.exe "${MEMDISK_DIR}/Windows/"

echo

rm "${MEMDISK_DIR}/bootsect.com.unmod" || true
cp "${EDK2_DUET_BOOTSECT_BIN_DIR}/bootsect.com" "${MEMDISK_DIR}/bootsect.com.unmod"

rm "${MEMDISK_DIR}/Efildr" || true
cp "${EDK2_BUILD_DIR}/FV/Efildr" "${MEMDISK_DIR}/Efildr"

echo

cd "${MEMDISK_DIR}/"
git add *
git status
git commit -a -m "$(date +%d-%b-%Y)" || true

echo
echo "Tiano_DUET_memdisk_GIT done"
echo

unset WD
unset EDK2_DIR
unset EDK2_BUILD_TOOLS_DIR
unset EDK2_C_SOURCE_DIR
unset EDK2_DUET_BOOTSECT_BIN_DIR
unset EDK2_BUILD_DIR
unset COMPILED_DIR
unset EFI_DUET_GIT_DIR
unset MEMDISK_COMPILED_DIR
unset MEMDISK_DIR
unset MIGLE_BOOTDUET_DIR

set +x +e

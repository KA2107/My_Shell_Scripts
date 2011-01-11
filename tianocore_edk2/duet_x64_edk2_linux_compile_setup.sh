#!/bin/sh

set -x -e

WD=${PWD}
EDK2_DIR=${WD}/edk2_GIT
EFISYS=/boot/

echo

_PYTHON_=$(which python)
sudo rm ${_PYTHON_}
sudo ln -s $(which python2) ${_PYTHON_}
unset _PYTHON_

echo

rm -rf ${EDK2_DIR}/BaseTools || true
rm -rf ${EDK2_DIR}/Build/DuetPkgX64 || true
rm -rf ${EDK2_DIR}/Conf || true

echo

cd ${EDK2_DIR}/
git reset --hard

echo

cd ${EDK2_DIR}/
# patch -Np1 -i ${WD}/EDK2_DuetPkg_Use_VS2008x86_Toolchain.patch || true
# patch -Np1 -i ${WD}/EDK2_DuetPkg_Efivars_Use_MdeModulePkg_Universal_Variable_EmuRuntimeDxe.patch
# patch -Np1 -i ${WD}/EDK2_DuetPkg_Efivars_Use_MdeModulePkg_Universal_Variable_EmuRuntimeDxe_old.patch
git checkout keshav_pr

echo

# sed -i 's|#define EFI_PAGE_BASE_OFFSET_IN_LDR 0x70000|#define EFI_PAGE_BASE_OFFSET_IN_LDR 0x72000|' ${EDK2_DIR}/BaseTools/Source/C/GenPage/GenPage.c

cd ${EDK2_DIR}/DuetPkg
${EDK2_DIR}/DuetPkg/build64.sh

echo

cd ${EDK2_DIR}/
git reset --hard

echo

_PYTHON_=$(which python)
sudo rm ${_PYTHON_}
sudo ln -s $(which python3) ${_PYTHON_}
unset _PYTHON_

echo

sudo rm ${EFISYS}/memdisk_syslinux || true
sudo cp /usr/lib/syslinux/memdisk ${EFISYS}/memdisk_syslinux

echo

sudo rm ${EFISYS}/Tiano_EDK2_DUET_X64.img || true
sudo cp ${EDK2_DIR}/Build/DuetPkgX64/floppy.img ${EFISYS}/Tiano_EDK2_DUET_X64.img

echo

unset WD
unset EDK2_DIR
unset EFISYS

set +x +e

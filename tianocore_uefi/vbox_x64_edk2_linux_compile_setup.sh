#!/bin/sh

set -x -e

WD="${PWD}/"
EDK2_DIR="${WD}/edk2_GIT"
EDK2_BUILD_TOOLS_DIR="${WD}/buildtools-BaseTools_GIT"

export EDK_TOOLS_PATH="${EDK2_DIR}/BaseTools"

echo

_PYTHON_="$(which python)"
sudo rm "${_PYTHON_}"
sudo ln -s "$(which python2)" "${_PYTHON_}"
unset _PYTHON_

echo

rm -r "${EDK2_DIR}/BaseTools" || true
rm -r "${EDK2_DIR}/Build/StdLib" || true
rm -r "${EDK2_DIR}/Conf" || true

echo

cd "${EDK2_DIR}/"
git reset --hard

echo

cd "${EDK2_DIR}/"
git checkout keshav_pr

echo

rm -r "${EDK2_DIR}/BaseTools" || true
cp -r "${EDK2_BUILD_TOOLS_DIR}" "${EDK2_DIR}/BaseTools"

echo

sed -i 's|-Werror||g' "${EDK2_DIR}/BaseTools/Source/C/Makefiles"/*
sed -i 's|-Werror||g' "${EDK2_DIR}/BaseTools/Conf/tools_def.template"
sed -i 's|--64||g' "${EDK2_DIR}/BaseTools/Conf/tools_def.template"

echo

cd "${EDK2_DIR}/"
source "${EDK2_DIR}/edksetup.sh" BaseTools

echo

cd "${EDK2_DIR}/"
make -C "${EDK2_DIR}/BaseTools"

echo

sed -i 's|TARGET_ARCH           = IA32|TARGET_ARCH           = X64|g' "${EDK2_DIR}/Conf/target.txt"
sed -i 's|ACTIVE_PLATFORM       = Nt32Pkg/Nt32Pkg.dsc|ACTIVE_PLATFORM       = DuetPkg/DuetPkgX64.dsc|g' "${EDK2_DIR}/Conf/target.txt"

build -p "${EDK2_DIR}/DuetPkg/DuetPkgX64.dsc" -m "${EDK2_DIR}/VBoxPkg/VBoxFsDxe/VBoxIso9660.inf" -a X64 -b RELEASE -t GCC45

echo

rm -r "${EDK2_DIR}/BaseTools" || true
echo

cd "${EDK2_DIR}/"
git reset --hard

echo

_PYTHON_="$(which python)"
sudo rm "${_PYTHON_}"
sudo ln -s "$(which python3)" "${_PYTHON_}"
unset _PYTHON_

echo

unset WD
unset EDK2_DIR
unset EDK2_BUILD_TOOLS_DIR
unset EDK_TOOLS_PATH

set +x +e

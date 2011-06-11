#!/bin/sh

set -x -e

WD="${PWD}"
EDK2_DIR="${WD}/edk2_GIT"
EDK2_BUILD_TOOLS_DIR="${WD}/buildtools-BaseTools_GIT"

echo

_PYTHON_="$(which python)"
sudo rm "${_PYTHON_}"
sudo ln -s "$(which python2)" "${_PYTHON_}"
unset _PYTHON_

echo

rm -rf "${EDK2_DIR}/BaseTools" || true
rm -rf "${EDK2_DIR}/Build/OvmfX64" || true
rm -rf "${EDK2_DIR}/Conf" || true

echo

cd "${EDK2_DIR}/"
git reset --hard

echo

cd "${EDK2_DIR}/"
git checkout keshav_pr

echo

rm -rf "${EDK2_DIR}/BaseTools" || true
cp -r "${EDK2_BUILD_TOOLS_DIR}" "${EDK2_DIR}/BaseTools"

echo

sed -i 's|-Werror||g' "${EDK2_DIR}/BaseTools/Source/C/Makefiles"/*
sed -i 's|-Werror||g' "${EDK2_DIR}/BaseTools/Conf/tools_def.template"
sed -i 's|--64||g' "${EDK2_DIR}/BaseTools/Conf/tools_def.template"

echo

cd "${EDK2_DIR}/OvmfPkg"
"${EDK2_DIR}/OvmfPkg/build.sh" -a X64 -b DEBUG -t GCC45

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

set +x +e

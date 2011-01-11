#!/bin/sh

set -x -e

WD=${PWD}
EDK2_DIR=${WD}/edk2_GIT

echo

_PYTHON_=$(which python)
sudo rm ${_PYTHON_}
sudo ln -s $(which python2) ${_PYTHON_}
unset _PYTHON_

echo

rm -rf ${EDK2_DIR}/BaseTools || true
rm -rf ${EDK2_DIR}/Build/OvmfPkg || true
rm -rf ${EDK2_DIR}/Conf || true

echo

cd ${EDK2_DIR}/
git reset --hard

echo

cd ${EDK2_DIR}/

echo

cd ${EDK2_DIR}/OvmfPkg
${EDK2_DIR}/OvmfPkg/build.sh -a X64 -b DEBUG -t GCC45

echo

cd ${EDK2_DIR}/
git reset --hard

echo

_PYTHON_=$(which python)
sudo rm ${_PYTHON_}
sudo ln -s $(which python3) ${_PYTHON_}
unset _PYTHON_

echo

unset WD
unset EDK2_DIR

set +x +e

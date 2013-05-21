#!/usr/bin/env bash

__WD="${__SOURCE_CODES_PART__}/Source_Codes/Operating_Systems/Linux"
_WD="${__WD}/Linux_Kernel_Mainline_GIT/"

_KERNEL_VER_ACTUAL="3.10-rc1"
_KERNEL_VER_PATH="3.10.0-1-mainline"

_KERNEL_CONFIG_OPTIONS="CONFIG_EFIVAR_FS=m"
_KERNEL_SUBDIR="fs/efivarfs"
_KERNEL_MODULE_FILENAME="efivarfs"

echo

set -x -e

echo

cd "${_WD}/"

echo

git reset --hard

echo

git clean -f

echo

git_update.sh

echo

git checkout "v${_KERNEL_VER_ACTUAL}"

echo

install -D -m0644 "/usr/lib/modules/${_KERNEL_VER_PATH}/build/Module.symvers" "${_WD}/Module.symvers"

zcat /proc/config.gz > "${_WD}/.config"
# install -D -m0644 "/usr/src/${_KERNEL_VER_PATH}/.config" "${_WD}/.config"

echo

# make xconfig

echo

yes "" | make config > /dev/null

echo

make modules_prepare

echo

make -C "${_WD}/" ${_KERNEL_CONFIG_OPTIONS} SUBDIRS="${_KERNEL_SUBDIR}" modules

echo

sudo rm -f "/usr/lib/modules/${_KERNEL_VER_PATH}/kernel/${_KERNEL_SUBDIR}/${_KERNEL_MODULE_FILENAME}.ko" || true
sudo rm -f "/usr/lib/modules/${_KERNEL_VER_PATH}/kernel/${_KERNEL_SUBDIR}/${_KERNEL_MODULE_FILENAME}.ko.gz" || true

echo

gzip "${_WD}/${_KERNEL_SUBDIR}/${_KERNEL_MODULE_FILENAME}.ko"

sudo install -D -m0644 "${_WD}/${_KERNEL_SUBDIR}/${_KERNEL_MODULE_FILENAME}.ko.gz" "/usr/lib/modules/${_KERNEL_VER_PATH}/kernel/${_KERNEL_SUBDIR}/${_KERNEL_MODULE_FILENAME}.ko.gz"

echo

git clean -f

echo

# rm -f "${_WD}/${_KERNEL_SUBDIR}/Module.symvers"
# rm -f "${_WD}/Module.symvers"
# rm -f "${_WD}/.config"

echo

git reset --hard

echo

git checkout master

echo

sudo depmod -Ae

echo

sudo depmod ${_KERNEL_VER_PATH}

echo

if [[ "$(uname -r)" == "${_KERNEL_VER_PATH}" ]]; then
	sudo modprobe ${_KERNEL_MODULE_FILENAME}
fi

echo

set +x +e

echo

#!/bin/bash

__WD="/media/Source_Codes/Source_Codes/Operating_Systems/Linux"
_WD="${__WD}/Linux_Kernel_Mainline_GIT/"

echo

set -x -e

echo

cd "${_WD}/"

echo

git reset --hard

echo

make clean

echo

git checkout "v3.2-rc7"

echo

install -D -m0644 "/lib/modules/3.2.0-1-mainline/build/Module.symvers" "${_WD}/Module.symvers"
install -D -m0644 "/usr/src/linux-3.2.0-1-mainline/.config" "${_WD}/.config"

echo

# make xconfig

echo

echo

make modules_prepare

echo

make -C "${_WD}/" CONFIG_IWLWIFI="m" CONFIG_IWLWIFI_DEBUG="y" CONFIG_IWLWIFI_DEVICE_TRACING="n" SUBDIRS="drivers/net/wireless/iwlwifi" modules

echo

# xz "${_WD}/drivers/net/wireless/iwlwifi/iwlwifi.ko"
gzip "${_WD}/drivers/net/wireless/iwlwifi/iwlwifi.ko"

sudo install -D -m0644 "${_WD}/drivers/net/wireless/iwlwifi/iwlwifi.ko.gz" "/lib/modules/3.2.0-1-mainline/kernel/drivers/net/wireless/iwlwifi/iwlwifi.ko.gz"

echo

make clean

echo

git reset --hard

echo

git checkout master

echo

# sudo kmod-depmod -Ae
sudo depmod -Ae

echo

# sudo kmod-modprobe iwlwifi
sudo modprobe iwlwifi

echo

set +x +e

echo

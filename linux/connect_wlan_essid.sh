#!/bin/sh

echo

set -x -e

ESSID=${1}
ENCRYPTION_TYPE=${2}
PASSPHRASE=${3}

echo

sudo ip link set wlan0 down || true
# sudo ifconfig wlan0 down || true

echo

sudo ip link set wlan0 down || true
# sudo ifconfig wlan0 down || true

echo

sudo ip link set wlan0 up
# sudo ifconfig wlan0 up

echo

sudo iwconfig

echo

sudo iwlist scan

echo

sudo iwconfig wlan0 essid "${ESSID}"

echo

sudo iwconfig | grep -i ESSID

echo

sudo dhclient -4 wlan0
# sudo dhcpcd wlan0

echo

set +x +e

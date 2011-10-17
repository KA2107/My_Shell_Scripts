#!/bin/bash

echo

set -x -e

_ESSID="${1}"
_ENCRYPTION_TYPE="${2}"
_PASSPHRASE="${3}"

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

sudo iwconfig wlan0 essid "${_ESSID}"

echo

sudo iwconfig | grep -i ESSID

echo

sudo dhclient -4 wlan0
# sudo dhcpcd wlan0

echo

set +x +e

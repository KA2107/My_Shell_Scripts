#!/bin/sh

echo

ESSID=${1}

set +x +e

sudo ip link set wlan0 down || true
# sudo ifconfig wlan0 down || true
echo

sudo ip link set wlan0 down || true
# sudo ifconfig wlan0 down || true
echo

sudo ip link set wlan0 up
# sudo ifconfig wlan0 up
echo

sudo iwconfig wlan0 essid "${ESSID}"
echo

sudo iwconfig | grep -i ESSID
echo

sudo dhclient -4 wlan0
# sudo dhcpcd wlan0
echo

echo $?

set +x +e

exit 0

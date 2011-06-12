#!/bin/sh

set -x

sudo /etc/rc.d/gogocd start

echo

# sudo /etc/NetworkManager/dispatcher.d/001-resolv.conf-head_and_tail

echo

sudo cat /etc/resolv.conf

echo

set +x

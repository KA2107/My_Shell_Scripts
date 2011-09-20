#!/bin/bash

echo
echo "Usage: ${0} [PATTERN] [PACKAGE]"
echo

_pattern="${1}"
_package="${2}"

[ "${_pattern}" == '' ] && exit 1
[ "${_package}" == '' ] && exit 2

# set -x -e

echo

sudo grep --color=auto -n -i "${_pattern}" $(pacman -Ql "${_package}" | sed "s|${_package} ||g")

echo

# set +x +e

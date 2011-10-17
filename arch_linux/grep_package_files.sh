#!/bin/bash

echo
echo "Usage: ${0} [PATTERN] [PACKAGE]"
echo

_pattern="${1}"
_package="${2}"

if [[ "${_pattern}" == '' ]]
then
	exit 1
fi

if [[ "${_package}" == '' ]]
then
	exit 2
fi

# set -x -e

echo

sudo grep --color=auto -n -i "${_pattern}" $(pacman -Ql "${_package}" | sed "s|${_package} ||g")

echo

# set +x +e

#!/bin/bash

# set -x -e

_pattern="${1}"
_package="${2}"

echo

sudo grep --color=auto -n -i "${_pattern}" $(pacman -Ql "${_package}" | sed "s|${_package} ||g")

echo

# set +x +e

#!/usr/bin/env bash

_package="${1}"
_libname="${2}"

echo

set -x

for _check in $(pacman -Ql ${_package} | sed "s|${_package} ||g" | grep '\.so') ; do
    echo && ldd "${_check}" | grep -i "${_libname}"
done

echo

set +x

echo

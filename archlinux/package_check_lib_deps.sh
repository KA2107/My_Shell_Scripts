#!/usr/bin/env bash

package="${1}"
libname="${2}"

echo

set -x

for check in $(pacman -Ql ${package} | sed "s|${package} ||g" | grep '\.so') ; do
    echo && ldd "${check}" | grep -i "${libname}"
done

echo

set +x

echo

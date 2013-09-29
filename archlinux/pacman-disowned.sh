#!/usr/bin/env bash

## Taken from https://wiki.archlinux.org/index.php/Pacman_Tips#Identify_files_not_owned_by_any_package

tmp="${TMPDIR-/tmp}/pacman-disowned-${UID}-$$"
db="${tmp}/db"
fs="${tmp}/fs"

mkdir "${tmp}"
trap 'rm -rf "${tmp}"' EXIT

pacman -Qlq | sort -u > "$db"

for _DIR_ in boot etc opt usr var ; do
    find "/${_DIR_}" ! -name lost+found \( -type d -printf '%p/\n' -o -print \) | sort > "${fs}_${_DIR_}"
    comm -23 "${fs}_${_DIR_}" "${db}" > "${PWD}/${_DIR_}_non-db.txt"
    chmod 0644 "${PWD}/${_DIR_}_non-db.txt"
done

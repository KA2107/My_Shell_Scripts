#!/usr/bin/env bash

if [[ -z "${1}" ]]; then
	echo
	echo "Option 1 : Falconindy"
	echo "Option 2 : Setconf"
	echo
	exit 0
fi

_OPTION="${1}"

## https://wiki.archlinux.org/index.php/Makepkg#Replace_checksums_in_PKGBUILD_automatically

if [[ "${_OPTION}" == "1" ]]; then
	
	## Option 1
	
	## Script by Falconindy
	## https://bbs.archlinux.org/viewtopic.php?id=131666
	
	awk -v newsums="$(makepkg -g)" '
BEGIN {
  if (!newsums) exit 1
}

/^[[:blank:]]*(md|sha)[[:digit:]]+sums=/,/\)[[:blank:]]*$/ {
  if (!i) print newsums; i++
  next
}

1
' "${PWD}/PKGBUILD" > "${PWD}/PKGBUILD.new" && mv "${PWD}"/PKGBUILD{.new,}
	
fi

if [[ "${_OPTION}" == "2" ]]; then
	
	## Option 2
	
	setconf "${PWD}/PKGBUILD" $(makepkg -g 2>/dev/null | pee "head -1 | cut -d= -f1" "cut -d= -f2") ')'
	
fi

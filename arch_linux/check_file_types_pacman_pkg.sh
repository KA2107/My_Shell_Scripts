#!/bin/bash

_pkgname="${1}"

_RUN()
{
	_file_=''
	sudo pacman -Ql "${_pkgname}" | while read -r _file_
	do
		echo
		
		_file_="$(echo "${_file_}" | sed "s|${_pkgname} ||g")"
		
		echo
		
		file "${_file_}"
		
		echo
		
		unset _file_
	done
}

set -x -e

_RUN

set +x +e

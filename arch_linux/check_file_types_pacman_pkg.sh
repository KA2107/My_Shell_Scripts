#!/bin/bash

pkgname="${1}"

RUN()
{
	_file_=""
	sudo pacman -Ql "${pkgname}" | while read -r _file_
	do
		echo
		
		_file_=$(echo "${_file_}" | sed "s|${pkgname} ||g")
		
		echo
		
		file "${_file_}"
		
		echo
		
		unset _file_
	done
}

set -x -e

RUN

set +x +e

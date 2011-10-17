#!/bin/bash

_RUN()
{
	_name=''
	ls --all -1 | while read -r _name
	do
		if [[ ! -d "${PWD}/${_name}" ]]
		then
			if [[ "$(file "${_name}" | grep 'POSIX shell script')" ]]
			then
				sed 's/\$\([a-zA-Z0-9_]\+\)/${\1}/g' -i "${PWD}/${_name}"
			fi
			
		elif [[ -d "${PWD}/${_name}" ]] && [[ "${_name}" != '.' ]] && [[ "${_name}" != '..' ]]
		then
			pushd "${_name}" > /dev/null
			RUN
			popd > /dev/null
		fi
	done
}

_RUN

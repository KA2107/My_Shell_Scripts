#!/bin/bash

_RUN()
{
	
	_name=''
	
	ls --all -1 | while read -r _name
	do
		echo
		
		if [[ ! -d "${PWD}/${_name}" ]] && [[ "${_name}" != '.' ]] && [[ "${_name}" != '..' ]]
		then
			
			echo
			
			echo "Current Directory : ${PWD}"
			
			echo
			
			touch --no-create "${_name}"
			
			echo
			
		fi
		
		echo
		
		if [[ -d "${PWD}/${_name}" ]] && [[ "${_name}" != '.' ]] && [[ "${_name}" != '..' ]] && [[ ! "$(file "${PWD}/${_name}" | grep 'symbolic link to')" ]]
		then
			pushd "${_name}" > /dev/null
			_RUN
			popd > /dev/null
		fi
		
		echo
		
	done
	
}

set -x -e

echo

_RUN

echo
echo

_RUN

echo
echo

_RUN

echo
echo

_RUN

echo

set +x +e

echo

unset _name

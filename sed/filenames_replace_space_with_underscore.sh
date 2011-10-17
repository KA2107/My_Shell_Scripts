#!/bin/bash

_RUN()
{
	
	_old_filename=''
	_new_filename=''
	
	ls --all -1 | while read -r _old_filename
	do
		echo
		
		if [[ "${_old_filename}" != '.' ]] && [[ "${_old_filename}" != '..' ]]
		then
			
			echo
			
			echo "Current Directory : ${PWD}"
			
			echo
			
			_new_filename="$(echo "${_old_filename}" | sed 's#[[:space:]]#_#g')"
			_new_filename="$(echo "${_new_filename}" | sed 's#:#_#g')"
			_new_filename="$(echo "${_new_filename}" | sed 's#\|#_#g')"
			_new_filename="$(echo "${_new_filename}" | sed 's#\-#_#g')"
			
			echo
			
			if [[ -e "${PWD}/${_old_filename}" ]] && [[ ! -e "${PWD}/${_new_filename}" ]]
			then
				echo
				mv "${PWD}/${_old_filename}" "${PWD}/${_new_filename}"
			fi
			
			echo
			
		fi
		
		echo
		
		if [[ -d "${PWD}/${_old_filename}" ]] && [[ "${_old_filename}" != '.' ]] && [[ "${_old_filename}" != '..' ]] && [[ ! "$(file "${PWD}/${_old_filename}" | grep 'symbolic link to')" ]]
		then
			pushd "${_old_filename}" > /dev/null
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

unset _old_filename
unset _new_filename

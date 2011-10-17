#!/bin/bash

set -e

_RUN()
{
	_repo=''
	ls --all -1 | while read -r _repo
	do
		if [[ -d "${PWD}/${_repo}" ]] && [[ "${_repo}" == '.git' ]]
		then
			echo
			echo "${PWD}"
			echo
			
			git gc --aggressive
			echo
		elif [[ -d "${PWD}/${_repo}" ]] && [[ "${_repo}" != '.' ]] && [[ "${_repo}" != '..' ]] && [[ ! "$(file "${PWD}/${_repo}" | grep 'symbolic link to')" ]]
		then
			pushd "${_repo}" > /dev/null
			_RUN
			popd > /dev/null
		fi
	done
}

_RUN

set +e

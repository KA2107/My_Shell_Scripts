#!/bin/bash

_RUN()
{
	_source_repo=''
	ls --all -1 | while read -r _source_repo
	do
		if [[ -d "${PWD}/${_source_repo}" ]] && [[ "${_source_repo}" != "." ]] && [[ "${_source_repo}" != ".." ]]
		then
			echo
			rm -rf "${PWD}/${_source_repo}-build" || true
			rm -rf "${PWD}/${_source_repo}_build" || true
			rm -rf "${PWD}/${_source_repo}-1" || true
			rm -rf "${PWD}/${_source_repo}_1" || true
			rm -rf "${PWD}/pkg" || true
			rm "${PWD}/${_source_repo}/${_source_repo}"*.tar.* || true
			echo
		fi
		
		if [[ -d "${PWD}/${_source_repo}" ]] && [[ "${_source_repo}" != "." ]] && [[ "${_source_repo}" != ".." ]]
		then
			pushd "${_source_repo}" > /dev/null
			_RUN
			popd > /dev/null
		fi
		
	done
}

set -x -e

_RUN

set +x +e

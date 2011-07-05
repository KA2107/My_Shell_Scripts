#!/bin/bash

set -e

RUN()
{
	repo=""
	ls --all -1 | while read -r repo
	do
		if [ -d "${PWD}/${repo}" ] && [ "${repo}" == ".git" ]
		then
			echo
			echo "${PWD}"
			echo
			
			git gc --aggressive
			echo
		elif [ -d "${PWD}/${repo}" ] && [ "${repo}" != "." ] && [ "${repo}" != ".." ] && [ ! "$(file "${PWD}/${repo}" | grep 'symbolic link to')" ]
		then
			pushd "${repo}" > /dev/null
			RUN
			popd > /dev/null
		fi
	done
}

RUN

set +e

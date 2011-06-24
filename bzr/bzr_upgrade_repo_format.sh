#!/bin/bash

run()
{
	repo=""
	ls --all -1 | while read -r repo
	do
		if [ -d "${PWD}/${repo}" ] && [ "${repo}" == ".bzr" ]
		then
			if [ $(echo "${PWD}" | grep '.git/bzr/repo') ] || [ $(echo "${PWD}" | grep '.git/bzr/repo/master') ]
			then
				true
			else
				echo
				echo "BZR - ${PWD}"
				echo
				
				bzr upgrade --default
				echo
			fi
		elif [ -d "${PWD}/${repo}" ] && [ "${repo}" != "." ] && [ "${repo}" != ".." ] && [ ! "$(file "${PWD}/${repo}" | grep 'symbolic link to')" ]
		then
			pushd "${repo}" > /dev/null
			run
			popd > /dev/null
		fi
	done
}

run

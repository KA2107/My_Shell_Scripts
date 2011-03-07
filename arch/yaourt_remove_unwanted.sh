#!/bin/sh

run()
{
	repo=""
	ls --all -1 | while read -r repo
	do
		if [ -d "${PWD}/${repo}" ] && [ "${repo}" != "." ] && [ "${repo}" != ".." ]
		then
			echo
			rm -rf "${PWD}/${repo}-build"
			rm -rf "${PWD}/${repo}_build"
			rm -rf "${PWD}/${repo}-1"
			rm -rf "${PWD}/${repo}_1"
			rm -rf "${PWD}/pkg"
			rm ${PWD}/${repo}/${repo}*.tar.*
			echo
		fi
		
		if [ -d "${PWD}/${repo}" ] && [ "${repo}" != "." ] && [ "${repo}" != ".." ]
		then
			pushd "${repo}" > /dev/null
			run
			popd > /dev/null
		fi
		
	done
}

set -x

run

set +x

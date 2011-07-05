#!/bin/bash

RUN()
{
	source_repo=""
	ls --all -1 | while read -r source_repo
	do
		if [ -d "${PWD}/${source_repo}" ] && [ "${source_repo}" != "." ] && [ "${source_repo}" != ".." ]
		then
			echo
			rm -rf "${PWD}/${source_repo}-build" || true
			rm -rf "${PWD}/${source_repo}_build" || true
			rm -rf "${PWD}/${source_repo}-1" || true
			rm -rf "${PWD}/${source_repo}_1" || true
			rm -rf "${PWD}/pkg" || true
			rm "${PWD}/${source_repo}/${source_repo}"*.tar.* || true
			echo
		fi
		
		if [ -d "${PWD}/${source_repo}" ] && [ "${source_repo}" != "." ] && [ "${source_repo}" != ".." ]
		then
			pushd "${source_repo}" > /dev/null
			run
			popd > /dev/null
		fi
		
	done
}

set -x -e

RUN

set +x +e

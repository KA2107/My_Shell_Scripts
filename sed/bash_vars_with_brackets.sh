#!/bin/bash

RUN()
{
	name=""
	ls --all -1 | while read -r name
	do
		if [ ! -d "${PWD}/${name}" ]
		then
			[[ $(file "${name}" | grep 'POSIX shell script') ]] && sed -i 's/\$\([a-zA-Z0-9_]\+\)/${\1}/g' "${PWD}/${name}"
			
		elif [ -d "${PWD}/${name}" ] && [ "${name}" != "." ] && [ "${name}" != ".." ]
		then
			pushd "${name}" > /dev/null
			RUN
			popd > /dev/null
		fi
	done
}

RUN

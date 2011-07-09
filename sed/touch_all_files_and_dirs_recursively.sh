#!/bin/bash

RUN()
{
	
	name=""
	
	ls --all -1 | while read -r name
	do
		echo
		
		if [ ! -d "${PWD}/${name}" ] && [ "${name}" != "." ] && [ "${name}" != ".." ]
		then
			
			echo
			
			echo "Current Directory : ${PWD}"
			
			echo
			
			touch --no-create "${name}"
			
			echo
			
		fi
		
		echo
		
		if [ -d "${PWD}/${name}" ] && [ "${name}" != "." ] && [ "${name}" != ".." ] && [ ! "$(file "${PWD}/${name}" | grep 'symbolic link to')" ]
		then
			pushd "${name}" > /dev/null
			RUN
			popd > /dev/null
		fi
		
		echo
		
	done
	
}

set -x -e

echo

RUN

echo
echo

RUN

echo
echo

RUN

echo
echo

RUN

echo

set +x +e

echo

unset name

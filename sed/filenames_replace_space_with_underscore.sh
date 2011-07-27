#!/bin/bash

RUN()
{
	
	old_filename=""
	new_filename=""
	
	ls --all -1 | while read -r old_filename
	do
		echo
		
		if [ "${old_filename}" != "." ] && [ "${old_filename}" != ".." ]
		then
			
			echo
			
			echo "Current Directory : ${PWD}"
			
			echo
			
			new_filename="$(echo "${old_filename}" | sed 's#[[:space:]]#_#g')"
			new_filename="$(echo "${new_filename}" | sed 's#:#_#g')"
			new_filename="$(echo "${new_filename}" | sed 's#\|#_#g')"
			new_filename="$(echo "${new_filename}" | sed 's#\-#_#g')"
			
			echo
			
			if [ -e "${PWD}/${old_filename}" ] && [ ! -e "${PWD}/${new_filename}" ]
			then
				echo
				mv "${PWD}/${old_filename}" "${PWD}/${new_filename}"
			fi
			
			echo
			
		fi
		
		echo
		
		if [ -d "${PWD}/${old_filename}" ] && [ "${old_filename}" != "." ] && [ "${old_filename}" != ".." ] && [ ! "$(file "${PWD}/${old_filename}" | grep 'symbolic link to')" ]
		then
			pushd "${old_filename}" > /dev/null
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

unset old_filename
unset new_filename

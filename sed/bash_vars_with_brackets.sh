run()
{
	name=""
	ls --all -1 | while read -r name
	do
		if [ ! -d "${PWD}/${name}" ]
		then
			if [ $(file ${name} | sed "s|${name}: ||g" | grep 'POSIX shell script text executable') ]
			then
				sed -i 's/\$\([a-zA-Z0-9_]\+\)/${\1}/g' "${PWD}/${name}"
			fi
		fi
		
	elif [ -d "${PWD}/${name}" ] && [ "${name}" != "." ] && [ "${name}" != ".." ]
		then
			pushd "${name}" > /dev/null
			run
			popd > /dev/null
		fi
	done
}

run

#!/bin/bash

MILD_FETCH=('Linux_Kernel_Mainline_GIT')

RUN()
{
	repo=""
	ls --all -1 | while read -r repo
	do
		if [ -d "${PWD}/${repo}" ] && [ "${repo}" == ".git" ]
		then
			if [ -d "${PWD}/.git/svn" ]
			then
				echo
				echo "GIT SVN - ${PWD}"
				echo
				
				git reset --hard
				echo
				
				git svn rebase --verbose
				echo
				
				git checkout master
				echo
				
				git merge remotes/git-svn
				echo
				
				git reset --hard
				echo
				
			elif [ -d "${PWD}/.git/bzr" ]
			then
				echo
				echo "GIT BZR - ${PWD}"
				echo
				
				git reset --hard
				echo
				
				git bzr sync bzr/master
				echo
				
				git checkout master
				echo
				
				git merge bzr/master
				echo
				
				git reset --hard
				echo
				
			else
				if [ -d "${PWD}/.git/refs/remotes" ]
				then
					echo
					echo "GIT - ${PWD}"
					echo
					
					git reset --hard
					echo
					
					for check in ${MILD_FETCH[@]}
					do
						if [ "$(basename "${PWD}")" = "${check}" ]
						then
							# git fetch --depth=1
							echo
						else
							# git fetch
							echo
						fi
					echo
					done
					
					git fetch
					echo
					
					git checkout master
					echo
					
					git merge remotes/origin/master
					echo
					
					git reset --hard
					echo
				fi
			fi
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

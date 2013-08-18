#!/usr/bin/env bash

_MILD_FETCH=('Linux_Kernel_Mainline_GIT')
_NO_MASTER_BRANCH=('ntfs-3g_ntfsprogs_GIT')

_LAUNCHPAD_USER="the-ridikulus-rat"

_RUN()
{
	_repo=''
	ls --all -1 | while read -r _repo
	do
		if [[ -d "${PWD}/${_repo}" ]] && [[ "${_repo}" == '.git' ]]; then
			if [[ -d "${PWD}/.git/hgcheckout/__NONE__" ]] && [[ -d "${PWD}/.git/hgremote/__NONE__" ]]; then
				echo
				echo
				echo "GIT HG OLD - ${PWD}"
				echo
				
				git reset --hard
				echo
				
				git hg pull
				echo
				
				git checkout --quiet master
				echo
				
				git pull --rebase hg master
				echo
				
				git reset --hard
				echo
				
				echo
			elif [[ -d "${PWD}/.git/bzr/__NONE__" ]]; then
				echo
				echo
				echo "GIT BZR OLD - ${PWD}"
				echo
				
				git reset --hard
				echo
				
				bzr lp-login "${_LAUNCHPAD_USER}"
				echo
				
				git bzr sync bzr/master
				echo
				
				git checkout --quiet master
				echo
				
				git merge bzr/master
				echo
				
				git reset --hard
				echo
				
				echo
			elif [[ -d "${PWD}/.git/svn" ]]; then
				echo
				echo
				echo "GIT SVN - ${PWD}"
				echo
				
				git reset --hard
				echo
				
				git svn rebase --verbose
				echo
				
				git checkout --quiet master
				echo
				
				git pull --rebase git-svn || git pull --rebase origin svn/trunk 
				echo
				
				git reset --hard
				echo
				
				echo
			else
				if [[ -d "${PWD}/.git/refs/remotes" ]]; then
					
					if [[ -d "${PWD}/.git/bzr" ]]; then
						echo
						echo
						echo "GIT BZR - ${PWD}"
						echo
					else
						echo
						echo
						echo "GIT - ${PWD}"
						echo
					fi
					
					#################
					
					_GIT_REMOTE_BRANCH="$(git branch -a | grep '  remotes/origin/HEAD -> origin/' | sed 's:  remotes/origin/HEAD -> origin/::g')"
					
					if [[ "${_GIT_REMOTE_BRANCH}" == '' ]]; then
						_GIT_REMOTE_BRANCH='master'
					fi
					
					#################
					
					cat << NOEXEC > /dev/null
					
					for check in ${_MILD_FETCH[@]}
					do
						if [[ "$(basename "${PWD}")" == "${check}" ]]; then
							# git fetch --depth=1
							echo
						else
							# git fetch
							echo
						fi
					echo
					done
					
NOEXEC
					git fetch
					echo
					
					#################
					
					git reset --hard
					echo
					
					git checkout --quiet "${_GIT_REMOTE_BRANCH}"
					echo
					
					git pull --rebase origin "${_GIT_REMOTE_BRANCH}"
					echo
					
					git reset --hard
					echo
					
					#################
					
					git checkout --quiet "remotes/origin/${_GIT_REMOTE_BRANCH}"
					echo
					
					# git branch -D "${_GIT_REMOTE_BRANCH}"
					echo
					
					# git branch --track "${_GIT_REMOTE_BRANCH}" "remotes/origin/${_GIT_REMOTE_BRANCH}"
					echo
					
					#################
					
					git checkout --quiet "${_GIT_REMOTE_BRANCH}"
					echo
					
					#################
					
					echo
				fi
			fi
			echo
		elif [[ -d "${PWD}/${_repo}" ]] && [[ "${_repo}" != '.' ]] && [[ "${_repo}" != '..' ]] && [[ "${_repo}" != 'lost+found' ]] && [[ ! "$(file "${PWD}/${_repo}" | grep 'symbolic link to')" ]]; then
			pushd "${_repo}" > /dev/null
			_RUN
			popd > /dev/null
		fi
	done
}

bzr lp-login "${_LAUNCHPAD_USER}"

_RUN

unset _MILD_FETCH
unset _NO_MASTER_BRANCH
unset _LAUNCHPAD_USER

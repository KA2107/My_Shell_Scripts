#!/bin/bash

_REPO_UPDATE()
{
	_DIR=''
	ls --all -1 | while read -r _DIR
	do
		if [[ -d "${PWD}/${_DIR}" ]] && [[ "${_DIR}" == '.git' ]] && [[ ! -d "${PWD}/../.git" ]]; then
			echo
			echo "GIT pull - ${PWD}"
			echo
			git pull --ff-only --tags --force
			# echo
			# git gc --aggressive
			echo
		elif [[ -d "${PWD}/${_DIR}" ]] && [[ "${_DIR}" == '.svn' ]] && [[ ! -d "${PWD}/../.svn" ]] && [[ ! $(git rev-parse --git-dir 2> /dev/null) ]]; then
			echo
			echo "SVN update - ${PWD}"
			echo
			svn update
			echo
		elif [[ -d "${PWD}/${_DIR}" ]] && [[ "${_DIR}" == 'CVS' ]] && [[ ! -d "${PWD}/../CVS" ]] && [[ ! $(git rev-parse --git-dir 2> /dev/null) ]]; then
			echo
			echo "CVS update - ${PWD}"
			echo
			cvs -q update -P -R -d
			echo
		elif [[ -d "${PWD}/${_DIR}" ]] && [[ "${_DIR}" != '.' ]] && [[ "${_DIR}" != '..' ]] && [[ "${_DIR}" != '.git' ]] && [[ "${_DIR}" != '.svn' ]] && [[ "${_DIR}" != 'CVS' ]]; then
			pushd "${_DIR}" > /dev/null
			_REPO_UPDATE
			popd > /dev/null
		fi
	done
}

_REPO_UPDATE

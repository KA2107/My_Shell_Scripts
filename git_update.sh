#!/bin/sh

run()
{
  repo=""
  ls --all -1 | while read -r repo
  do
    if [ -d "${PWD}/${repo}" ] && [ "${repo}" == ".git" ]
    then
        if [ -d "${PWD}/.git/svn" ]
        then
            true
        else
            if [ -d "${PWD}/.git/refs/remotes" ]
            then
                echo
                echo "${PWD}"
                echo
            
                git fetch
                echo
            
                if [ "${PWD}" == "/media/Data_2/Source_Codes/Operating_Systems/Linux_Kernel/Linux_Kernel_GIT" ]
                then
                    git checkout remotes/origin/master
                else
                    git checkout origin/master
                fi
            fi            
            echo
        fi
            
    elif [ -d "${PWD}/${repo}" ] && [ "${repo}" != "." ] && [ "${repo}" != ".." ]
    then
        pushd "${repo}" > /dev/null
        run
        popd > /dev/null
    fi
  done
}

run

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
            echo
            echo "GIT SVN - ${PWD}"
            echo
            
            git svn rebase --verbose
            echo
            
            git checkout remotes/git-svn
            echo
            
            git reset --hard
            echo
            
        elif [ -d "${PWD}/.git/bzr" ]
        then
            echo
            echo "GIT BZR- ${PWD}"
            echo
            
            git bzr sync
            echo
            
            git checkout bzr/master
            echo
            
            git reset --hard
            echo
            
        else
            if [ -d "${PWD}/.git/refs/remotes" ]
            then
                echo
                echo "${PWD}"
                echo
            
                git fetch
                echo
            
                git checkout remotes/origin/master
                echo
                
                git reset --hard
                echo
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

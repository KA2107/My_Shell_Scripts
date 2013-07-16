#!/usr/bin/env bash

export NEW_AUTHOR_NAME="${1}"
export NEW_AUTHOR_EMAIL="${2}"

export NEW_COMMITTER_NAME="${NEW_AUTHOR_NAME}"
export NEW_COMMITTER_EMAIL="${NEW_AUTHOR_EMAIL}"

export OLD_AUTHOR_NAME="${3}"
export OLD_AUTHOR_EMAIL="${4}"

export OLD_COMMITTER_NAME="${OLD_AUTHOR_NAME}"
export OLD_COMMITTER_EMAIL="${OLD_AUTHOR_EMAIL}"


## Taken from http://help.github.com/change-author-info/
## Ideas from http://stackoverflow.com/questions/750172/how-do-i-change-the-author-of-a-commit-in-git

git filter-branch -f --env-filter '

an="${GIT_AUTHOR_NAME}"
am="${GIT_AUTHOR_EMAIL}"
cn="${GIT_COMMITTER_NAME}"
cm="${GIT_COMMITTER_EMAIL}"

if [[ "${GIT_COMMITTER_EMAIL}" == "${OLD_COMMITTER_EMAIL}" ]]; then
    cn="${NEW_COMMITTER_NAME}"
    cm="${NEW_COMMITTER_EMAIL}"
fi

if [[ "${GIT_AUTHOR_EMAIL}" == "${OLD_AUTHOR_EMAIL}" ]]; then
    an="${NEW_AUTHOR_NAME}"
    am="${NEW_AUTHOR_EMAIL}"
fi

export GIT_AUTHOR_NAME="${an}"
export GIT_AUTHOR_EMAIL="${am}"
export GIT_COMMITTER_NAME="${cn}"
export GIT_COMMITTER_EMAIL="${cm}"

'

unset NEW_AUTHOR_NAME
unset NEW_AUTHOR_EMAIL

unset NEW_COMMITTER_NAME
unset NEW_COMMITTER_EMAIL

unset OLD_AUTHOR_NAME
unset OLD_AUTHOR_EMAIL

unset OLD_COMMITTER_NAME
unset OLD_COMMITTER_EMAIL

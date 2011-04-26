#!/bin/sh

set -x

sudo pacman -Sy
echo

"${PWD}/unofficial_repos_pacman_git.sh"
echo

sudo pacman -Su
echo

yaourt -Su
echo

sudo pacman -Sc
echo

set +x

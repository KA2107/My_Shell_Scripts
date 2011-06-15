#!/bin/bash

set -x -e

sudo pacman -Sy
echo

"${PWD}/unofficial_repos_pacman_git.sh"
echo

sudo pacman -Su --noconfirm
echo

yaourt -Su --noconfirm
echo

sudo pacman -Sc --noconfirm
echo

set +x +e

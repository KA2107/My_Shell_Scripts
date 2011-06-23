#!/bin/bash

set -x -e

yaourt -Sy

echo

"${PWD}/unofficial_repos_pacman_git.sh"

echo

sudo pacman -Su --noconfirm

echo

yaourt -Sua --noconfirm

echo

sudo pacman -Sc --noconfirm

echo

set +x +e

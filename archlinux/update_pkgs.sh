#!/usr/bin/env bash

set -x -e

yaourt -Sy

echo

unofficial_repos_pacman_git.sh

echo

sudo pacman -Su --noconfirm

echo

yaourt -Sua --noconfirm

echo

sudo pacman -Sc --noconfirm

echo

sudo abs $(find /var/abs -type d | sed 's|/var/abs||g; s|^/||g;' | grep '/')

echo

set +x +e

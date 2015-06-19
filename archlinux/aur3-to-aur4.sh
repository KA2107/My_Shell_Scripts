#!/usr/bin/env bash

## Based on https://github.com/JonnyJD/PKGBUILDs/blob/master/_bin/aur4_import.sh

_DIR_="${PWD}"
_PKGS_="efibootmgr-git efitools-git efivar-git gnu-efi-libs-fedora-git gnu-efi-libs-git gptfdisk-git grub-git gummiboot-git ovmf-svn pesign-git refind-efi-git shim-efi-git syslinux-git uefi-shell-svn"

for _PKG_ in ${_PKGS_} ; do
	mkdir -p "${_DIR_}/${_PKG_}/"
	cd "${_DIR_}/${_PKG_}/"
	echo
	
	git init
	echo
	
	git remote add origin ssh://aur@aur4.archlinux.org/${_PKG_}.git
	echo
	
	git remote add backup git@bitbucket.org:keshav21/${_PKG_}-aur-pkgbuild.git
	echo
	
	git pull backup master:master
	echo
	
	git filter-branch -f --tree-filter "mksrcinfo" -- master || exit -1
	echo
	
	git push backup --force --all
	echo
	
	git gc --aggressive
	echo
	
	git push origin --force master:master
	echo
done

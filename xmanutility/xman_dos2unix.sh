#!/bin/bash

# This file xman_dos2unix is part of xman utility.
#
# Copyright (c) 2007 Chung Shin Yee <cshinyee@gmail.com>
#
#       http://myxman.org
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
# USA.
#
# The GNU General Public License is contained in the file COPYING.
#

# Date  : 22 April 2007

# Syntax: xman_dos2unix <FILE> ...

# Description: Apply dos2unix to all given text files recursively.

# Given: Files or folders.
# Output: All text files including those in subfolders (recursively) will have all CRLF being removed.

## This script uses http://waterlan.home.xs4all.nl/dos2unix.html dos2unix implementation.

FILE="file"
GREP="grep -i"
DOS2UNIX="dos2unix -ascii --keepdate --safe --skip-symlink --oldfile"

#########################################################################################

explore()
{
	local file=""
	ls -1 | while read -r file
	do
		# Recursively explore if we found a directory.
		if [ -d "${file}" ] ; then
			echo "Entering ${file}"
			pushd "${file}" > /dev/null
			explore
			echo "Leaving ${file}"
			popd > /dev/null
		# Process it if we found a text file.
		elif [ "`${FILE} \"${file}\" | ${GREP} text`" != "" ] ; then
			# echo "Processing: ${file}"
			${DOS2UNIX} "${file}"
		fi
	done
} # end of explore()

# Start of main program
if [ -z "${1}" ] ; then
	echo "usage: xman_dos2unix <FILE> ..."
	exit 0
fi

dir="${1}"

if [ ! -e "${dir}" ] ; then
	echo "ERROR: Path ${dir} does not exist"
	exit 0
fi

OLDIFS=${IFS}
IFS=$'\n'
for file in $@ ; do
	# FIXME: I should have put these into a subroutine to reduce code duplications in explore().
	# However, I'm not familiar with subroutines in BASH yet.
	IFS=${OLDIFS}
	if [ -d "${file}" ] ; then
		echo "Entering ${file}"
		pushd "${file}" > /dev/null
		explore
		echo "Leaving ${file}"
		popd
	elif [ "`${FILE} \"${file}\" | ${GREP} text`" != "" ] ; then
		${DOS2UNIX} "${file}"
	fi
	IFS=$'\n'
done
IFS=${OLDIFS}

exit 0

#eof


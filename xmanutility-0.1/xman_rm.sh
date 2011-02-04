# This file xman_rm is part of xman utility.
#
# Copyright (c) 2006-2007 Chung Shin Yee <cshinyee@gmail.com>
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

#!/bin/bash

# Date  : 18 Feb 2006

# Syntax: xman_rm FILE ...

# Given: A list of files/directories.
# Output: The list of files/directories are appended with date/time, and moved to "$DIR_DELETED" directory in their current directories. An index is created in "$RECYCLE_BIN/$DFILE_LIST" for each files/directories.

# Known problems/limitations:
# 1. Deleting a mount point will move the files into parent folder, which is resided in another filesystem. 
# 2. If the filename appended with date/time exists in $DIR_DELETED, we will skip the deletion. 

RECYCLE_BIN="$HOME/.recycle_bin"
DIR_DELETED=".deleted"
DFILE_LIST="deleted_file.txt"

TIMEFORMAT="+%Y.%m%d.%H%S.%N"

newline=$'\n'

#########################################################################################

if [ -z "$1" ] ; then
	echo "usage: xman_rm FILE ..."
	exit 0
fi

# "Delete" each file in a loop.
until [ -z "$1" ]
do
	# File to be deleted.
	f="$1"

	if [ ! -e "$f" ] ; then
		echo "Cannot find: $f"
		shift
		continue
	fi

	d=`dirname "$f"`
	# $d doesnt start with "/"? 
	if [ "${d:0:1}" != "/" ] ; then
		# $d is a relative path.
		# Prepend $d with current directory to obtain the absolute path.
		d="$PWD/$d"
	fi
	b=`basename "$f"`
	if [ "$d" == "$b" ] ; then
		# Our deletion algorithm moves deleting files into parent's folder. 
		# Thus, files to be deleted must have parent folders.
		echo "Cannot delete file with no parent directory: $f"
		shift 
		continue
	fi

	echo "Deleting: $f"
	mkdir -p "$d/$DIR_DELETED"
	ext=`date $TIMEFORMAT`
	dfname="$b.$ext"
	if [ ! -e "$d/$DIR_DELETED/$dfname" ] ; then
		mv "$f" "$d/$DIR_DELETED/$dfname"
	else	
		echo "$dfname exists in recycle bin. Skip deletion."
		shift
		continue
	fi

	# Mark the deletion in repository.
	mkdir -p "$RECYCLE_BIN"
	echo "DEL$newline$d/$b$newline$d/$DIR_DELETED/$dfname" >> "$RECYCLE_BIN/$DFILE_LIST"

	shift
done

exit 0

#eof


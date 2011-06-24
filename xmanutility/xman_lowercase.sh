# This file xman_lowercase is part of xman utility.
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

# Date  : 06 Aug 2006

# Syntax: xman_lowercase FILE ...

# Given: A list of files/directories.
# Output: The list of files/directories are converted to lowercase.

# Known problems/limitations:

newline=$'\n'
FILTER="xman_tolower_filter"
FILTERNAME="Lowercase"

#########################################################################################

if [ -z "$1" ] ; then
	echo "usage: xman_lowercase FILE ..."
	exit 0
fi

# Apply filter $FILTER to each of the files.
until [ -z "$1" ]
do
	# Current file
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
		echo "No parent directory?: $f"
		shift 
		continue
	fi

	dfname=`echo $b | eval $FILTER`
	if [ ! -e "$d/$dfname" ] ; then
		echo "$FILTERNAME: $f"
		mv "$f" "$d/$dfname"
	elif [ "$b" == "$dfname" ] ; then
		shift
		continue
	else	
		echo "$dfname exists. Skip."
		shift
		continue
	fi

	shift
done

exit 0

#eof


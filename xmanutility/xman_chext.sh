# This file xman_chext is part of xman utility.
#
# Copyright (c) 2006-2007 Chung Shin Yee <cshinyee@gmail.com>
#
#	http://myxman.org
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

# Date  : 08 Aug 2006

# Syntax: xman_chext <FILE> <EXT>

# Given: A file.
# Output: Change the file extension to EXT.

# Known problems/limitations:

newline=$'\n'

#########################################################################################

if [ -z "$2" ] ; then
	echo "usage: xman_chext <FILE> <EXT>"
	echo "Change the file extension of FILE to EXT."
	exit 0
fi

f="$1"		# Given file
ext="$2"	# New extension

if [ ! -e "$f" ] ; then
	echo "Cannot find: $f"
	exit 1
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
	echo "dir name = file name?: $f"
	exit 1
fi

dfname="${b%.*}.$ext"	# File name with new extension.
if [ ! -e "$d/$dfname" ] ; then
	mv "$f" "$d/$dfname"
else	
	echo "$dfname exists. Skip."
fi

exit 0

#eof


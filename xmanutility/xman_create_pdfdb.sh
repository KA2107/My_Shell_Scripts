# This file xman_create_pdfdb is part of xman utility.
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

# Date  : 22 Feb 2006

# Syntax: xman_create_pdfdb <PATH>

# Description: Create a PDF database.

# Given: A starting path.
# Output: A PDF database.

# Known problems/limitations:
# 1. $RANDOM might not be thread-safe. There might be a conflict in generating same RAND number. We should check whether the $TMP_DIR already exists.

AWK="gawk"
DIFF="diff --brief"
SHA1SUM="sha1sum"
PDFTOTEXT="pdftotext"
PDFIMAGES="pdfimages -j"
LOWERCASE_FILTER="xman_tolower_filter"

PDFDB_DIR="$HOME/.pdfdb"
TMP_DIR_PREFIX="/tmp/createpdfdb"

TIMEFORMAT="+%Y.%m%d.%H%S.%N"

MIN_IMAGE_SIZE=1000
IMAGE_NAME_PREFIX="image-"

# Options
OPTION_SUPPRESS_WARNING=1

#########################################################################################

explore()
{
	local file=""
	local csum=""
	local image=""
	local image_size=0
	local image_csum=""
	local ext=""
	local count=0
	local TMP_DIR=""
	ls -1 | while read -r file 
	do
		# Recursively explore if we found a directory.
		if [ -d "$file" ] ; then
			echo "Entering $file"
			pushd "$file" > /dev/null
			explore
			echo "Leaving $file"
			popd > /dev/null
		# Process it if we found a pdf file.
		# We may use "file" command to check if this a pdf file.
		# Currently we merely check the file extension (case insensitive).
		elif [ "`echo ${file##*.} | $LOWERCASE_FILTER`" == "pdf" ] ; then
			csum=`$SHA1SUM "$PWD/$file" | $AWK '{ print $1 }'`
			if [ -e "$PDFDB_DIR/$csum" ] ; then
				if [ "$OPTION_SUPPRESS_WARNING" -eq 0 ] ; then
					echo "WARNING: $file exists in database."
				fi
			else
				echo "Processing: $file"
				mkdir -p "$PDFDB_DIR/$csum"
				TMP_DIR="$TMP_DIR_PREFIX/$USER.$RANDOM"
				mkdir -p "$TMP_DIR/$csum"
				cp -f "$file" "$TMP_DIR/$csum/"
				$PDFTOTEXT "$TMP_DIR/$csum/$file" "$TMP_DIR/$csum/${file%.*}.txt" > /dev/null
				mv -f "$TMP_DIR/$csum/${file%.*}.txt" "$PDFDB_DIR/$csum/"
				rm -f "$TMP_DIR/$csum/$file"
				# $PDFIMAGES "$file" "$TMP_DIR/$csum/image"
				# Only retain images with at least minimum size.
				# Use .tmp as temporary folder for renamed images.
				mkdir -p "$TMP_DIR/$csum/.tmp"
				ls -1 "$TMP_DIR/$csum" | while read -r image
				do
					image_size=`ls -l "$TMP_DIR/$csum/$image" \
							| $AWK '{ print $5}'`
					if [ "$image_size" -lt "$MIN_IMAGE_SIZE" ] ; then
						rm -f "$TMP_DIR/$csum/$image"
					else
						image_csum=`$SHA1SUM "$TMP_DIR/$csum/$image" \
								| $AWK '{print $1 }'`
						ext="${image##*.}"
						mv -f "$TMP_DIR/$csum/$image" "$TMP_DIR/$csum/.tmp/$image_csum.$ext"
					fi					
				done
				let count=1
				ls "$TMP_DIR/$csum/.tmp" | while read -r image
				do
					ext="${image##*.}"
					mv "$TMP_DIR/$csum/.tmp/$image" "$PDFDB_DIR/$csum/$IMAGE_NAME_PREFIX$count.$ext"
					let count+=1
				done
				rm -rf "$TMP_DIR"
			fi
		else
			if [ "$OPTION_SUPPRESS_WARNING" -eq 0 ] ; then
				echo "WARNING: Ignore $file"
			fi
		fi
	done
} # end of explore()

# Start of main program
if [ -z "$1" ] ; then
	echo "usage: xman_create_pdfdb <PATH>"
	exit 0
fi

dir="$1"

if [ ! -e "$dir" ] ; then
	echo "ERROR: Path $dir does not exist"
	exit 0
fi

if [ ! -d "$dir" ] ; then
	echo "ERROR: $dir is not a directory"
	exit 0
fi

pushd "$dir" > /dev/null
explore
popd > /dev/null

exit 0

#eof


# This file xman_tr_filter is part of xman utility.
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

# Date  : 05 Sep 2006

# Syntax: xman_tr_filter

# Description: Read from stdin, apply translation from character set 1 to character set 2.

# Given: Text in stdin.
# Output: Translated text with characters in set 1 replaced by corresponding characters in set 2.

# Example: 
# Translate all space in the stdin to _.
# > xman_tr_filter ' ' '_' 
# 
# Translate a->A, b->B, ...
# > xman_tr_filter 'a-z' 'A-Z'

#################################################################

tr "$1" "$2"

exit 0

# eof


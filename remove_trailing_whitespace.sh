#!/bin/bash

# strip trailing white spaces.
for ext in "sh"
do
  find . -type f -name "*.${ext}" -exec sed -i "s/[[:space:]]*$//" {} \;
done

# ensures all files end with a newline.
for ext in "sh"
do
  find . -type f -name "*.${ext}" -print | xargs printf "e %s\nw\n" | ed -s;
done

#!/bin/bash
	
strip_whitespace() {
	
echo
echo "Strip trailing white spaces from ${PWD}/${fil}"
echo

## strip trailing white spaces.
sed -i "s/[[:space:]]*$//" ${PWD}/${fil}

## ensures all files end with a newline.
find . -type f -name "${fil}" -print | xargs printf "e %s\nw\n" | ed -s;

echo

}


run() {

fil=""
ls -1 | while read -r fil
do
  if [ `file -b --mime-type ${PWD}/${fil}` == "text/*" ]
  then
      strip_whitespace
  elif [ -d "${PWD}/${fil}" ]
  then
      pushd "${fil}" > /dev/null
	  run			
	  popd > /dev/null
  fi       
done
	
}

set -x -e

run

set +x +e

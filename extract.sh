#!/bin/bash
#
# File:         extract.sh
# Created:      030918
# Description:  description for extract.sh
#

### FUNCTIONS ###

### ENV ###

code="$PWD/extract.awk"

### MAIN ###

 for i in $(for x in *; do  [ -d "$x" ] && echo $x; done)
 do
  for pkg in $i/*;
  do
   apkbuild="$pkg/APKBUILD"
   name="${apkbuild%/APKBUILD}"
   name=$(basename $name)

   [ -f "$apkbuild" ] && awk -vname=$name -f "$code" $apkbuild
  done
 done

### EOF ###

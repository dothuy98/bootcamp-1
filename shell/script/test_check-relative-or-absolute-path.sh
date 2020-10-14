#!/bin/bash

runLs=`ls`
files=(${runLs})
runPwd=`pwd`
testParameters=("${files[0]}" "$runPwd" "xxx" "../" "~" "-" "aa bb")
for parameter in "${testParameters[@]}"
do
  echo "引数 : $parameter >"
  sh check-relative-or-absolute-path.sh $parameter
done
 

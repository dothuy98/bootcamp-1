#!/bin/bash

run_ls=`ls`
files=(${run_ls})
run_pwd=`pwd`
test_parameters=("${files[0]}" "$run_pwd" "xxx" "../" "~" "-" "aa bb")
for parameter in "${test_parameters[@]}"
do
  echo "引数 : $parameter >"
  sh check-relative-or-absolute-path.sh $parameter
done
 

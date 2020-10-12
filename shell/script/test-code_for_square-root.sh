#!/bin/bash

# ./square-root.shのテストコードを使った検証を行う。
testCodeNumber=(1 101 3 0 -1)
testCodeDecimalPlace=(3 3 10 2 2)
lastNumber=`expr ${#testCodeNumber[@]} - 1`
# lastNumber=${#testCodeNumber[*]}でも同じことを表す。
for index in `seq 0 $lastNumber`
do
  value1=${testCodeNumber[$index]}
  value2=${testCodeDecimalPlace[$index]}
   echo "引数が $value1 , $value2 >" 
  eval ./square-root.sh $value1 $value2
done

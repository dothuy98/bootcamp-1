#!/bin/bash

if [ $# == 0 ]; then
  echo "引数はありません。"
else
  echo "引数の数は$#個"
  for index in `seq 1 $#`
  do
    # ${!value1} : 変数の変数を指定。${value[${value1}]}と同じ意味
    echo "\$${index} : ${!index}"
  done
fi

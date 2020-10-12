#!/bin/bash

# 1から10を表示する
echo "for-loop"
for number in `seq 1 10`
do
  echo $number
done

# 別のループを使用する
echo "while-loop"
while read line
# 指定のファイル(test.txt)の内容を出力する
do
  echo "$line"
done < test.txt

#!/bin/bash

# カレントディレクトリのの中で最もファイルサイズが大きいものを出力

output=`ls -S`
# スペース区切りで配列へ
array=(${output// /})
path=`pwd`

echo "current directory is $path"
echo "the most biggest file size is ${array[0]}"


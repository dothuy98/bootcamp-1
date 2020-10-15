#!/bin/bash

. ./check-parameter.sh
# 引数での例外処理でいつも同じコードを書いてしまうため関数化し、別ファイルにまとめた。
check_parameter $#

if [[ $1 =~ [^0-9] ]]; then
  echo "引数に正の整数値を半角で指定してください"
  exit 1
fi

# ディレクトリの初期化
# outというディレクトリがある場合に実行。
if cd out > /dev/null 2>&1; then
  cd ../
  rm -rf out
fi

mkdir out

if [ $1 == 0 ]; then
  echo "引数が0の場合はディレクトリに変化はありません"
  exit 0
fi

for directory_index in `seq 1 $1`
do
  mkdir out/dir-$directory_index
  for file_index in `seq 1 $directory_index`
   do
      touch out/dir-$directory_index/file-$file_index
   done
done


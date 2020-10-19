#!/bin/bash

# ファイルの保存と自動解凍

if [ $# == 0 ]; then
  echo "引数を指定してください"
elif [ $# -gt 1 ]; then
  echo "最初の引数のみを使用します。"
fi

curl -OL $1 
if [ $? == 1 ]; then
  echo "引数に問題があります。うまくダウンロードできませんでした"
  exit 1
fi

file_name=`echo "$1" | sed -e "s/.*\/\(.*\)/\1/"`
echo $file_name
file_size=`wc -c < $file_name`
echo "${file_name}のサイズは${file_size}byteです"

echo "${file_name}" | grep -q "tar.gz" && tar -zxvf $file_name && exit 0
echo "${file_name}" | grep -q "tar.bz2" && tar -jxvf $file_name && exit 0
echo "${file_name}" | grep -q "tar.xz" && tar -Jxvf $file_name && exit 0
echo "${file_name}" | grep -q "tar.gz" && tar -zxvf $file_name && exit 0
echo "${file_name}" | grep -q "tar" && tar -xvf $file_name && exit 0
echo "${file_name}" | grep -q "zip" && unzip $file_name && exit 0

echo "ファイルは解凍していません"

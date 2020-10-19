#!/bin/bash

# 特定の文字で始まる行を全てコメントアウトする
# 引数を指定しない場合はコメントアウトされた行の#を取り除く

if [ $# == 0 ]; then
  echo "引数を指定してください。"
  exit 1
elif [ $# == 1 ]; then
  sed -i -e "s/^# *\(.*\)/\1/g" $1
  echo "$0のコメントアウトをすべて外しました。"
  exit 0
fi

if [ `ls | grep $1 -q` ] && [ `ls | grep $2 -q` ]; then
  echo "どちらの引数もファイル名と一致するため、第一引数をファイル名とします。"
  file=$1
  string=$2
else
  ls | grep $1 -q && file=$1 && string=$2
  ls | grep $2 -q && file=$2 && string=$1
fi

echo $string
echo $file
sed -i -e "s/^$string/# $string/g" $file

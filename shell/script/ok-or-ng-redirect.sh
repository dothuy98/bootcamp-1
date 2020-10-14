#!/bin/bash

if [ $# == 0 ]; then
  # >&2にスペースを間に挟まないこと
  echo "引数がない" >&2
  exit 1
fi

if ! [ $1 == "ok" -o $1 == "ng" ]; then
  echo "引数がok,ng以外のものです。" >&2
  exit 1
fi
 
if [ $# -gt 1 ]; then
  echo "warning : 引数が２つ以上の場合は１番目の引数を使用します。" >&2
fi

now=`date '+%y/%m/%d %H:%M:%S'`
if [ $1 == "ng" ]; then
  echo "ngを認識しました"
  echo "$now : $0に引数で\"ng\"が渡されました" 2> ng.txt >&2 
  # more simple error message
  # こちらの方では標準出力をエラーにするという処理がないためわかりやすい。
  cd xxxx 2>> ng.txt
  exit 1
fi

echo "okを認識しました"
echo "$now : $0に引数で\"ok\"が渡されました" 1> ok.txt

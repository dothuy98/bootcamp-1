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

now=`date '+%y/%m/%d %H:%M:%S'`
if [ $1 == "ok" ]; then
  echo "$now : $0に引数で\"ok\"が渡されました" 1> ok.txt
  echo "okを認識しました"
else
# ガード節でok、ng以外ははじいているため
  echo "$now : $0に引数で\"ng\"が渡されました" 1> ng.txt 2>&1
   echo "ngを認識しました"
fi


#!/bin/bash

# 標準入力 : プログラムが何も指定されていない場合に標準的に利用するデータ
# 引数はコマンドの後ろにつくもので、標準入力はデータのこと。

# < でリダイレクトし、正常に動けばそのコマンドは標準入力を受け取れるコマンド。
# rmやechoはなにも返さないため引数のみを受け付ける。cat、uniqは引数、標準入力どちらも受け付ける。

# キーボードの入力
echo "文字を入力してください。(enterで終了)"
# 変数に格納
read text
echo "入力文字 : $text"
# 入力文字が反映されてからfileの内容を出力するため。
sleep 2

# fileでの入力(echoで出力)
echo -e "\nfile_name : $0"
while read line
do
  echo $line
done < $0
# < でリダイレクトしている。
#

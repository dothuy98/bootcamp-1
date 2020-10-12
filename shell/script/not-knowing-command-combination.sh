#!/bin/bash

#ターミナルで使用したコマンドの回数を表示

# コマンドのみのファイルを作成
while read line
do
  # "コマンド 引数"という行からコマンドのみを抜き出す

  # ※(${line// / })でも配列に分割できる。
  
  # setコマンドは -- 以降をすべてvalueとするという意味のオプション
  # コマンドは空白を区切り文字とするため、配列にできる。
  set $line --
  # 位置パラメーターで取得できる。
  echo $1 >> only_command.txt
done < ~/.bash_history

# コマンドの使用回数取得
most=0
while read line
do
  count=`grep -c $line only_command.txt` 
  echo -e "$line\t$count" >> count_command.txt
done < only_command.txt
cat count_command.txt | sort -k 2 -rn | uniq 

rm only_command.txt count_command.txt

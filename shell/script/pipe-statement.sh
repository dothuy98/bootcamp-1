#!/bin/bash

# |(pipeline)は複数のコマンドを組み合わせて使うことができる。
# command1 | command2の場合はcommand1の標準出力がcommand2の標準入力として扱われる。
# 様々なコマンドを組み合わせ、複雑な処理を実現できるという利点がある。

# lastでログイン履歴を出力 | awkでほしい情報だけを出力 | sortする際に邪魔になる()を削除 | ログイしていた時間を数値で降順にソート
last | awk '{print $1,$6,$7,$11}' | tr -d "()" | sort -k 4 -nr

# tee : ファイルへのリダイレクトとパイプを同時に行う。中間結果を保持するような使い方ができる。
cat ~/.bash_history | awk '{print $1}' | tee after_awk.txt | grep -c "git"

# xargs : 標準入力をコマンドライン引数に変換する。
echo "use xasrgs" | xargs echo

# なにも出力されない。
echo "not use xargs" | echo

# 標準出力を1行ごとに引数としてxargsで指定したコマンドを繰り返し実行する
ls -1 | xargs -L 1 cat

# 引数の上限を指定し、出力の数だけ繰り返し実行する。
ls | xargs -n1 cat

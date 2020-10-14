#!/bin/bash

# 環境変数は親プロセスに反映されない。sh file_name(./file_name)では子プロセスでの実行になり、親プロセスであるターミナルで参照できるようにならない
# source ./<file_name>を行うと現在のシェルで実行されるのでこちらで実行する。

# 環境変数の設定。
export NAME="Fushimi Akira"

count=printenv | grep "Fushimi Akira" -c
if [ $count -gt > 0 ]; then
  echo "環境変数に設定できている"
else
  echo "設定したはずの環境変数が存在しない"
fi

# プロセスを切っても削除されない環境変数の設定方法
echo 'export MAIL="akira147369@outlook.jp"' >> ~/.bash_profile
# .bash_profileはログインすると自動で読み込まれる。

# 読み込まれて初めて実行される
source ~/.bash_profile

#!/bin/bash

if [ $# == 0 ]; then
  echo "引数がありません"
  exit 1
fi

if [ $# -gt 1 ]; then
  echo "warning : 引数の数が１より大きい場合は最初の引数を使用します。"
fi

if [[ $1 =~ ^/ ]]; then
  echo "絶対パスの形式です"
else
  echo "相対パスの形式です"
fi

# コマンド実行では子プロセスを新しく立ち上げるため前にいたディレクトリに移動する`cd -`が使えない
# cd: OLDPWD not setというエラーを起こさず、OLDPWDにパスをセットする
cd .

# evalで文字列をコマンドとして認識させないと"~"や"-"を実行可能な相対パスと識別しない
if eval cd $1 > /dev/null 2> /dev/null; then
      #  > /dev/null 2>&1 と同じ意味
  # 子プロセス内でcdが実行されるためターミナルのカレントディレクトリに変化はない。
  echo "有効なパスです"
else
  echo "そのパスにアクセスできないか、ファイル・ディレクトリが存在しません"
fi


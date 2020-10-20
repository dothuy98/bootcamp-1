#!/bin/bash

# source find.shで実行する。
# alias cdf='source ~/find.sh'で設定すると使いやすい。
# ワイルドカードでうろ覚えのファイルもディレクトリも検索可能。
# 該当のディレクトリにすぐに移動する。

#カレントディレクトリ上のディレクトリ・ファイルの場合。
cd $1 > /dev/null 2>&1
if [ $? == 0 ]; then
  exit 0
fi

ls | grep $1 > /dev/null 2>&1
if [ $? == 0 ]; then
  echo "このディレクトリ上のファイルです"
  exit 0
fi

# 日時を付け出力し、最も最近に更新したディレクトリに移動
paths=(`find ~ -name $1 -printf "%T+\t%p\n" | sort -r| xargs`)
echo "$((${#paths[@]} / 2))件ヒットし、"
find ~ -name $1 -printf "%p\n"
echo "の内、最も更新日時が近いディレクトリへ移動"
path=${paths[1]}
# もしファイルがヒットしていたら1つ前のディレクトに移動させるため
if [ -f $path ]; then
  path=`echo $path | sed -e "s/\(.*\)\/.*/\1/g"`
fi
cd $path

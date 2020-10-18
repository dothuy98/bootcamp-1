#!/bin/bash

# 特定のコマンド名を含むプロセスをまとめて削除する。
echo "まとめてkillしたいプロセスのコマンド名を入力してください。"
read command
ps -A o pid,comm | grep "$command"

# pidのみの配列を作成
pids=`ps -A o pid,comm | grep "$command" | sed -e 's/ *\([0-9]*\)[^0-9]*/\1/g'`
pids=($pids)
if [ ${#pids[@]} == 0 ]; then
  echo "1件もヒットしませんでした。終了します"
  exit 1
fi
echo "の ${#pids[@]} 件がヒットしました。 "  

echo "これらをkillしますか? [y/n] "
read answer
if [ $answer == "y" -o $answer == "yes" ]; then
  for pid in "${pids[@]}"
  do
    kill "$pid"
  done
  echo "killが完了しました。"
elif [ $answer == "n" -o $answer == "no" ]; then
  echo "killを中止しました"
fi

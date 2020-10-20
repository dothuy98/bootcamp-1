#!/bin/bash

# コマンドを指定してバックグラウンドで実行する。
# もう実行するとそのコマンドをkillする。

if [ $# == 0 ]; then
  echo "引数を指定してください"
  exit 1
elif [ $# -gt 2 ]; then
  echo "最初の引数を使用します"
fi

# 引数の最初が数字の時はPIDの認識しkillする。
if [[ $i =~ "^[0-9]" ]]; then
  kill $1 && echo "pid : $1 をkillしました。" || echo "該当のpidはありません"
  exit 0
fi

# オプション-kがあるかないかを確認
kill_option="false"
if [ "$1" == "-k" ]; then
  kill_option="true"
  command=$2  
elif [ "$2" == "-k" ]; then
  kill_option="true"
  command=$1
else
  command=$1
fi

if [ "$kill_option" == "false" ]; then
  echo "$command" | xargs nohup -- &
  exit 0
fi

# 区切り文字を変更
_IFS=$IFS
IFS=,
echo $$
commands_pids=(`pgrep -lf "${command}" | sed -e "/$$/d" | tr '\n' ','`)
echo "${commands_pids[@]}"
pids=(`pgrep -f "${1}" | sed -e "/$$/d" | tr '\n' ','`)
IFS=$_IFS
echo ${pids[0]}
count=${#commands_pids[@]}

last_index=$(($count -1))
echo "PID   command"
for index in `seq 0 $last_index`
do
  # echo "${commands_pids[$index]}" | grep $$
  if [[ "${commands_pids[$index]}" =~ $$ ]]; then
    continue
  fi
  echo "${commands_pids[$index]}をkillしますか? [y/n]"
  read answer
  if [ $answer == "y" ]; then
    kill "${pids[$index]}"
  fi
done

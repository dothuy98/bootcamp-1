#!/bin/bash

# 特定のユーザーのファイル変更を監視する。

if [ $# == 0 ]; then
  echo "引数を指定してください"
  exit 1
fi

interval="10"
user_name=$1
path="/home"

# .から始まる隠しディレクトリは含まない。
# .swpファイルは本来の編集済みファイルと被るため省く。
files=(`find $path -user $user_name -type f -printf "%T+\t%p\n" | grep -v "/\." | grep -v ".swp" | sort -nr | xargs`)
# indexが0の配列には更新日時が入っているため。
newest_updated_file=${files[1]}
echo -e "==> $newest_updated_file <==\n" > updated-file.txt
tail $newest_updated_file >> updated-file.txt

echo -e "==> $newest_updated_file <==\n"
tail -F updated-file.txt &

# crtl + C でこのスクリプトが終了したらtailプロセスをkill
trap "pgrep -n tail | xargs kill" Exit

while true
do
  sleep $interval
  # updated-file.txtはこのスクリプトのログのため省く
  new_files=(`find $path -user $user_name -type f -newer $newest_updated_file | grep -v "updated-file.txt" | grep -v ".swp" | grep -v "/\."| xargs `)
  if [ ${#new_files[@]} != 0 ]; then
  newest_updated_file=${new_files[0]}
    for new_file in "${new_files[@]}"
    do
     echo -e "\n==> $new_file <==\n" >> updated-file.txt
     tail $new_file >> updated-file.txt  
    done
  fi
done

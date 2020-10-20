#!/bin/bash

# シェルスクリプトを引数にし、スクリプト内でsourceによって呼び出されるすべてスクリプトに対して実行権限を付与する。
# -r を指定すると変更した実行権限を元に戻す

if [ $# == 0 -o $# -gt 2 ]; then
  echo "引数の数は1~2です"
  exit 1
fi

# redoのr
if [ "$1" == "-r" ]; then
  redo="true"
  file_name=$2
elif [ "$2" == "-r" ]; then
  redo="true"
  file_name=$1
else
  file_name=$1
fi

find . -type f -name "$file_name" > /dev/null 2>&1
if [ $? == 1 ]; then
  echo "引数に指定したファイル名が見つかりません"
  exit 1
fi

put_permissions=()
old_permissions=()
while read line
do
  # source で始まる行か
  script_name=`echo $line | grep -e "source" -e "\." | sed  -e "s/^[ \t]*source //" | sed -e "s/^[ \t]*\. //"`
  if [ "$script_name" != "" ]; then
    put_permissions+=($script_name)
    set -o pipefail
### ここから変更前の権限を保存する処理

    # ls -lで出力される権限のコードをchmodと同じ形式にする。
    permission=`ls -l $script_name | cut -d ' ' -f 1 | sed -e "y/rwx-/4210/" `
    if [ $? == 2 ]; then
      # ls で表示できないファイルの場合、エラーを発生させる
      echo "エラーが発生したため終了します"
      exit 1
    fi
    # ls -lの権限のコードは3文字で意味を為すため、区切り文字をスペースにして3文字ずつ出力しなおす(split)
    permission_array=(`echo $permission | sed -e "s/.\(...\)\(...\)\(...\)/\1 \2 \3/" | xargs`) 
    chmod_string=""
    for number in "${permission_array[@]}"
    do
      # 3文字ずつに分割した後、その3つ数字を足し合わせ、chmodで指定できるようにする。
      tmp_numbers=(`echo $number | fold -w 1 | xargs`)
      total=0
      # 配列の足し算
      for tmp_number in "${tmp_numbers[@]}"
      do
        total=$(( $total+$tmp_number ))
      done
      # chmodで使えるように足した数を連結させる。
      chmod_string+=$total
    done
    old_permissions+=($chmod_string)

### ここまで変更前の権限を保存する処理
      
    # 実行権限を付与
    chmod 700 $script_name
  fi
done < $file_name

if [ "$redo" != "true" ]; then
  exit 0
fi

# 保存した権限を付与し、元の権限に戻す
count=${#old_permissions[@]}
for ((index=0; index < $count; index++));
do
  echo "${old_permissions[$index]} ${put_permissions[$index]}"
  chmod "${old_permissions[$index]}" "${put_permissions[$index]}"
done


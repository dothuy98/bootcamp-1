#!/bin/bash

# 指定したグループを作成し、パスワードを付与する。2つ目の引数でパスが指定されていた場合、再帰的にグループを変更する
# ファイルを指定する場合は -p <file_name> にする

if [ $# == 0 ]; then
  echo "引数がない"
  exit 1
fi
if [ $# -gt 3 ]; then
  echo "引数は最高で3つまでです"
  exit 1
fi
if [ $# == 2 ]; then
  echo "ファイルパスを指定する際は-pを使用してください"
  exit 1
fi

if [ $# == 3 ]; then
  parameters=($@)
  for index in `seq 0 2`
  do
    if [ ${parameters[$index]} == "-p" ]; then
      if [ $index == 0 ]; then
        group_name=$3
        file_path=$2
      else
        group_name=$1
        file_path=$3
      fi
    fi
  done
else
  group_name=$1
fi
  
user_name=`whoami`
if [ $user_name != "root" ]; then
  echo "rootユーザーに変更する必要があります"
  if [ ! `su` ]; then
    echo "認証に失敗したため終了します"
    exit 1
  fi
  user_name=`whoami`
fi
  

groupadd $group_name
if [ $? == 1 ]; then
  echo "グループを作成できませんでした。"
  exit 1
fi

echo "作成したグループにパスワードを付与します？ [y/n]"
read answer
if [ $answer == "y" ]; then
  gpasswd $group_name
fi

echo $file_path
if [ -z "$file_path" ]; then
  exit 0
fi

# 再帰的にファイルのグループを変更する。

cd $file_path > /dev/null 2>&1
if [ $? == 1 ]; then
  echo "正しいファイルパスではないため終了します"
  exit 1
else
  cd - > /dev/null
fi

chown -R $user_name:$group_name $file_path

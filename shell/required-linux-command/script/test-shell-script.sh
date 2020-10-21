#!/bin/bash

# 引数て指定したshell scriptをテストするスクリプトを必修コマンドを組み合わせて作成しました。
# テストファイルについて：1行に1度テストを行い、複数の引数はスペース区切りで指定してください。

# 例外処理
if [ $# != 2 ]; then
  echo "引数を2つ指定してください"
  exit 1
fi

# 初期値
interval=1
if `echo "${1}" | grep -q -- "\.sh"`;  then
  shell_script=$1
  test_file=$2
elif `echo "${2}" | grep -q -- "\.sh"`; then
  shell_script=$2
  test_file=$1
else
  echo "シェルスクリプトを拡張子を含めて正しく指定してください。"
  exit 1
fi
  
script_path=`find . $shell_script`
if [ $? != 0 ]; then
  echo "引数に指定されたスクリプトが見つかりません"
  #exit 1
fi

# ログを出力し監視する
echo > top.txt
tail -F top.txt &
tail_pid=$!
{
while true
do  
  top -b | head -n 4 >> top.txt
  echo >> top.txt
  sleep $interval
done
} &
while_pid=$!
trap 'kill $tail_pid $while_pid' Exit

# テスト実行
ls test-output.txt > /dev/null 2>&1 rm test-output.txt
while read line
do
  echo "引数:$line" >> test-output.txt
  echo "$line" | xargs sh ${shell_script} >> test-output.txt
  if [ $? != 0 ]; then 
    echo "正常に終了しませんでした" >> test-output.txt
  fi
  # 改行出力
  echo >> test-output.txt
done < $test_file

cat test-output.txt



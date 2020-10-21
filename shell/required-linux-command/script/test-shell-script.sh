#!/bin/bash

# 引数て指定したshell scriptをテストするスクリプトを必修コマンドを組み合わせて作成しました。
# sh test-shell-script シェルスクリプト テストファイル [-p <number>]
# テストファイルについて：1行に1度テストを行い、複数の引数はスペース区切りで指定してください。
# -pでバックグラウンドで実行する個数を指定できます。

# 例外処理
if [ $# == 0 ]; then
  echo "引数を指定してください"
  echo "スレッドの指定は-p <number>でお願いします"
  echo "メモリー・スワップの状況を監視するインターバルの指定は-i <number>でお願いします"
  exit 1
fi
  
# 引数処理

# 初期値
interval=1
threads=3

count=$#
for ((index=1; index<=$count; index++))
do
  next_index=$(($index + 1))
  # -pオプションが存在した場合、次の引数を変数に格納
  echo "${!index}" | grep -q -- "-p" && threads=${!next_index} && index=$(($index + 1)) && continue
  echo "${!index}" | grep -q -- "-i" && interval=${!next_index} && index=$(($index + 1)) && continue
  echo "${!index}" | grep -q -- "\.sh" && shell_script="${!index}" && continue
  test_file="${!index}"
done

if [ -z $shell_script ]; then
  echo "シェルスクリプトを拡張子を含めて正しく指定してください。"
  exit 1
fi

echo "testfile : $test_file"
echo "shellscript : $shell_script"
echo "interval : $interval"
echo -e "threads : $threads\n"

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
index=1
end_file=`cat $test_file | wc -l`
while read line
do
  {
  echo "引数:$line" >> tmp$index.txt 2>&1
  echo "$line" | xargs sh ${shell_script} >> tmp$index.txt 2>&1
  if [ $? != 0 ]; then 
    echo "正常に終了しませんでした" >> tmp$index.txt
  fi
  # 改行出力
  echo >> tmp$index.txt
  } &
  pids+=($!)
  if [ $index == $threads -o $index == "$end_file" ]; then
    wait ${pids[@]}
    index=0
    pids=()
  fi
  index=$(($index+1))
# done < $test_file
done < test

# 分割ファイルを結合
# 初期化
ls output.txt > /dev/null 2>&1 && rm output.txt
for index in `seq 1 $threads`
do
  cat "tmp${index}.txt" >> output.txt
done

rm tmp*
echo "出力結果をoutput.txtに格納しました"
#exit 0

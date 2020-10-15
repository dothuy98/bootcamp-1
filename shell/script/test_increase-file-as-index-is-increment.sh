#!/bin/bash

test_parameters=("xxx" "3 4" 1 3 15 0 １０ 1.123 -1 3i i3 3^2)
for test_parameter in "${test_parameters[@]}"
do
  echo "引数 : $test_parameter > "
  sh increase-file-as-index-is-increment.sh $test_parameter
  if [ $? == 1 ]; then
    echo -e "引数に問題があると判断されました\n"
    continue
  fi
  # ファイルにリダイレクトするとlsは改行が区切り文字になってしまうため
  echo `ls out`
  # テストコードが引数が複数ある場合、テストされる側の処理と同様に1つの引数として認識させるため
  first_parameter=(${test_parameter})
  if [ ${first_parameter[0]} == 0 ]; then
    if [ -n "$(ls out)" ]; then
      echo "引数が0にもかかわらず、ディレクトリ・ファイルが存在します"
    fi
    echo -e "問題なし\n"
    continue
  fi

  # 引数の数だけディレクトリは作成されているか？
  count_directory=`ls out -1 | wc -l`
  if [ $count_directory != ${first_parameter[0]} ]; then
    echo "ディレクトリの個数が違う"
  fi
  echo "ディレクトリの個数は正しい。"
    
  # 乱数出力
  # $((RANDOM % 上限値 + 開始値))で設定できる
  directory_number=$((RANDOM % ${first_parameter[0]} + 1))
  count_file=`ls out/dir-$directory_number -1 | wc -l`
  if [ $count_file != $directory_number ]; then
    echo "ファイルの個数が違う"
  fi
  echo "dir-$directory_number内のファイル一覧"
  echo `ls out/dir-$directory_number`
  echo -e "ファイルの個数も正しい\n"
done

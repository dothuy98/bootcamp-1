#!/bin/bash

testParameters=("xxx" "3 4" 1 3 15 0 １０ 1.123 -1 3i i3 3^2)
for testParameter in "${testParameters[@]}"
do
  echo "引数 : $testParameter > "
  sh increase-file-as-index-is-increment.sh $testParameter
  if [ $? == 1 ]; then
    echo -e "引数に問題があると判断されました\n"
    continue
  fi
  # ファイルにリダイレクトするとlsは改行が区切り文字になってしまうため
  echo `ls out`
  # テストコードが引数が複数ある場合、テストされる側の処理と同様に1つの引数として認識させるため
  firstParameter=(${testParameter})
  if [ ${firstParameter[0]} == 0 ]; then
    if [ -n "$(ls out)" ]; then
      echo "引数が0にもかかわらず、ディレクトリ・ファイルが存在します"
    fi
    echo -e "問題なし\n"
    continue
  fi

  # 引数の数だけディレクトリは作成されているか？
  countDirectory=`ls out -1 | wc -l`
  if [ $countDirectory != ${firstParameter[0]} ]; then
    echo "ディレクトリの個数が違う"
  fi
  echo "ディレクトリの個数は正しい。"
    
  # 乱数出力
  # $((RANDOM % 上限値 + 開始値))で設定できる
  directoryNumber=$((RANDOM % ${firstParameter[0]} + 1))
  countFile=`ls out/dir$directoryNumber -1 | wc -l`
  if [ $countFile != $directoryNumber ]; then
    echo "ファイルの個数が違う"
  fi
  echo "dir$directoryNumber内のファイル一覧"
  echo `ls out/dir$directoryNumber`
  echo -e "ファイルの個数も正しい\n"
done

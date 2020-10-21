#!/bin/bash

# 定型文を登録し、出力する。その際、文中で変更できるところを決めておきコマンドを実行するたびに変更する。

# 使い方の出力
if [ $# == 0 ]; then
  cat usage-output-fixed-text.txt
  exit 0
fi

# 引数処理
replace_word="xxx"
add_file=""
view_file_name="false"
view_file_text="false"
file_name=""

count=$#
for ((index=1; $index<=$count; index++))
do
  next_index=$(($index + 1))
  echo "${!index}" | grep -q -- "-r" && replace_word=${!next_index} && index=$next_index && continue
  echo "${!index}" | grep -q -- "-f" && add_file=${!next_index} && index=$next_index && continue
  echo "${!index}" | grep -q -- "-v" && view_file_name="true" && continue
  echo "${!index}" | grep -q -- "-t" && view_file_text="true" && continue
  echo "${!index}" | grep -q -E -- "^-" && echo "そのオプションはありません" && exit 1
  file_name=${!index}
done
 
# add_fileという変数が存在し、ファイルが存在しないときエラー出力
if [ "${#add_file}" != 0 ] && ! `ls $add_file > /dev/null 2>&1`; then
  echo "定型文に登録するファイルが見つかりません。" ; exit 1
fi

ls store_fixed_text > /dev/null 2>&1 || mkdir store_fixed_text

# オプションで一覧表示が指定された場合の処理
# -v
if [ $view_file_name == "true" ]; then
   ls -1 store_fixed_text ; exit 0
fi
# -t
if [ $view_file_text == "true" ]; then
  _IFS=$IFS ; IFS=,
  cat_files=(`ls -1 store_fixed_text | tr "\n" ","`)
  IFS=$_IFS
  for cat_file in "${cat_files[@]}"
  do
    echo "===> "${file_name}" <===="
    cat "store_fixed_text/${file_name}"
  done
  exit 0
fi

# 新規ファイルを登録する場合
if [ ${#add_file} != 0 ]; then
  eval cp $add_file ./store_fixed_text
  sed -i "1s/^/>>>delimiter:$replace_word\n/" ./store_fixed_text/$add_file
  echo "$add_fileを新規ファイルとして登録しました。"
  exit 0
fi


# 定型文をファイルから出力させる
if [ ${#file_name} == 0 ]; then
   echo "登録したファイル名を出力してください" ; exit 1
fi

# 途中終了の場合
read_delimiter="xxx"
#trap 'ls ft-output.txt > /dev/null 2>&1 && cat ft-output.txt' Exit

ls ft-output.txt > /dev/null 2>&1 && rm ft-output.txt 
# ファイルごとに設定された区切り文字を取得（デフォルト : "xxx")
read_delimiter=`head ./store_fixed_text/$file_name -n 1 | sed -e "s/>>>delimiter:\(.*\)/\1/"`
text_content=""

# while read lineの中ではreadが使えないため定型文を配列に格納
while read line
do
  text_content+="$line,"
done < ./store_fixed_text/$file_name
_IFS=$IFS ; IFS=,
file_texts=(`echo "$text_content"`) ; IFS=$_IFS

# xxxの文字置換
for line in "${file_texts[@]}"
do
  if [[ $line =~ delimiter ]]; then
    continue
  fi
  if [[ "${line}" =~ ${read_delimiter} ]]; then
    replace_count=`echo $line | grep -c "${read_delimiter}"`
    for (( index=1; index<=$replace_count; index++ ))
    do
      echo "${line}"
      echo -e "$indexつ目の$read_delimiterに対して置換する文字を入力して下さい\n>"
      read replace
      line=`echo "${line}" | sed -e "s/$read_delimiter/$replace/"`
    done
    echo -e "${line}" >> ft-output.txt
    continue
  fi    
  # 置換文字がないのでそのまま
   echo "${line}" >> ft-output.txt
done
# 定型文を出力
echo -e "\n===> 出力結果 <===\n"
ls ft-output.txt > /dev/null 2>&1 && cat ft-output.txt || exit 1


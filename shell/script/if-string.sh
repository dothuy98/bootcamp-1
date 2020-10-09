#!/bin/bash

# 文字列一致 : = or ==
stringA="A"
stringB="A"
if [ $stringA == $stringB ]; then
  echo "$stringA,$stringB is same string"
else
  echo "$stringA,$stringB is not same string"
fi

# 正規表現の使用
if [[ $stringA =~ [A-Z] ]]; then
  echo "$stringA is [A-Z]"
else
  echo "$stringA is not [A-Z]"
fi
if [[ $stringA =~ [a-z] ]]; then
  echo "$stringA is [a-z]"
else
  echo "$stringA is not [a-z]"
fi

# -n : 文字列の長さが1以上か
# -z : 文字列の長さが0か
stringC=""
if [ -z $stringC ]; then
  echo "stringC's length is 0"
else
  echo "stringC's length is not 0"
fi

if [ -n $stringA ]; then
  echo "stringA's length is 1 or more"
fi

# ある文字列が変数に含まれているかの判定
text="Akira"
if [ $(echo $text | grep -e 'Aki') ]; then
  echo -e "$text include 'Aki'"
fi

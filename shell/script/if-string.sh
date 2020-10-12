#!/bin/bash

# 文字列一致 : = or ==
string_a="A"
string_b="A"
if [ $string_a == $string_b ]; then
  echo "$string_a,$string_b is same string"
else
  echo "$string_a,$string_b is not same string"
fi

# 正規表現の使用
if [[ $string_a =~ [A-Z] ]]; then
  echo "$string_a is [A-Z]"
else
  echo "$string_a is not [A-Z]"
fi
if [[ $string_a =~ [a-z] ]]; then
  echo "$string_a is [a-z]"
else
  echo "$string_a is not [a-z]"
fi

# -n : 文字列の長さが1以上か
# -z : 文字列の長さが0か
string_c=""
if [ -z $string_c ]; then
  echo "string_c's length is 0"
else
  echo "string_c's length is not 0"
fi

if [ -n $string_a ]; then
  echo "string_a's length is 1 or more"
fi

# ある文字列が変数に含まれているかの判定
text="Akira"
if [ $(echo $text | grep -e 'Aki') ]; then
  echo -e "$text include 'Aki'"
fi

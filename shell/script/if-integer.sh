#!/bin/bash

# 整数一致
if [ 1 -eq 1 ]
# "["の次はスペースを必ず入れる。"]"は前にスペースを入れる。
then
  echo "1 -eq 1 is true"
else
  echo "1 -eq 1 is false"
fi

# 整数比較
# -lt : less than : <
# -le : less than or equal : <=
# -gt : grater than : >
# -ge : grater than or equal : >=
# 例1
if [ 1 -lt 2 ]; then
# ;(セミコロン）で1行で記述できる。ほかのコマンドも同様に行える。
  echo "1 -lt 2 is true"
else
  echo "1 -lt 2 is false"
fi

# 例2 FizzBuzz
# 変数定義においてスペースを=の前後に入れない。
number=2

if [ $((number % 5)) == 0 -a $((number % 3)) == 0 ]; then
# -a は論理演算子の&&(AND)の意味。-o は||(OR)の意味。
# if [ $((number % 5)) == 0 ] && [ $((number % 3)) == 0]; then でも同じ意味になる
  echo "Fizz Buzz"
elif [ $((number % 3)) == 0 ]; then
  echo "Buzz"
elif [ $((number % 5)) == 0 ]; then
  echo "Fizz"
else
  #変数の出力方法一覧
  echo $number
  echo "$number"
  echo "${number}"
fi

# 例3 小数一致
# if文ではtestコマンドが使用されており、真(1)、偽(0)の終了ステータスのみを返している。
# また、testコマンドでは小数比較を扱えない。
number_a=0.3
number_b=0.3
if [ `echo "$number_a == $number_b" | bc` == 1 ]; then
  echo "$number_a == $number_b"
else
  echo "$number_a != $number_b"
fi
# 例4 小数の足し算をした結果の一致
number_a=`echo "scale=1000; 0.1 + 0.1 + 0.1" | bc`
# scaleで小数点以下の出力桁を制御。
number_b=0.3
if [ `echo "$number_a == $number_b" | bc` == 1 ]; then
  echo "$number_a == $number_b"
else
  echo "$number_a != $number_b"
fi

# pythonなどで0.1+0.1+0.1を行うと2進数では完全に小数を表現できない関係で0.30000000000000004などが出力されるがそうならない。
# 調べてみるとbcコマンドは10進数で計算しているため問題なく計算できることがわかった。
# 2進数を10進数にする方法で有名なものは2進化10進数という方法で、4ビットあれば0~15まで表せるため内部で2進数を10進数にして計算していると考える。


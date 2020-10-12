#!/bin/bash

number=$1
decimalPlace=$2 #小数第何位まで計算するか
ans=0
end=0 # ちょうど一致する値が出たとき,ネストしたループを抜けるために使用

# テストコードについてはtest-code_for_square-root.shにて記述。

# 例外処理
if [ -z $number ] || [ -z $decimalPlace ]; then
  echo "引数が足りない"
  exit
fi

if [ `echo "scale=$decimalPlace; $number < 0" | bc` == 1 ]; then
  echo "正の数ではない"
  exit
fi

if [[ $number =~ [^[:digit:]] ]] || [[ $decimalPlace =~ [^[:digit:]] ]] ; then
# shellでは/dや/wが使えない為、POSIX表記で正規表現を記述した。
  echo "引数が数値でない > $number , $decimalPlace"
  exit
fi

if [ $number == 0 ]; then
  echo $number
  exit
fi

# 求める小数の数だけループをまわす
for count in `seq 0 $decimalPlace`
do
  for i in `seq 1 100`
  do
     # $iを$countが増えるにしたがって1倍、0.1倍、0.01倍...と小さくする。
     i=`echo "scale=$decimalPlace; $ans + $i * 0.1 ^ $count" | bc`

    square=`echo "scale=$decimalPlace; $i ^ 2" | bc`
    # 完全に一致した値
    if [ `echo "scale=$decimalPlace; $square == $number" | bc` == 1 ]; then
      ans=$i
      end=1
      break
    # 一致しないため次のループへ
    elif [ `echo "scale=$decimalPlace; $square > $number" | bc` == 1 ]; then
      ans=$previousNumber
      break
    fi
     previousNumber=$i
  done
  if [ $end == 1 ]; then
    break
  fi
done
echo $ans

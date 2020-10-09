#!/bin/bash

# 平方根の近似値の計算

number=$1 #対象となる数
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
# shellでは/dや\wが使えない為、POSIX表記で正規表現を記述した。
  echo "引数が数値でない > $number , $decimalPlace"
  exit
fi

if [ $number == 0 ]; then
  echo $number
  exit
fi
# 計算
for count in `seq 0 $decimalPlace`
do
  for i in `seq 1 100`
  do
    if [ $count != 0 ]; then
      i=`echo "scale=$decimalPlace; $ans + $i * 0.1 ^ $count" | bc`
    fi
    square=`echo "scale=$decimalPlace; $i ^ 2" | bc`
    #echo $square
    if [ `echo "scale=$decimalPlace; $square == $number" | bc` == 1 ]; then
      ans=$i
      end=1
      break
    elif [ `echo "scale=$decimalPlace; $square > $number" | bc` == 1 ]; then
      if [ $count == 0 ]; then
        #echo "break1 : $square"
        ans=$((i - 1))
        break
      else
        #echo "break2"
        ans=`echo "scale=$decimalPlace; $previousNumber - 0.1 ^ $count" | bc`
        break
      fi 
    fi
     previousNumber=$i
  done
  if [ $end == 1 ]; then
    #echo "break4"
    break
  fi
done
echo $ans

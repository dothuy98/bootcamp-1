#!/bin/bash

# 毎日のログを残す。
# 常に監視し、基準値以上になった場合、そのプロセスを知らせ、終了させるかどうか聞く。

today=`date +%Y%m%d`
cd $today && cd ../ || mkdir $today
now_hour=`date +%H`

max_use_memory=0
max_use_swap=0

for hour in {0..23}
do
  top -b -n 1 | sed -n 4,4p > ${today}/${today}_${hour}_log.txt
  for min in {0..59}
  do 
    memorys=`free | sed -n 2,2p`
    memorys=($memorys)
    use_memory=`echo "scale=3; ${memorys[2]} / ${memorys[1]} * 100" | bc`
    if [ `echo "scale=3; ${use_memory} >= ${max_use_memory}" | bc` == 1 ]; then
      echo -e "\nWARNIGN メモリの使用率が${max_use_memory}%を超え${use_memory}%です"
    fi
    echo "memory use ${use_memory}%" >> ${today}/${today}_${hour}_log.txt
    swaps=`free | sed -n 4,4p`
    swaps=($swaps)
    use_swap=`echo "scale=3; ${swaps[2]} / ${swaps[1]} * 100" | bc`
    if [ `echo "scale=3; ${use_swap} >= ${max_use_swap}" | bc` == 1 ]; then
      echo -e "\nWARNIGN スワップの使用率が${max_use_swap}%を超え${use_swap}%です"
    fi
    echo "swap use $use_memory%" >> ${today}/${today}_${hour}_log.txt

    sleep 1m
  done
done

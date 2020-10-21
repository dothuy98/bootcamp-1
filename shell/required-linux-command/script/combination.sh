#!/bin/bash

now=`date +%Y%m%d-%H:%M:%S`
ls log > /dev/null 2>&1 && echo "logディレクトリはすでにあります" || mkdir log
ps aux --sort -start_time | grep `whoami` | tail -n 5 > log/ps-$now.log
top -b -n 1 | tail -n 4 > log/top-$now.log
echo "現時点のログを作成しました。"

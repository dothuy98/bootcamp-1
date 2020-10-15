#!/bin/bash

function check_parameter () {
  if [ $1 == 0 ]; then
    echo "引数を設定してください" >&2
    exit 1
  fi
   
  if [ $1 -gt 1 ]; then
    echo "warning : 引数が2つ以上です。１つ目の引数のみを使用します。"
  fi
}

#!/bin/bash

# オプションを指定してプログラムの動きを変える。

echo "$@"

# そのオプションが存在するかどうか
# -- を指定するとそれ以降をすべてオプションではなく引数として受け取ってくれる。
echo $@ | grep -- "-a" && echo "引数にオプション-aは含まれています"

# オプションかどうかを判断する。
parameters=($@)
for parameter in "${parameters[@]}"
do
  echo $parameter | grep -Eq "^-" && echo "$parameterはオプション" || echo "$parameterはオプションではない"
done


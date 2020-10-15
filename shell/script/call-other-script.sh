#!/bin/bash

# 他のスクリプトを実行する
sh other-script.sh
bash other-script.sh
# 自分の環境ではshはbashのシンボリックリンクになっている。
# shはPOSIXというプログラムの呼び出し方法の基準に沿って動作するのに対して、bashはshの方言のようなものだが機能が多い。
# OSがDebianなどの場合、shはbashではなくdashを表す
# したがってbashにしかない機能を使いたい場合でshのシンボリックリンクがbash以外の場合shを使うとうまく動作しない場合がある。

# chmod +x などで実行権限を付与すること
./other-script.sh

# 別ファイルの関数を実行
add 1
# > 動かない

# sourceで実行するとこのスクリプトと同じプロセスで実行する。
# shやbashではサブプロセス（子プロセス）を生成してから実行されるため変数・関数を参照できない。
source ./other-script.sh
# . ./other-script.shでも同じ意味になる
add 1

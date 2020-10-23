p '&'
p [1, 3, 7] & [3, 9, 11]

p '*'
p [1, 2, 4] * ' '
# joinと同じ動きでjoinの方がわかりやすい。
p [1, 2, 4].join(' ')

p '<=>'
# 一致>1, 配列の長さが短い,不一致>-1, 一致しており自分の方が長い>1,配列以外>nil
p [0, 2, 3] <=> [1, 2, 3]
p [1, 2, 3, 4] <=> [1, 2, 3]

p 'assoc'
# 二次元配列のみ探索可能で配列の配列の0番目を探す。
p [[[1,3],3],[1,5],[4,3]].assoc(1)

p 'map!'
# 配列から新しい配列を作成する。空の配列がいらない。
p [1, 2, 3].map! {|index| index**2 }

p 'combination'
# 指定したサイズの組み合わせをすべて列挙してくれる
p "1234".chars.combination(2).to_a

p 'compact'
# nilを削除する。変更が行われた場合のみselfを返す。それ以外はnilを返す。
p array = [1, nil, 2].compact
p array.compact

p 'cycle'
# cycle(n)のnの回数だけ繰り返す。nがない場合には無限ループ
"トマ".chars.cycle(12) {|string| print string }
puts "\n"

p 'dig'
# 途中のオブジェクトがnilでもエラーをださない。
p [(1..3).to_a,nil,(1...10).to_a]
p [[*1..3],nil,[*1...10]].dig(1, 0)

p 'select'
# 条件が真になった場合の要素のみを戻り値として返す。
p array = [*0..10].select {|number| number.odd? }

p 'find'
# 最初に真になった要素を返す。
p [*0..20].find{|number| number.even? }

p 'index'
# 最初に真になった要素の要素番号を返す。
p [*1..32].index(23)

p 'first'
# 引数なしの場合だと配列の最初の要素を要素として返す。
p [*'a'..'z'].first
# 引数をつけると配列として、引数で指定したindexまで配列として返す。
p [*'a'..'z'].first(5)

p 'flatten'
# 引数なしの場合、深さを無視してネストを平坦化させる。
p [[[[*1...10]]]].flatten
# 引数がある場合はその引数の数まで平坦化する。
p [[[[*1...10]]]].flatten(2)

p 'insert'
# 第一引数の値の直前のindexに値を挿入する。挿入する値は第二引数で指定できる。
array = ['a','d']
p [*0..10].insert(5,*array)

p 'last'
# firstの反対の動きをする。
p 'Taro'.chars.last

p 'permutation'
# 指定した引数のサイズの順列をEnumerator オブジェクトとして返す。
'john'.chars.permutation(4).each{|string| print "#{string.join}, "}
puts "\n"

p 'pop'
# pushの反対。戻り値は削除された要素。引数を指定すると数値分、末端から削除できる。
array = [*2...10]
p array.pop(2)
p array

p 'product'
# レシーバーと引数で要素を1つずつとり、新しい要素を作成する。複数の引数を指定することもできる。
[*0..3].product([*'a'..'d']).each{|string1, string2| print"#{string1}#{string2}, "}
puts "\n"

p 'rotate'
# 指定した要素が先頭になるように自身の順番を操作する。
p [*3..11].rotate(-1)

p 'sample'
# 配列の中からランダムに要素を選び返す。引数を指定するとその数だけ要素を返す。

# hashのインスタンスメソッドについてまとまる。

# デフォルト値の設定
hash1 = Hash.new("default")
p hash1[:a]
# ブロックをつかっても記述できる。
hash2 = Hash.new {"d"}
p hash2[:k]

p 'asscos'
# arrayでも2次元配列を探索する目的でこのメソッドが存在したが、本来はhashの為につかうメソッドと感じた。
# arrayのassocはarrayからhashに変換するための確認に使える
# hashのassocはkeyが存在する場合に配列としてkey,valurを返す。
hash = {color: "red", 'type' => 'file'}
# p hash.accoc(:color)
# シンボルは指定できない
p hash.assoc('type')

p 'compact'
# 自身からnilを抜いたhashを返す。
hash = {a: 1, c: nil}
p hash.compact
# {:a => 1}と矢印を使用したhashとして返る

p 'default'
# default値を返す。
hash = Hash.new { |hash, key| hash[key] = '3' }
# keyが指定場合のみデフォルト値を持つ
p hash.default(:a)
p hash.default
p hash[:b] = "fs"
p hash

p 'reject'
# 条件を評価した結果、真である要素を削除したhashを返す。削除できなかった場合はnilを返すがdelite_ifは常にselfを返す
hash = {'1': 2, 3 => 9}
p hash.reject { |_key, value| value.even? }

p 'each_key'
hash = {'1' => 2, '7' => 5}
hash.each_key { |k| p k.to_i**2 }

p 'invert'
# keyとvalueを入れ替える
hash = {a: 1, b: 2}
p hash.invert

p 'merge'
# hashの内容をマージした結果を返す。重複したキーがある場合はブロックの内容にしたがって処理する。
p hash = {a: 3, b: 1}
p hash.merge({c: 1, d: 3})
p hash.merge({a: 10, b: 1}) { |_key, old_val, new_val| old_val + new_val }

p 'rassoc'
# assocと異なりvalueで探索し、配列で返す。
hash = {a: 5, d: 1}
p hash.rassoc(5)

p 'rehash'
# hashのkeyのオブジェクトが変化すると、ハッシュ値が変わってしまい対応する値が見つからなくなるためrehashで再計算する
a = [1, 4, 3]
hash = {a => 'ok', g: 5}
p hash[a]
a[1]=32
p hash[a]
hash.rehash
p hash[a]

p 'sort'
# defaultでkeyでソートする。
hash = {b: 1, a: 2, c:0}
p hash.sort.to_h
# valueでソート
p hash.sort_by { |_, v| v }.to_h

p 'transform_key'
# すべてのkeyに対してブロックで指定した条件のもと変更を行う。
hash = {s: 4, m: 4}
p hash.transform_keys(&:to_s)

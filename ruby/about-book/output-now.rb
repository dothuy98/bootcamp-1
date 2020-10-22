require 'date'

now = Time.now
p now.to_s.gsub!(/(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2}).*/,'\1年\2月\3日\4時\5分\6秒')

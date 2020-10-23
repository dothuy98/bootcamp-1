questions = ['たばこ', '飲酒', '運動', 'ヨガ', '夜更かし']
points = {'たばこ' => -3, '飲酒' => -2, '運動' => 2, 'ヨガ' => 1, '夜更かし' => -3 }

your_health = 0
questions.shuffle.each do |key|
  puts "#{key}をしますか？[y/n]"
  answer = gets.chomp
  redo unless answer == 'y' || answer == 'n'
  your_health += points[key] if answer == 'y'
end

message =
  case your_health
  when (-8..-4)
    'すごく不健康'
  when (-3..-1)
    '不健康'
  when 0
    '普通'
  when (1..3)
    '健康
  end
p message

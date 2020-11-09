require './lib/google_gateway'

module Translatable
  
  def translate(text)
    japanese?(text) ? translate_japanese(text) : translate_english(text)
  end
  
  def translate_japanese(text)
    GoogleGateway.new(text).run
  end
  
  def translate_english(text)
    GoogleGateway.new(text).run(target: 'ja', source: 'en')
  end    
  
  def japanese?(target_word)
    /(?:\p{Hiragana}|\p{Katakana}|[一-龠々])/.match?(target_word)
  end
  
end
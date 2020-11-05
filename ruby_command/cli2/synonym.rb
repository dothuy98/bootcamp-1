require 'uri'
require 'net/http'
require 'openssl'
require 'json'

class Synonym
  API_KEY = File.open("api_key.txt", "r").first.chomp("\n")
  HOW_TO_USE = <<~USAGE
  Usage: get_synonym.rb word1 [word2 ...]
  Outputs synonyms for the inputed words.
USAGE

  def initialize(words = [])
    @words = words
  end
  
  def run
    return puts HOW_TO_USE if @words.empty?
    fetch_synonyms
  end
  
  # 類義語を得て出力する。取得と出力を分けるとかえってわかりづらいと判断。
  def fetch_synonyms
    @words.each do |target_word|
      synonyms = JSON.parse(request_words_api(target_word, 'synonyms'))
      puts "#{synonyms['word']} > "
      synonyms['synonyms'].each { |synonym| puts synonym }
    end
  end
  
  # 関数名の命名が難しい。
  def request_api(target_word, what_to_get)
    url = URI("https://rapidapi.p.rapidapi.com/words/#{target_word}/#{what_to_get}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-key"] = API_KEY
    request["x-rapidapi-host"] = 'wordsapiv1.p.rapidapi.com'
    http.request(request).read_body
  end
  
end

if __FILE__ == $0
  Synonym.new(ARGV).run
end
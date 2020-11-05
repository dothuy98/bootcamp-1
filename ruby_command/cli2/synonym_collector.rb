require 'uri'
require 'net/http'
require 'openssl'
require 'json'

class SynonymCollector
  API_KEY = 
  HOW_TO_USE = <<~USAGE
  Usage: synonym.rb word1 [word2 ...]
  Outputs synonyms for the inputed words.
USAGE

  def initialize(words = [])
    @words = words
  end
  
  def run
    raise puts HOW_TO_USE if @words.empty?
    convert_words
  end
  
  def set_api_key
    ENV['API_KEY'] = File.open("api_key.txt", "r").first.chomp("\n")
  end
  
  def convert_words
    @words.each do |target_word|
      converted_synonyms = fetch_synonym(target_word)
      puts_synonym(converted_synonyms['word'], converted_synonyms['synonyms'])
    end
  end
  
  def puts_synonym(inputed_word, synonyms)
    puts "#{inputed_word} >"
    puts synonyms.each { |synonym| puts synonym }
  end
  
  def fetch_synonym(target_word)
    JSON.parse(request_api(target_word, 'synonyms'))
  end
  
  def request_api(target_word, what_to_get)
    set_api_key
    url = URI("https://rapidapi.p.rapidapi.com/words/#{target_word}/#{what_to_get}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-key"] = ENV['API_KEY']
    request["x-rapidapi-host"] = 'wordsapiv1.p.rapidapi.com'
    http.request(request).read_body
  end
  
end

if __FILE__ == $0
  SynonymCollector.new(ARGV).run
end
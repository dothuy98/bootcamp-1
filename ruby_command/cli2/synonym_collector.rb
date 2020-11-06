require 'uri'
require 'net/http'
require 'openssl'
require 'json'

class SynonymCollector
  
  HOW_TO_USE = <<~USAGE
  Usage: synonym.rb word1 [word2 ...]
  Outputs synonyms for the inputed words.
USAGE

  def initialize(words = [])
    @words = words
  end
  
  def run
    raise HOW_TO_USE if @words.empty?
    convert_synonyms
  end
  
  def convert_synonyms
    @words.each do |word|
      converted_synonyms = fetch_synonym(word)
      puts_words(converted_synonyms['word'], converted_synonyms['synonyms'])
    end
  end
  
  def puts_words(inputed_word, output_words)
    puts "#{inputed_word} >"
    puts output_words.each { |output_word| puts output_word }
  end
  
  def fetch_synonym(target_word)
    JSON.parse(request_api(target_word, 'synonyms'))
  end
  
  def request_api(target_word, what_to_get)
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
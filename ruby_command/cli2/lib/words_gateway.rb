require 'uri'
require 'net/http'
require 'openssl'
require 'json'

class WordsGateway
  
  def initialize(target_word, what_to_get)
    @target_word = target_word
    @what_to_get = what_to_get
  end
  
  def run
    raise "error: words api key is not define" if ENV['WORDS_API_KEY'].nil?
    request_api
  end
  
  def request_api
    url = URI("https://rapidapi.p.rapidapi.com/words/#{@target_word}/#{@what_to_get}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-key"] = ENV['WORDS_API_KEY']
    request["x-rapidapi-host"] = 'wordsapiv1.p.rapidapi.com'
    JSON.parse(http.request(request).read_body).values.flatten!
  end
  
end
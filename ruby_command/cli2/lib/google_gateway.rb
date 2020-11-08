require 'net/http'
require 'json'
require 'uri'

class GoogleGateway
  
  def initialize(text)
    @text = text
  end
  
  def run(target: 'en', source: 'ja')
    raise "error: google api key is not define" if ENV['GOOGLE_API_KEY'].nil?
    request_api(target, source)
  end
  
  def request_api(target, source)
    url = URI.parse('https://www.googleapis.com/language/translate/v2')
    params = {
      q: @text,
      target: target,
      source: source,
      key: ENV['GOOGLE_API_KEY']
    }
    url.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(url)
    JSON.parse(res.body)["data"]["translations"].first["translatedText"]
  end
  
end
require 'nokogiri'
require 'open-uri'

class MinimumPriceExtractor
  
  USAGE = <<~HOW_TO_USE
  Usage: ruby ./lib/minimum_price_extractor.rb goods_keyword1 [goods_keyword2 ...]
  Output the site URL and price that sells the lowest price of the inputed product.
HOW_TO_USE
  MAX_GOODS = 10
  
  def initialize(arguments)
    @arguments = arguments
  end
  
  def run
    raise "Please input one or more arguments" if @arguments.empty?
    return puts USAGE if @arguments.any? { |argument| argument == '-h' || argument == '--help' }
    fetch_goods_prices(create_url)
  end
  
  def create_url
    URI.encode("https://www.mercari.com/jp/search/?sort_order=price_asc&keyword=#{@arguments.join('+')}&status_on_sale=1")
  end
  
  def fetch_goods_prices(target_url)
    goods_document = Nokogiri.HTML(URI.open(target_url))
    goods_document.xpath('/html/body/div[1]/main/div[1]/section/div[2]/section/a').each_with_index do |target_goods, index|
      puts target_goods.xpath('div/h3').text
      puts target_goods.xpath('div/div/div[1]').text
      puts URI.join(target_url, target_goods.attribute('href').value)
      break if index == MAX_GOODS
    end
  end
  
end

if __FILE__ == $0
  MinimumPriceExtractor.new(ARGV).run
end
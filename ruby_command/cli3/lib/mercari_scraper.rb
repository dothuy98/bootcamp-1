require 'nokogiri'
require 'open-uri'
require './lib/argv_extractor'

class MercariScraper
  
  USAGE = <<~HOW_TO_USE
  Usage: ruby ./lib/minimum_price_extractor.rb goods_keyword1 [goods_keyword2 ...]
  Outputs the price and URL of the goods in Mercari
  Option: 
    -h, --help            display usage.
    -a, --asc             sort in ascending order of price.
    -d, --desc            sort in descending order of price.
HOW_TO_USE
  MAX_GOODS = 10
  
  def initialize(goods_keywords, option)
    @goods_keywords = goods_keywords
    @option = option
  end
  
  def run
    return puts USAGE if @option == 'help'
    raise "Please input one or more arguments" if @goods_keywords.empty?
    
    scrape_goods_prices(create_url)
  end
  
  def create_url
    mercari_url = 'https://www.mercari.com/jp/search/?status_on_sale=1'
    mercari_url += '&sort_order=price_asc' if @option == 'asc'
    mercari_url += '&sort_order=price_desc' if @option == 'desc'
    URI.encode("#{mercari_url}&keyword=#{@goods_keywords.join('+')}")
  end
  
  def scrape_goods_prices(target_url)
    goods_document = Nokogiri.HTML(URI.open(target_url))
    goods_document.xpath('/html/body/div[1]/main/div[1]/section/div[2]/section/a').each_with_index do |target_goods, index|
      break if index == MAX_GOODS
      puts target_goods.xpath('div/h3').text
      puts target_goods.xpath('div/div/div[1]').text
      puts URI.join(target_url, target_goods.attribute('href').value)
    end
  end
  
end

if __FILE__ == $0
  MercariScraper.new(ArgvExtractor.select_keywords(ARGV), ArgvExtractor.find_option(ARGV)).run
end
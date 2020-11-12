require 'nokogiri'
require 'open-uri'
require './lib/argv_extractor'

class MercariScraper
  
  USAGE = <<~HOW_TO_USE
  Usage: ruby ./lib/minimum_price_extractor.rb product_keyword1 [product_keyword2 ...]
  Outputs the price and URL of the product in Mercari
  Option: 
    -h, --help            display usage.
    -a, --asc             sort in ascending order of price.
    -d, --desc            sort in descending order of price.
HOW_TO_USE
  MAX_PRODUCT = 10
  MERCARI_URL = 'https://www.mercari.com/jp/search/?status_on_sale=1'
  
  def initialize(product_keywords, option)
    @product_keywords = product_keywords
    @option = option
  end
  
  def run
    return puts USAGE if @option == 'help'
    raise "Please input one or more product_keywords" if @product_keywords.empty?
    
    scrape_product_prices(create_url)
  end
  
  def create_url
    URI.encode("#{sorted_url || MERCARI_URL}&keyword=#{@product_keywords.join('+')}")
  end
  
  def sorted_url
    @option == 'asc' ? "#{MERCARI_URL}&sort_order=price_asc" : "#{MERCARI_URL}&sort_order=price_desc" if /asc|desc/.match(@option)
  end  
  
  def scrape_product_prices(target_url)
    products_document = Nokogiri.HTML(URI.open(target_url))
    products_document.xpath('/html/body/div[1]/main/div[1]/section/div[2]/section/a').each_with_index do |target_product, index|
      break if index == MAX_PRODUCT
      
      puts_product(target_product)
    end
  end
  
  def puts_product(product_xpath)
    puts product_xpath.xpath('div/h3').text
    puts product_xpath.xpath('div/div/div[1]').text
    puts URI.join(MERCARI_URL, product_xpath.attribute('href').value)
  end
  
end

if __FILE__ == $0
  MercariScraper.new(ArgvExtractor.select_keywords(ARGV), ArgvExtractor.find_option(ARGV)).run
end
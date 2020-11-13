require 'nokogiri'
require 'open-uri'

class RakumaScraper
  
  RAKUMA_URL = 'https://fril.jp/s?transaction=selling'
  
  def initialize(product_keywords, options)
    @product_keywords = product_keywords
    @options = options
  end
  
  def run
    scrape_products(create_url)
  end
  
  def create_url
    URI.encode("#{sorted_url || RAKUMA_URL}&query=#{@product_keywords.join(' ')}")
  end
  
  def sorted_url
    return nil unless ['asc', 'desc', 'expensive', 'cheap'].any? { |key| @options[key] }  
    
    ['asc', 'cheap'].any? { |key| @options[key] }  ? "#{RAKUMA_URL}&order=asc&sort=sell_price" : "#{RAKUMA_URL}&order=desc&sort=sell_price"
  end  
  
  def scrape_products(target_url)
    products_document = Nokogiri.HTML(URI.open(target_url))
    products_document.xpath('/html/body/div[3]/div/div/div/div/div/div[2]/section/div[2]/section/div/div/div[2]').map.with_index do |target_product, index|
      {'price' => scrape_price(target_product), 
       'headline' => scrape_headline(target_product), 
       'url' => scrape_url(target_product)}
    end
  end
  
  def scrape_headline(product_xpath)
    product_xpath.xpath('p/a/span').text
  end
  
  def scrape_price(product_xpath)
    product_xpath.xpath('div[2]/p/span[2]').text.gsub(/\D/,'')
  end
  
  def scrape_url(product_xpath)
    URI.join(RAKUMA_URL, product_xpath.xpath('p/a').attribute('href').value)
  end
  
end
require 'nokogiri'
require 'open-uri'

class YahooShoppingScraper
  
  YAHOO_URL = 'https://shopping.yahoo.co.jp/search?'
  
  def initialize(product_keywords, options)
    @product_keywords = product_keywords
    @options = options
  end
  
  def run
    scrape_products(create_url)
  end
  
  def create_url
    URI.encode("#{sorted_url || YAHOO_URL}&p=#{@product_keywords.join('+')}")
  end
  
  def sorted_url
    return nil unless ['asc', 'desc', 'expensive', 'cheap'].any? { |key| @options[key] }  
    
    ['asc', 'cheap'].any? { |key| @options[key] }  ? "#{YAHOO_URL}&X=2&sc_i=shp_pc_search_sort_sortitem" : "#{YAHOO_URL}&X=3&sc_i=shp_pc_search_sort_sortitem"
  end  
  
  def scrape_products(target_url)
    products_document = Nokogiri.HTML(URI.open(target_url))
    products_document.xpath('//li/div/ul/li/div/div[2]').map.with_index do |target_product, index|
      {'price' => scrape_price(target_product), 
       'headline' => scrape_headline(target_product), 
       'url' => scrape_url(target_product)}
    end
  end
  
  def scrape_headline(product_xpath)
    product_xpath.xpath('p/a/span').text
  end
  
  def scrape_price(product_xpath)
    product_xpath.xpath('div/p/span[1]').text.gsub(/\D/,'')
  end
  
  def scrape_url(product_xpath)
    URI.join(YAHOO_URL, product_xpath.xpath('p/a').attribute('href').value)
  end
  
end
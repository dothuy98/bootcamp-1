require 'nokogiri'
require 'open-uri'
require './lib/argv_extractor'

class MercariScraper
  
  MERCARI_URL = 'https://www.mercari.com/jp/search/?status_on_sale=1'
  
  def initialize(product_keywords, options)
    @product_keywords = product_keywords
    @options = options
  end
  
  def run
    scrape_products(create_url)
  end
  
  def create_url
    URI.encode("#{sorted_url || MERCARI_URL}&keyword=#{@product_keywords.join('+')}")
  end
  
  def sorted_url
    return nil unless ['asc', 'desc', 'expensive', 'cheap'].any? { |key| @options[key] }  
    
    ['asc', 'cheap'].any? { |key| @options[key] }  ? "#{MERCARI_URL}&sort_order=price_asc" : "#{MERCARI_URL}&sort_order=price_desc"
  end  
  
  def scrape_products(target_url)
    products_document = Nokogiri.HTML(URI.open(target_url))
    mercari_products = []
    products_document.xpath('/html/body/div[1]/main/div[1]/section/div[2]/section/a').each.with_index do |target_product, index|
      break if index == (@options['max_count'] || 10)
      #break if ['expensive', 'cheap'].any? { |key| @options[key] } && scrape_price(target_product) != boundary_price(products_document) 
      
      mercari_products.push({'price' => scrape_price(target_product), 
                             'headline' => scrape_headline(target_product), 
                             'url' => scrape_url(target_product)})
    end
    mercari_products
  end
  
  def scrape_headline(product_xpath)
    product_xpath.xpath('div/h3').text
  end
  
  def scrape_price(product_xpath)
    product_xpath.xpath('div/div/div[1]').text.gsub(/\D/,'')
  end
  
  def scrape_url(product_xpath)
    URI.join(MERCARI_URL, product_xpath.attribute('href').value)
  end
  
  def boundary_price(document)
    #document.xpath('/html/body/div[1]/main/div[1]/section/div[2]/section[1]/a/div/div/div[1]').text.gsub(/\D/,'')
  end
  
end

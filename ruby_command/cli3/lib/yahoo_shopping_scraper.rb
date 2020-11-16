require './lib/products_scrapable'

class YahooShoppingScraper
  
  include ProductsScrapable
  
  YAHOO_URL = 'https://shopping.yahoo.co.jp/search?'
  
  def initialize(product_keywords, options)
    @product_keywords = product_keywords
    @options = options
  end

  def run
    scrape
  end
  
  def scrape
    scrape_products(
      url: create_url,
      product_xpath: '//li/div/ul/li/div/div[2]',
      price_xpath: 'div/p/span[1]',
      headline_xpath: 'p/a/span',
      url_xpath: 'p/a'
    )
  end
  
  def create_url
    URI.encode("#{YAHOO_URL}#{add_sorted_path}&p=#{@product_keywords.join('+')}")
  end
  
  def add_sorted_path
    @options.key?(:desc) ? '&X=3' : '&X=2'
  end  
  
end
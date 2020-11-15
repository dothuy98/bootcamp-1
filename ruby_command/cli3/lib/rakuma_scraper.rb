require './lib/products_scrapable'

class RakumaScraper
  
  include ProductsScrapable
  
  RAKUMA_URL = 'https://fril.jp/s?transaction=selling'
  
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
      product_xpath: '/html/body/div[3]/div/div/div/div/div/div[2]/section/div[2]/section/div/div/div[2]',
      price_xpath: 'div[2]/p/span[2]',
      headline_xpath: 'p/a/span',
      url_xpath: 'p/a'
    )
  end
  
  def create_url
    URI.encode("#{RAKUMA_URL}#{add_sorted_path}&query=#{@product_keywords.join(' ')}")
  end
  
  def add_sorted_path
    @options.key?(:desc) ? '&order=desc&sort=sell_price' : '&order=asc&sort=sell_price'
  end  
  
end
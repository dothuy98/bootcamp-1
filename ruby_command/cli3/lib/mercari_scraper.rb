require './lib/products_scrapable'

class MercariScraper
  
  include ProductsScrapable
  
  MERCARI_URL = 'https://www.mercari.com/jp/search/?status_on_sale=1'
  
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
      product_xpath: '/html/body/div[1]/main/div[1]/section/div[2]/section',
      price_xpath: 'a/div/div/div[1]',
      headline_xpath: 'a/div/h3',
      url_xpath: 'a'
    )
  end
  
  def create_url
    URI.encode("#{MERCARI_URL}#{add_sorted_path}&keyword=#{@product_keywords.join('+')}")
  end
  
  def add_sorted_path
    @options.key?(:desc) ? '&sort_order=price_desc' : '&sort_order=price_asc'
  end
  
end

require './lib/mercari_scraper'
require './lib/rakuma_scraper'
require './lib/yahoo_shopping_scraper'
require './lib/argv_extractor'

class BoundaryPricesExtractor
  
  USAGE = <<~HOW_TO_USE
  Usage: ruby ./lib/boundary_price_extractor.rb product_keyword1 [product_keyword2 ...] [option ...]
  
  Outputs the prices, headlines and URLs of the product in mercari, rakuma and yahoo shopping.
  Also, The output product is the lowest price or the highest price.
  
  Option: 
    -h, --help                    display usage.
    -a, --asc (default order)     sort in ascending order of price and output the lowest price products.
    -d, --desc                    sort in descending order of price and output the highest price products.
    -!, --not <exclude_word>      if the product headline contains the specified word, exclude it.
                                  also, if you specify more than one word, enclose it in single or double quotes.
HOW_TO_USE

  def initialize(product_keywords, options)
    @product_keywords = product_keywords
    @options = options
  end

  def run
    return puts USAGE if @options[:help] == true
    raise "Please input one or more product_keywords" if @product_keywords.empty?
    
    extract_products(collect_products)
  end
  
  def collect_products
    exclude_NOT_search_from(
      [*MercariScraper.new(@product_keywords, @options).run,
      *RakumaScraper.new(@product_keywords, @options).run,
      *YahooShoppingScraper.new(@product_keywords, @options).run]
    )
  end
  
  def extract_products(products)
    return puts "sorry, not found product" if products.empty?
    
    products.each_with_index do |product, index|
      next if boundary_price(products) != product[:price].to_i
      
      puts add_unit(product).values
    end
  end
  
  # calculation of the cheapest or highest price
  def boundary_price(products)
    @options.key?(:desc) ? products.map{ |product| product[:price].to_i }.max : products.map{ |product| product[:price].to_i }.min
  end
  
  def exclude_NOT_search_from(products)
    return products unless @options.key?(:not)

    products.reject do |product|
      /#{@options[:not].gsub(' ', '|')}/.match(product[:headline])
    end
  end
  
  def add_unit(product)
    product[:price] = "#{product[:price]}円"
    product
  end  
    
end

if __FILE__ == $0
  BoundaryPricesExtractor.new(ArgvExtractor.select_keywords(ARGV), ArgvExtractor.select_options(ARGV)).run
end
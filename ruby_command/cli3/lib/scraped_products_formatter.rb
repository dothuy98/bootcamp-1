require './lib/mercari_scraper'
require './lib/rakuma_scraper'
require './lib/yahoo_shopping_scraper'
require './lib/argv_extractor'

class ScrapedProductsFormatter
  
  USAGE = <<~HOW_TO_USE
  Usage: ruby ./lib/minimum_price_extractor.rb product_keyword1 [product_keyword2 ...] [option ...]
  
  Outputs the prices, headlines, URL of the product in mercari, rakuma and yahoo shopping.
  
  Option: 
    -h, --help                    display usage.
    -a, --asc                     sort in ascending order of price.
    -d, --desc                    sort in descending order of price.
    -c, --cheap                   output the cheapest price products.
    -e, --expensive               output the most expensive price products.
    -n, --max_count <number>      specify the number of products to scrape. (default: 10)
    -!, --not <exclude_word>      if the product headline contains the specified word, exclude it.
                                  also, if you specify more than one word, enclose it in single or double quotes.
HOW_TO_USE

  def initialize(product_keywords, options)
    @product_keywords = product_keywords
    @options = options
  end

  def run
    return puts USAGE if @options['help'] == true
    raise "Please input one or more product_keywords" if @product_keywords.empty?
    
    format_products(collect_products)
  end
  
  def collect_products
    [
    *MercariScraper.new(@product_keywords, @options).run,
    *RakumaScraper.new(@product_keywords, @options).run,
    *YahooShoppingScraper.new(@product_keywords, @options).run,
    ]
  end
  
  def format_products(products)
    sort_prices(products)
    sort_prices(products).each_with_index do |product_group, index|
      break if index == (@options['max_count'] || 10)
      break if ['expensive', 'cheap'].any? { |key| @options[key] } && boundary_price(products) != product_group['price']
      next if @options['not'] && exclude_word?(product_group)
      
      puts_product(product_group)
    end
  end
  
  def sort_prices(products)
    # shuffle is to prevent only metcari from being displayed
    return products.shuffle unless ['asc', 'desc', 'expensive', 'cheap'].any? { |key| @options[key] }
    
    ['asc', 'cheap'].any? { |key| @options[key] } ? products.sort_by{ |product| product['price'].to_i } : products.sort_by{ |product| - product['price'].to_i }
  end
  
  def boundary_price(products)
    @options['cheap'] ? products.map{ |product| product['price'] }.min : products.map{ |product| product['price'] }.max
  end
  
  def exclude_word?(product)
    /#{create_exclude_pattern}/.match(product['headline'])
  end
  
  def create_exclude_pattern
    @options['not'].gsub(' ', '|')
  end
  
  def puts_product(product_group)
    product_group.each do |product_key, product_value|
      if product_key == 'price'
        puts "#{product_value}円"
      else
        puts product_value
      end
    end
  end
end

if __FILE__ == $0
  ScrapedProductsFormatter.new(ArgvExtractor.select_keywords(ARGV), ArgvExtractor.select_options(ARGV)).run
end
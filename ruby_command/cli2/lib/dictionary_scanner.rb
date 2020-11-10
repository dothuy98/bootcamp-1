require './lib/translatable'
require './lib/file_filtable'
require './lib/words_gateway'

class DictionaryScanner
  
  include Translatable
  include FileFiltable
  
  HOW_TO_USE = <<~USAGE
  Usage: dictionary_scanner.rb word1 [word2 ...] [option]
  
  Output words that refer to the dictionary.
  Japanese words are automatically translated into English and searched.
  
  Options: 
    -s, --synonyms (default)        search for synonyms.
    -a, --antonyms                  search for antonyms.
    -e, --examples                  search for example sentence.
    -d, --definitions               search for the definition of words.
    -h, --help                      show usage.
    <file_name>                     translate English sentences into Japanese or Japanese sentences into English.
USAGE

  def initialize(orders = [])
    @orders = map_ja_to_en(orders)
    @option = find_option(orders)
  end
  
  def run
    return puts HOW_TO_USE if @option == 'help'
    raise HOW_TO_USE if @orders.empty?
    convert_orders
  end
  
  def map_ja_to_en(orders)
    orders.map { |word| japanese?(word) ? translate_japanese(word) : word }
  end
  
  def find_option(orders)
    return 'synonyms' unless orders.any? { |order| /^-/.match(order) }
    return orders.find { |order| /^--/.match(order) }.sub(/^--/, '') if orders.any? { |order| /^--/.match(order) }
    options = {
      '-s' => 'synonyms',
      '-a' => 'antonyms',
      '-d' => 'definitions',
      '-e' => 'examples',
      '-h' => 'help'
    }
    options[orders.find { |order| /^-/.match(order) }]
  end
  
  def convert_words
    @words.each do |word|
      puts_words(WordsGateway.new(word, @option).run)
    end
  end
  
  def convert_orders
    @orders.each do |order|
      next if /^-/.match(order)
      File.file?(order) ? puts_translate(extract_text(order)) : puts_words(WordsGateway.new(order, @option).run)
    end
  end
  
  def puts_words(words)
    puts "#{translate_english(words.first)} >>"
    puts "#{words.shift} >"
    return puts "No matching information was found" if words.empty?
    return words.each { |word| puts word } unless @option == 'definitions'
    words.each do |word|
      word.each { |key, value| puts "#{key}: #{value}" }
    end
  end
  
end

if __FILE__ == $0
  DictionaryScanner.new(ARGV).run
end
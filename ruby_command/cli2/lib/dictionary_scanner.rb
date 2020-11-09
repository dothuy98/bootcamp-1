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
    @words = reject_option(orders)
    @option = find_option(orders)
  end
  
  def run
    return puts HOW_TO_USE if @option == 'help'
    raise HOW_TO_USE if @words.empty?
    return puts translate(extract_texts(@words)) if include_file?(@words)
    convert_words
  end
  
  def reject_option(orders)
    orders.reject { |order| /^-/.match(order) }
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
      japanese?(word) ? puts_words(fetch_words(translate_japanese(word))) : puts_words(fetch_words(word))
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
  
  def fetch_words(target_word)
    WordsGateway.new(target_word, @option).run
  end
  
end

if __FILE__ == $0
  DictionaryScanner.new(ARGV).run
end
require './lib/translatable'
require './lib/file_filtable'
require './lib/words_gateway'
require './lib/argv_extractor'

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

  def initialize(arguments, option)
    @arguments = arguments
    @option = option
  end
  
  def run
    return puts HOW_TO_USE if @option == 'help'
    raise HOW_TO_USE if @arguments.empty?
    raise "error: such option does not exist" if @option.nil?
    convert_arguments
  end
  
  def convert_arguments
    @arguments.each do |argument|
      File.file?(argument) ? puts_translate(extract_text(argument)) : puts_words(WordsGateway.new(translate_japanese(argument), @option).run)
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
  DictionaryScanner.new(ArgvExtractor.select_arguments(ARGV), ArgvExtractor.find_option(ARGV)).run
end
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
    <file_name>                     translate English sentences into Japanese.
USAGE

  def initialize(words = [])
    @words = words
    @option = find_option
  end
  
  def run
    raise HOW_TO_USE if @words.empty?
    return puts HOW_TO_USE if @words.any? { |word| word == '-h' } || @words.any? { |word| word == '--help' }
    return puts translate_english(extract_texts(@words)) if include_file?(@words)
    convert_words
  end
  
  def find_option
    return 'synonyms' unless @words.any? { |word| /^-/.match(word) }
    return @words.find { |word| /^--/.match(word) }.sub(/^--/, '') if @words.find { |word| /^--/.match(word) }
    what_to_gets = {
      '-s' => 'synonyms',
      '-a' => 'antonyms',
      '-d' => 'definitions',
      '-e' => 'examples'
    }
    what_to_gets[@words.find { |word| /^-/.match(word) }]
  end
  
  def convert_words
    @words.each do |word|
      next if /^-/.match(word)
      puts_words(fetch_words(translate_japanese(word))) if japanese?(word)
      puts_words(fetch_words(word)) unless japanese?(word)
    end
  end
  
  def puts_words(words)
    puts "#{words.shift} >"
    return puts "No matching information was found" if words.empty?
    return words.each do |word|
      word.each { |key, value| puts "#{key}: #{value}" }
    end if @option == 'definitions'  
    words.each { |word| puts word }
  end
  
  def fetch_words(target_word)
    WordsGateway.new(target_word, @option).run
  end
  
end

if __FILE__ == $0
  DictionaryScanner.new(ARGV).run
end
require './lib/argv_extractor'

class FileCleaner
  USAGE = <<~HOW_TO_USE
  
HOW_TO_USE

  def initialize(file_names, option)
    @file_names = file_names
    @option = option
  end
  
  def run
    return puts USAGE if @option == 'help'
    return if @option == 'view'
    clean
    option_adopt
  end
  
  def clea
    # delete
    # restore
    # move trash
  end
  
  def target_path
    # @optionによって移動先のpathを変える
  end
  
  def option_adopt
    
  end
  
end

if __FILE__ == $0
  FileCleaner(ArgvExtractor.select_file_names(ARGV), ArgvExtractor.find_option(ARGV))
end
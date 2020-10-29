require './lib/trash_handler'

class ArgvFromatter
  
  HOW_TO_USE = <<~USAGE
Usage: trash_handler [options] file_name
    -r, --restore trashed_file        restore file to original position from ~/.trash 
    -v, --view                        view file in .trash
    -c, --compress [compress_method]  compress file or directory by zip format (default: zip)
    -d, --delete trashed_file         delete file or directory in ~/.trash 
    --delete-all                      delete all file and directory in ~/.trash
USAGE
  
  attr_reader :orders
    
  def initialize(orders = [])
    puts HOW_TO_USE if orders.empty?
    @orders = orders
  end
  
  def file_names
    return [] if /^-/.match(@orders.first)
    @orders[0...@orders.find_index { |index| /^-/.match(index) } || @orders.size]
  end
  
  def options
    return [] unless @orders.any? { |value| /^-/.match(value) }
    @orders[@orders.find_index { |index| /^-/.match(index) } || 0..]
  end
  
end

if __FILE__ == $0
  trash = ArgvFromatter.new(ARGV)
  TrashHandler.new(options: trash.options).run(file_names: trash.file_names)
end

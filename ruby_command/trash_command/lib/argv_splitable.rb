require 'optparse'
module ArgvSplitable
  def parse_options(argv)
  option = OptionParser.new
  self.class.module_eval do
      define_method(:usage) do |message = nil|
        puts option.to_s
        puts "error : #{message}" if message
        exit 1
      end
    end

    options = {
      restore: "",
      view_list: false,
      compress_method: "",
      delete_file: "",
      all_delete: false
    }

    option.on('-r','--restore VALUE', "restore file to original position from ~/.trash (default: #{options[:restore]}") do |value| 
      options[:restore] = delete_end_slash(value)
    end
    option.on('-v','--view', "view file in .trash (default: #{options[:view_list]}") do |value| 
      options[:view_list] = value
    end
    option.on('-c', '--compress [VALUE]', "compress file or directory (default: #{options[:compress_method]}" ) do |value|
      options[:compress_mothod] = value.nil? ? "zip" : value
    end
    option.on('-d', '--delete VALUE', "delete file or directory in ~/.trash (default: #{options[:delete_file]}" ) do |value|
      options[:delete_file] = delete_end_slash(slash)
    end
    option.on('-a', '--all_delete', "delete all file and directory in ~/.trash (default #{options[:all_delete]}" ) do |value|
      options[:all_delete] = value
    end
    
    option.banner += ' ARGV'

    begin
      arguments = option.parse(argv)
    rescue OptionParser::InvalidOption => error
      usage(error.message)
    end
    
    if ARGV.size.zero?
      usage('number of arguments and options is zero')
    end

    if arguments.size > 1
      usage('number of argumentes is more than 1')
    end
    
    arguments = arguments.map { |value| delete_end_slash(value) }
    
    [options, arguments]
  end
  
  # 引数の前処理を記述
  def delete_end_slash(value)
    value.chomp! if value[-1] == "/"
    value
  end
  
  # そのファイルが存在しているかどうかでerror
  
end

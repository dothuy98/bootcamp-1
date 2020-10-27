module ArgvSplitable
  HOW_TO_USE = <<~USAGE
Usage: trash_handler [options] ARGV
    -r, --restore VALUE              restore file to original position from ~/.trash 
    -v, --view                       view file in .trash
    -c, --compress [VALUE]           determine compress methods to file or directory 
    -d, --delete VALUE               delete file or directory in ~/.trash 
    -a, --all_delete                 delete all file and directory in ~/.trash
USAGE

  def check_exception(array)
    raise HOW_TO_USE if array.empty?
  end
  
  def extract_filename(array)
    array[0].chomp("/") if /^[^-]/.match(array[0]) && exist_file?(array[0])
  end
  
  def exist_file?(file_name)
    raise "error: no such file or directory" unless File.exist?(file_name)
    true
  end
  
  def extract_options(array)
    options = array.map.with_index do |value, index| 
      next if /^[^-]/.match(value)
      case value
      when "-r","--restore"
        err_value(value) unless array[index + 1]
        [:restore, array[index + 1].chomp("/")]
      when "-d", "--delete"
        [:delete, array[index + 1].chomp("/")]
        err_value(value) unless array[index + 1]
      when "-c", "--compress"
        [:compress, array[index + 1] || 'zip']
      when "-v","--view"
        [:view_list, true]
      when "--delete-all"
        [:delete_all, true]
      else
        raise "error: unknown predicate `#{value}'"
      end
    end
    #p options.compact.empty?
    
    options.compact.empty? ? {} : options.compact.to_h
  end
  
  def err_value(option)
    raise "error: #{option} option's value is not exist"
  end
  
end

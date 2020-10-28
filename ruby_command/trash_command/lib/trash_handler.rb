require 'fileutils'
require './lib/csv_editable'

class TrashHandler
  HOW_TO_USE = <<~USAGE
Usage: trash_handler [options] ARGV
    -r, --restore VALUE              restore file to original position from ~/.trash 
    -v, --view                       view file in .trash
    -c, --compress                   compress file or directory by zip format
    -d, --delete VALUE               delete file or directory in ~/.trash 
    --delete-all                     delete all file and directory in ~/.trash
USAGE

  include CsvEditable

  attr_reader :array
  
  def initialize(array)
    build_settings
    check_exception(array)
    @array = array
  end
  
  def run
    @array.each_with_index do |value, index| 
      PutTrash.new(value).run(find_compress) if index == 0 && /^[^-]/.match(value)
      next if /^[^-]/.match(value)
      case value
      when "-r","--restore"
        Restore.new(check_exist(array[index +  1])).run
      when "-v","--view"
        ViewList.new.run
      when "-d", "--delete"
        Delete.new(check_exist(array[index + 1])).run
      when "--delete-all"
        Delete.new.all
      when "-c","--compress"
      else
        raise "\nerror: unknown predicate `#{value}'"
      end
    end
  end
  
  private
  
  def check_exception(array)
    puts HOW_TO_USE if array.empty?
  end
  
  def find_compress
    return nil if @array.find_index { |value| value == "-c" || value == "--compress" }.nil?
    # 複数の圧縮形式に対応する場合
    # @array[@array.find_index { |value| value == "-c" || value == "--compress" } + 1]
    'zip'
  end
  
  def check_exist(value)
    raise "\nerror: that element is not found" if value.nil?
    raise "\nerror: that directory or file is not exist in ~/.trash" if count_samefile(value) == 0
    value
  end

end

class PutTrash
  TRASH_PATH = "#{Dir.home}/.trash"
  
  include CsvEditable
  
  attr_reader :file_name
  
  def initialize(file_name)
    check_exception(file_name)
    @file_name = file_name
  end
  
  def check_exception(file_name)
    raise "\nerror: no such file or directory in current directory" unless File.exist?(file_name)
  end
  
  def run(method)
    @file_name = Compress.new(method).run(@file_name)
    File.rename(@file_name, modify)
    FileUtils.mv(modify, TRASH_PATH)
    puts "saved file as '#{modify}' because same file name exist" unless modify == @file_name
    write([modify, Dir.pwd, method.nil? ? false : true])
  end

  private
  
  def modify
    return @file_name if count_samefile(@file_name) == 0
    @file_name.dup.insert(@file_name.index(".") || -1, "(#{count_samefile(@file_name)})")
  end
  
end

class Restore
  TRASH_PATH = "#{Dir.home}/.trash" 
  
  include CsvEditable
  
  attr_reader :file_name
  
  def initialize(file_name)
    @file_name = file_name
  end
  
  def run
    system("mv #{TRASH_PATH}/#{@file_name} #{find_path(@file_name)}")
    Uncompress.new("#{find_path(@file_name)}/#{@file_name}").run if find_compressed?(@file_name)
    write_2d_arr(select_other_than(@file_name))
  end
end

class Delete
  include CsvEditable
  
  attr_reader :file_name
  
  def initialize(file_name = "default")
    @file_name = file_name
  end
  
  def run
    FileUtils.rm_r("#{TRASH_PATH}/#{@file_name}")
    write_2d_arr(select_other_than(@file_name))
  end
  
  def all
    FileUtils.rm_r(TRASH_PATH)
  end
end

class ViewList
  include CsvEditable
  
  def run
    return "~/.trash has not file or directory" if read.empty?
    puts read.map { |array| array.join("\t") }
  end
end

class Compress
  attr_reader :method
  
  def initialize(method)
    @method = method.nil? ? 'none' : method
  end
  
  def run(file_name)
    return file_name if @method == "none"
    case method
    when "zip"
      system("zip -r #{add_extension(file_name)} #{file_name}")
    else
      raise "does not support this compression method"
    end
    add_extension(file_name)
  end
  
  private
  
  def add_extension(file_name)
    return file_name if @method == "none"
    "#{file_name}.#{@method}"
  end
end

class Uncompress
  attr_reader :file_name
  
  def initialize(file_name)
    @file_name = file_name
  end
  
  def run
    case only_extension(@file_name)
    when "zip"
      system("unzip #{file_name}")
    else
      raise "\nerror: unsupported extension"
    end
  end
  
  private
  
  def only_extension(file_name)
    file_name.gsub(/.*\./,'')
  end
end


if __FILE__ == $0
  TrashHandler.new(ARGV).run
end

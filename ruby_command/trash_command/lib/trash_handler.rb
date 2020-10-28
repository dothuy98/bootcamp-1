require 'fileutils'
require './lib/conversionable'
require './lib/csv_editable'

class TrashHandler
  HOW_TO_USE = <<~USAGE
Usage: trash_handler [options] ARGV
    -r, --restore VALUE              restore file to original position from ~/.trash 
    -v, --view                       view file in .trash
    -c, --compress VALUE             determine compress methods to file or directory 
    -d, --delete VALUE               delete file or directory in ~/.trash 
    --delete-all                     delete all file and directory in ~/.trash
USAGE

  include Conversionable
  include CsvEditable

  attr_reader :array
  
  def initialize(array)
    build_settings
    check_exception(array)
    @array = array
  end
  
  def run
    @array.map.with_index do |value, index| 
      PutTrash.new(value).run(find_compress(array)) if index == 0 && /^[^-]/.match(value)
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
      else
        raise "error: unknown predicate `#{value}'"
      end
    end
  end
  
  private
  
  def check_exception(array)
    raise HOW_TO_USE if array.empty?
  end
  
  def find_compress
    return nil if @array.find_index { |value| value == "-c" || value == "--compress" }.nil?
    @array[@array.find_index { |value| value == "-c" || value == "--compress" } + 1]
  end
  
  def check_exist(value)
    raise "error: that element is not found" if value.nil?
  end
  
  def confirm_restore(file)
    puts "#{file}move this file to original path ? [ y / n ]"
    restore(only_name(file)) if STDIN.gets.chomp("\n") == "y"
  end
  
  def move_to_trash(file_name)
    FileUtils.mv(file_name, "#{TRASH_PATH}")
  end
  
  
  def trash_has?(file_name)
    raise "error: no such file or directory in ~/.trash" unless File.exist?("#{TRASH_PATH}/#{file_name}")
    true
  end


  
  def compress
    # すでに圧縮されているファイルは圧縮しない
  end

  def decompress
    # コマンド実行前から圧縮されたいるファイルは解凍しない。
  end
end

class PutTrash
  TRASH_PATH = "#{Dir.home}/.trash"
  
  include Conversionable
  include CsvEditable
  
  attr_reader :file_name
  
  def initialize(file_name)
    check_exception(file_name)
    @file_name = file_name
  end
  
  def check_exception(file_name)
    raise "error: no such file or directory in current directory" if File.exist?(file_name)
  end
  
  def run(method)
    # compress -> ファイル名ごと破壊的に変更
    compress(method,@file_name)
    File.rename(@file_name, modify(@file_name))
    FileUtils.mv(modify(@file_name), TRASH_PATH)
    write([modify(@file_name),Dir.pwd,compressed])
    puts "saved file as #{modify(@file_name)} because same file name exist" unless modify(@file_name) == file_name
  end

  private
  
  def modify
    return @file_name if count_samefile(@file_name) == 0
    @file_name.clone.insert(@file_name.index(".") || -1, "(#{count_samefile(@file_name)})")
  end
  

end

class Restore
  include Conversionable
  include CsvEditable
  
  attr_reader :file_name
  
  def initialize(file_name)
    check_exception(file_name)
    @file_name = file_name
  end
  
  def run_restore(file_name)
    raise "error: error: no such file or directory in ~/.trash" if count_samefile(file_name) == 0
    restore(file_name) if count_samefile(file_name) == 1
    get_samefiles(file_name).each { |file| confirm_restore(file) } unless count_samefile(file_name) == 1
  end
  
  def restore(file_name)
    move_from_trash(file_name)
    write_new_index(erase(file_name))
    # 移動してから解凍
  end
  
  def move_from_trash(file_name)
    FileUtils.mv("#{TRASH_PATH}/#{file_name}", refer_original_path(file_name))
  end
end

class Delete
  include CsvEditable
  
  attr_reader :file_name
  
  def initialize(file_name)
    check_exception(file_name)
    @file_name = file_name
  end
  
  def run(file_name)
    
  end
  
  def all
    puts "Do you really all remove? [ y / n ]"
    FileUtils.rm_r(TRASH_PATH) if STDIN.gets.chomp("\n") == "y"
  end
end

class ViewList
  include CsvEditable
  
  def run_view_list
    make_trash
    puts "~/.trash has not file or directory" if read_csv.empty?
    view_list unless read_csv.empty?
  end
  
  def view_list
    puts "file name\toriginal position"
    puts read_csv
  end
end

if __FILE__ == $0
  TrashHandler.new(ARGV).execute
end

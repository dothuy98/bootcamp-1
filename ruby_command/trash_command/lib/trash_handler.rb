require './lib/csv_editor'
require './lib/trashed_file'
require 'fileutils'

class TrashHandler
  TRASH_PATH = "#{Dir.home}/.trash"
  CSV_PATH = "#{TRASH_PATH}/trashed_info.csv"
  HEADER = ['file_name', 'original_path','compressed?']
  HOW_TO_USE = <<~USAGE
Usage: trash_handler [options] ARGV
    -r, --restore VALUE              restore file to original position from ~/.trash 
    -v, --view                       view file in .trash
    -c, --compress                   compress file or directory by zip format
    -d, --delete VALUE               delete file or directory in ~/.trash 
    --delete-all                     delete all file and directory in ~/.trash
USAGE

  attr_reader :argvs, :editor 
  
  attr_accessor :trashed
  
  def initialize(argvs)
    puts HOW_TO_USE if argvs.empty?
    @csv = CsvEditor.new(CSV_PATH)
    build_settings
    @argvss = argvs
  end
  
  def run
    @argvs.each_with_index do |value, index| 
      dump(value, find_compress) if index < last_index = @argvs.find_index { |index| /^-/.match(index) } || @argvs.size
      next if /^[^-]/.match(value)
      case value
      when "-r","--restore"
        restore(check_exist(@argvs[index +  1]))
      when "-v","--view"
        view
      when "-d", "--delete"
        delete(check_exist(@argvs[index + 1]))
      when "--delete-all"
        delete_all
      when "-c","--compress"
      else
        raise "\nerror: unknown predicate `#{value}'"
      end
    end
  end
  
  private
  
  def build_settings
    Dir.mkdir(TRASH_PATH) unless Dir.exist?(TRASH_PATH)
    @csv.write_newly(HEADER) unless File.exist?(CSV_PATH)
  end
  
  def find_compress
    return nil if @argvs.find_index { |value| value == "-c" || value == "--compress" }.nil?
    # 複数の圧縮形式に対応する場合
    # @array[@array.find_index { |value| value == "-c" || value == "--compress" } + 1]
    'zip'
  end
  
  def check_exist(value)
    raise "\nerror: that element is not found" if value.nil?
    raise "\nerror: that directory or file is not exist in ~/.trash" if @csv.count_samefile(value) == 0
    value
  end
  
  def dump(file, method)
    raise "\nsame file is exist in ~/.trash. plese rename" unless @csv.count_samefile(file) == 0
    raise "\nerror: no '#{file}' in current directory" unless File.exist?(file)
    @trashed = TrashedFile.new(file)
    @trashed.moveto(TRASH_PATH)
    @csv.write([file, "#{Dir.pwd + '/' + file}", method.nil? ? false : method])
    @trashed.compress(method) unless method.nil?
  end
  
  def restore(file)
    @trashed = TrashedFile.new("#{TRASH_PATH}/#{file}")
    @trashed.uncompress(@csv.find_compress_method(file)) if @csv.find_compress_method(file)
    @trashed.moveto(@csv.find_path(file))
    @csv.write_2d_arr(@csv.select_other_than(file))
  end
  
  def view
    return "~/.trash has not file or directory" if @csv.read.empty?
    puts @csv.read.map { |array| array.join("\t") }
  end
  
  def delete(file)
    TrashedFile.new("#{TRASH_PATH}/#{file}").delete
    @csv.write_2d_arr(@csv.select_other_than(file))
  end
  
  def delete_all
    TrashedFile.new(TRASH_PATH).delete
  end
end

if __FILE__ == $0
  TrashHandler.new(ARGV).run
end


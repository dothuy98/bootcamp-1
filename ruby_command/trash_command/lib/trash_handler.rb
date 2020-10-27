require 'fileutils'
require './lib/compressable'
require './lib/argv_splitable'

class TrashHandler
  TRASH_PATH = "#{Dir.home}/.trash"
  INDEX_PATH = "#{TRASH_PATH}/index_file.txt"

  include Compressable
  include ArgvSplitable
  
  attr_reader :file_name, :options
  
  def initialize(array)
    make_trash
    check_exception(array)
    @file_name = extract_filename(array)
    @options = extract_options(array)
    # p @options
  end
    
  def execute
    run_default(@file_name) if @file_name
    run_view_list if @options[:view_list] if @options[:view_list]
    run_restore(@options[:restore]) if @options[:restore]
    run_delete_file(@options[:delete_file]) if @options[:delete_file] 
    run_delete_all if @options[:delete_all]
  end
  
  #private
  
  def run_default(file_name)
    File.rename(file_name, modify(file_name))
    move_to_trash(modify(file_name))
    write_add_index("#{modify(file_name)} : #{Dir.pwd}\n")
    puts "saved file as #{modify(file_name)} because same file name exist" unless modify(file_name) == file_name
  end
  
  def run_restore(file_name)
    raise "error: error: no such file or directory in ~/.trash" if count_samefile(file_name) == 0
    restore(file_name) if count_samefile(file_name) == 1
    get_samefiles(file_name).each { |file| confirm_restore(file) } unless count_samefile(file_name) == 1
  end
  
  def restore(file_name)
    move_from_trash(file_name)
    write_new_index(erase(file_name))
  end
  
  def confirm_restore(file)
    puts "#{file}move this file to original path ? [ y / n ]"
    restore(only_name(file)) if STDIN.gets.chomp("\n") == "y"
  end
  
  def run_view_list
    make_trash
    puts "~/.trash has not file or directory" if read_index_texts.empty?
    view_list unless read_index_texts.empty?
  end
  
  def run_delete_file(file_name)
    
  end
  
  def run_delete_all
    puts "Do you really all remove? [ y / n ]"
    FileUtils.rm_r(TRASH_PATH) if STDIN.gets.chomp("\n") == "y"
  end
  
  # parts methods for run
  
  def make_trash
    Dir.mkdir(TRASH_PATH) unless Dir.exist?(TRASH_PATH)
    FileUtils.touch(INDEX_PATH) unless File.exist?(INDEX_PATH)
  end
  
  def trash_has?(file_name)
    raise "error: no such file or directory in ~/.trash" unless File.exist?("#{TRASH_PATH}/#{file_name}")
    true
  end
  
  def view_list
    # 圧縮したかどうかも表示 > if_compress.txt
    puts "file name\toriginal position"
    puts read_index_texts
  end
  
  def move_to_trash(file_name)
    FileUtils.mv(file_name, "#{TRASH_PATH}")
  end
  
  def move_from_trash(file_name)
    FileUtils.mv("#{TRASH_PATH}/#{file_name}", refer_original_path(file_name))
  end
  
  def write_add_index(string)
    File.open(INDEX_PATH, mode = "a") { |file| file.write(string) }
  end
  
  def write_new_index(array)
    File.open(INDEX_PATH, "w") do |file|
      array.each { |value| file.puts(value) }
    end
  end
  
  def read_index_texts
    File.open(INDEX_PATH).readlines
  end
  
  def erase(file_name)
    read_index_texts.map { |line| line unless only_name(line) == file_name }.compact
  end 
  
  # if same file or directory is exist in ~/.trash, rename file
  def modify(file_name)
    if count_samefile(file_name) == 0
      file_name
    else
      file_name.clone.insert(file_name.index(".") || -1, "(#{count_samefile(file_name)})")
    end
  end
  
  def count_samefile(file_name)
    read_index_texts.count { |line| only_name(line).gsub(/(\(\d\))/,'') == file_name }
  end
  
  def get_samefiles(file_name)
    read_index_texts.select { |line| only_name(line).gsub(/(\(\d\))/,'') == file_name }
  end
  
  def refer_original_path(file_name)
    read_index_texts.find { |line| only_name(line) == file_name }.gsub(/.* : (.*)/, '\1').chomp("\n")
  end
  
  def only_name(text)
    text.gsub(/(.*) : .*/, '\1').chomp("\n")
  end
  
  def compress
    # すでに圧縮されているファイルは圧縮しない
  end

  def decompress
    # コマンド実行前から圧縮されたいるファイルは解凍しない。
  end
end

if __FILE__ == $0
  TrashHandler.new(ARGV).execute
end

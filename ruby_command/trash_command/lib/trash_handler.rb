require 'fileutils'
require './lib/compressable'
require './lib/argv_splitable'

class TrashHandler
  TRASH_PATH = "#{Dir.home}/.trash"
  INDEX_PATH = "#{TRASH_PATH}/index_file.txt"

  include Compressable
  include ArgvSplitable

  def execute
    options, arguments = parse_options(ARGV) 
    view_list_run if options[:view_list]
    restore_run(options[:restore]) if !options[:restore].empty?
    p arguments[0]
    default_run(arguments[0]) if arguments[0]
    delete(options) if !options[:delete_file].empty? || options[:all_delete]
  end

  def default_run(file_name)
    make_trash
    modify_filename(file_name)
    move_to_trash(file_name)
    write_index(file_name)
  end
  
  def restore_run(file_name)
    file_name = delete_slash(file_name)
    move_from_trash(file_name)
    erase_file_name(file_name)
  end
  
  def view_list_run
    print_no_indexfile if read_index_texts.empty?
    view_list
  end
  
  def modify_filename(file_name)
    file_name = add_number_to_filename(where_extension(file_name)) if count_samefile(file_name) != 0
  end
  
  def move_to_trash(file_name)
    FileUtils.mv(file_name, "#{TRASH_PATH}")
  end
  
  def trash_has?(file_name)
    File.exist?("#{TRASH_PATH}/#{file_name}")
  end
  
  def make_trash
    Dir.mkdir(TRASH_PATH) unless Dir.exist?(TRASH_PATH)
    FileUtils.touch(INDEX_PATH) unless File.exist?(INDEX_PATH)
  end
  
  def count_samefile(file_name)
    read_index_texts.count { |line| line.include?(file_name) }
  end
  
  def where_extension(file_name)
    file_name.index(".") || -1
  end
  
  def add_number_to_filename(number)
    file_name.insert(index, "(#{number})")
  end
  
  def write_index(file_name)
    File.open(INDEX_PATH, mode = "a") { |file| file.write("#{file_name}\t#{Dir.pwd}\n") }
  end
  
  def read_index_texts
    index_tests = File.open(INDEX_PATH).readlines
  end
  
  def refer_original_path(file_name)
    paht = read_index_texts.find { |line| line.include?(file_name) }.gsub(/#{file_name}\s*/, '').chomp
  end
  
  def erase_file_name(file_name)
    modified_text = read_index_texts.map { |line| line unless line.include?(file_name) }.compact
    open(INDEX_PATH, "w") { |file| file.write(modified_text) }
  end 

  def move_from_trash(file_name)
    FileUtils.mv("#{TRASH_PATH}/#{file_name}", refer_original_path(file_name))
  end

  def view_list
    # 圧縮したかどうかも表示 > if_compress.txt
    puts "file name\toriginal position"
    puts read_index_texts
  end
  
  def print_no_indexfile
    puts "~/.trash file has not file or directory"
    exit 1
  end

  def compress
    # すでに圧縮されているファイルは圧縮しない
  end

  def decompress
    # コマンド実行前から圧縮されたいるファイルは解凍しない。
  end
end


TrashHandler.new.execute

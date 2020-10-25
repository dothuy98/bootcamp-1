require 'fileutils'
require './lib/compress_module'

class TrashCommand
  TRASH_PATH = "#{Dir.home}/.trash"
  INDEX_FILE = "#{TRASH_PATH}/index_file.txt"
  extend CompressModule

  def  initialize
    # @file_name = file_name
    Dir.mkdir(TRASH_PATH) unless Dir.exists?(TRASH_PATH)
  end

  def view_help
      text = ""
      File.open("./usage.txt") { |file| text = file.read }
      text
  end

  def move_to_trash(file_name)
    FileUtils.mv(file_name, "#{TRASH_PATH}/.")
    File.open(INDEX_FILE, mode = "a") do |file|
      file.write("#{file_name}\t#{Dir.pwd}\n")
    end
  end

  def restore(file_name)
    original_position = ""
    modified_text = ""
    IO.foreach(INDEX_FILE) do |line|
      original_position = line.gsub(/#{file_name}\s*/, '').chomp if line.include?(file_name)
      modifiled_text << line unless line.include?(file_name)
    end
    FileUtils.mv("#{TRASH_PATH}/#{file_name}", original_position)
    open(INDEX_FILE, "w") { |file| file.write(modified_text) }
  end

  def view_list
    # 圧縮したかどうかも表示 > if_compress.txt
    puts "file name\toriginal position"
    File.open(INDEX_FILE) { |file| text = file.read } 
    text
  end

  def compress
    # すでに圧縮されているファイルは圧縮しない
  end

  def decompress
    # コマンド実行前から圧縮されたいるファイルは解凍しない。
  end

end

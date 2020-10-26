require 'fileutils'
require 'optparse'
require './lib/compressable'

class TrashHandler
  TRASH_PATH = "#{Dir.home}/.trash"
  INDEX_FILE = "#{TRASH_PATH}/index_file.txt"

  extend Compressable

  def parse_options(argv = ARGV)
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

    option.on('-r','--restore [VALUE]', "restore file to original position from ~/.trash (default: #{options[:restore]}") do |value| 
      options[:restore] = value.nil? ? "to_argument" : value
    end
    option.on('-v','--view', "view file in .trash (default: #{options[:view_list]}") do |value| 
      options[:view_list] = value
    end
    option.on('-c', '--compress [VALUE]', "compress file or directory (default: #{options[:compress_method]}" ) do |value|
      options[:compress_mothod] = value.nil? ? "zip" : value
    end
    option.on('-d', '--delete [VALUE]', "delete file or directory in ~/.trash (default: #{options[:delete_file]}" ) do |value|
      options[:compress_mothod] = value.nil? ? "to_argument" : value
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
    [options, arguments]
  end

  public

  def run
    options, arguments = parse_options
    puts "#{options}"
    puts "#{arguments}"
    view_list if options[:view_list]
    if options[:restore] == "to_argument"
      restore(arguments[0])
      exit 0
    end
    restore(options[:restore]) if !options[:restore].empty? && trash_has?(options[:restore])

    unless files_exist?(arguments)
      error('arguments include non-existent file or directory') unless files_exist?(arguments)
      exit 1 
    end
    arguments.each { |file_name| move_to_trash(file_name) }
  end

  def files_exist?(file_names)
    boolen = true
    file_names.each do |file_name|
      unless File.exist?(file_name)
        boolen = false
        break
      end
    end
    boolen
  end

  def trash_has?(file_name)
    File.exist?("#{TRASH_PATH}/#{file_name}")
  end

  def indexfile_exist?
    if File.exist?(INDEX_FILE)
      true
    else
      puts "~/.trash directory don't have file or directory" 
      false
    end
  end

  def error(text)
    puts "error: #{text}"
    exit 1
  end

  def move_to_trash(file_name)
    Dir.mkdir(TRASH_PATH) unless Dir.exists?(TRASH_PATH)
    FileUtils.mv(file_name, "#{TRASH_PATH}/.")
    File.open(INDEX_FILE, mode = "a") do |file|
      file.write("#{file_name}\t#{Dir.pwd}\n")
    end
  end

  def restore(file_name)
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
    exit 0 if indexfile_exist?
    puts "file name\toriginal position"
    File.open(INDEX_FILE) { |file| text = file.read } 
    if text.empty?
      puts "~/.trash directory don't have file or directory"
    else
      puts text
    end
  end

  def compress
    # すでに圧縮されているファイルは圧縮しない
  end

  def decompress
    # コマンド実行前から圧縮されたいるファイルは解凍しない。
  end
end

TrashHandler.new::run

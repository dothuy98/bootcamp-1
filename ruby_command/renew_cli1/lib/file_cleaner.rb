require './lib/argv_extractor'
require './lib/file_processable'
require './lib/csv_manager'

class FileCleaner
  
  include FileProcessable
  
  TRASHED_FILES_PATH = "#{Dir.home}/.trash"
  CLEAN_LOG_PATH = "#{TRASHED_FILES_PATH}/.trashed_log.csv"
  CLEAN_HEADER = ['file_name', 'original_path']
  HOW_TO_USE = <<~USAGE
  Usage: ruby file_cleaner.rb file_name1 [file_name2 ...] [option]
  
  Temporarily save the file you want to delete to prevent accidental deletion.
  store directory : ~/.trash
  
  Option: 
    -r, --restore <trashed_file>      restore file to original position from ~/.trash 
    -v, --view                        view file in .trash
    -d, --delete <trashed_file>       delete file or directory in ~/.trash 
    --delete-all                      delete all file and directory in ~/.trash
USAGE

  def initialize(file_names, option)
    @file_names = file_names
    @option = option
    @csv_manager = CsvManager.new(CLEAN_LOG_PATH)
  end
  
  def run
    build_settings
    raise 'error: please specify the file name' if @file_names.empty? && @option.nil?
    
    clean
    process_file
    adopt_option
  end
  
  def adopt_option
    return puts HOW_TO_USE if @option == 'help'
    return view_trash if @option == 'view'
    return system("rm -rf #{TRASHED_FILES_PATH}") if @option == 'delete-all' 
  end
  
  def clean
    return nil unless @option.nil?
    
    @file_names.each do |file_name|
      raise "same file is exist in ~/.trash. plese rename." if File.exist?("#{TRASHED_FILES_PATH}/#{file_name}")
      raise "error: no '#{file_name}' in current directory." unless File.exist?(file_name)
      
      move_to_trash(file_name)
      @csv_manager.write([file_name, File.expand_path(file_name)])
    end
  end
  
  def process_file
    return nil unless @option == 'restore' || @option == 'delete'
    
    @file_names.each do |file_name|
      raise "does not exist in such a file" unless File.exist?("#{TRASHED_FILES_PATH}/#{file_name}")
      
      restore(file_name, @csv_manager.find_path(file_name)) if @option == 'restore'
      delete(file_name) if @option == 'delete'
      @csv_manager.update(file_name, CLEAN_HEADER)
    end
  end
  
  def view_trash
    puts CLEAN_HEADER.join("\t")
    @csv_manager.read.each { |texts| puts texts.values.join("\t") }
  end
  
  def build_settings
    Dir.mkdir(TRASHED_FILES_PATH) unless Dir.exist?(TRASHED_FILES_PATH)
    @csv_manager.create(CLEAN_HEADER) unless File.exist?(CLEAN_LOG_PATH)
  end
  
end

if __FILE__ == $0
  FileCleaner.new(ArgvExtractor.select_file_names(ARGV), ArgvExtractor.find_option(ARGV)).run
end
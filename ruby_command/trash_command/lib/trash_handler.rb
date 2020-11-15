require './lib/csv_manager'
require './lib/trashed_file'
require './lib/argv_formater'
require 'fileutils'

class TrashHandler
  
  TRASH_PATH = "#{Dir.home}/.trash"
  TRASHED_LOG_PATH = "#{TRASH_PATH}/.trashed_log.csv"
  HEADER = ['file_name', 'original_path']
  HOW_TO_USE = <<~USAGE
  Usage: trash_handler [options] file_name
  Temporarily save the file you want to delete to prevent accidental deletion.
  store directory : ~/.trash
    -r, --restore trashed_file        restore file to original position from ~/.trash 
    -v, --view                        view file in .trash
    -d, --delete trashed_file         delete file or directory in ~/.trash 
    --delete-all                      delete all file and directory in ~/.trash
USAGE
  
  attr_accessor :csv_manager, :options
  
  def initialize(options: {})
    @csv_manager = CsvManager.new(TRASHED_LOG_PATH)
    build_settings
    @options = options
  end
  
  def run(file_names: [])
    puts HOW_TO_USE if file_names.empty? && options.empty?
    dump(file_names)
    apply_options
  end
  
  private
  
  def apply_options
    @options.each do |parameter, option| 
      case parameter
      when "-r", "--restore"
        restore(check_exist(option))
      when "-v", "--view"
        view
      when "-d", "--delete"
        delete(check_exist(option))
      when "--delete-all"
        delete_all
      when "-h", "--help"
        puts HOW_TO_USE
      else
        raise "error: unknown predicate `#{parameters}'"
      end
    end
  end
  
  def check_exist(file_name)
    raise "error: that options's argument is not found" if file_name.nil?
    raise "error: that directory or file is not exist in ~/.trash" if @csv_manager.count_samefile(file_name) == 0
    file_name
  end
  
  def build_settings
    Dir.mkdir(TRASH_PATH) unless Dir.exist?(TRASH_PATH)
    @csv_manager.create(HEADER) unless File.exist?(TRASHED_LOG_PATH)
  end
  
  def dump(file_names)
    file_names.each do |file_name| 
      raise "same file is exist in ~/.trash. plese rename" unless @csv_manager.count_samefile(file_name) == 0
      raise "error: no '#{file_name}' in current directory" unless File.exist?(file_name)
      trashed_file = TrashedFile.new(file_name, File.expand_path(file_name))
      trashed_file.move_to(TRASH_PATH)
      @csv_manager.write(trashed_file.parameters)
    end
  end
  
  def restore(file_name)
    trashed_file = TrashedFile.new("#{TRASH_PATH}/#{file_name}")
    trashed_file.move_to(@csv_manager.find_matchline(file_name)['original_path'])
    @csv_manager.update(@csv_manager.select_other_than(file_name), HEADER)
  end
  
  def view
    puts HEADER.join("\t")
    @csv_manager.read.each { |texts| puts texts.values.join("\t") }
  end
  
  def delete(file_name)
    TrashedFile.new("#{TRASH_PATH}/#{file_name}").delete
    @csv_manager.update(@csv_manager.select_other_than(file_name), HEADER)
  end
  
  def delete_all
    FileUtils.rm_r(TRASH_PATH)
  end
  
end

if __FILE__ == $0
  argv_formater = ArgvFormater.new(ARGV)
  TrashHandler.new(options: argv_formater.options).run(file_names: argv_formater.file_names)
end

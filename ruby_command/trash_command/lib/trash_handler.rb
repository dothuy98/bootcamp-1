require './lib/csv_log'
require './lib/trashed_file'
require './lib/argv_formater.rb'
require 'fileutils'

class TrashHandler
  
  TRASH_PATH = "#{Dir.home}/.trash"
  CSV_PATH = "#{TRASH_PATH}/.trashed_log.csv"
  HEADER = ['file_name', 'original_path']
  HOW_TO_USE = <<~USAGE
  Usage: trash_handler [options] file_name
    -r, --restore trashed_file        restore file to original position from ~/.trash 
    -v, --view                        view file in .trash
    -d, --delete trashed_file         delete file or directory in ~/.trash 
    --delete-all                      delete all file and directory in ~/.trash
USAGE
  
  attr_accessor :log, :options
  
  def initialize(options: {})
    @trash_log = CsvLog.new(CSV_PATH)
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
      when "-r","--restore"
        restore(check_exist(option))
      when "-v","--view"
        view
      when "-d", "--delete"
        delete(check_exist(option))
      when "--delete-all"
        delete_all
      else
        raise "error: unknown predicate `#{value}'"
      end
    end
  end
  
  def check_exist(file_name)
    raise "error: that options's argument is not found" if file_name.nil?
    raise "error: that directory or file is not exist in ~/.trash" if @trash_log.count_samefile(file_name) == 0
    file_name
  end
  
  def build_settings
    Dir.mkdir(TRASH_PATH) unless Dir.exist?(TRASH_PATH)
    @trash_log.create(HEADER) unless File.exist?(CSV_PATH)
  end
  
  def dump(file_names)
    file_names.each do |file_name| 
      raise "same file is exist in ~/.trash. plese rename" unless @trash_log.count_samefile(file_name) == 0
      raise "error: no '#{file_name}' in current directory" unless File.exist?(file_name)
      trashed_file = TrashedFile.new(file_name, File.expand_path(file_name))
      trashed_file.move_to(TRASH_PATH)
      @trash_log.write(trashed_file.parameters)
    end
  end
  
  def restore(file_name)
    trashed_file = TrashedFile.new("#{TRASH_PATH}/#{file_name}", nil)
    trashed_file.move_to(@trash_log.find_matchline(file_name)['original_path'])
    @trash_log.update(@trash_log.select_other_than(file_name), HEADER)
  end
  
  def view
    puts HEADER.join("\t")
    @trash_log.read.each { |texts| puts texts.values.join("\t") }
  end
  
  def delete(file_name)
    TrashedFile.new("#{TRASH_PATH}/#{file_name}").delete
    @trash_log.update(@trash_log.select_other_than(file_name), HEADER)
  end
  
  def delete_all
    FileUtils.rm_r(TRASH_PATH)
  end
  
end

if __FILE__ == $0
  argv = ArgvFormater.new(ARGV)
  TrashHandler.new(options: argv.options).run(file_names: argv.arguments)
end



require './lib/csv_data'
require './lib/trashed_file'
require './lib/argv_formatter.rb'
require 'fileutils'

class TrashHandler
  
  TRASH_PATH = "#{Dir.home}/.trash"
  CSV_PATH = "#{TRASH_PATH}/trashed_log.csv"
  HEADER = ['file_name', 'original_path', 'compressed']
  HOW_TO_USE = <<~USAGE
  Usage: trash_handler [options] file_name
    -r, --restore trashed_file        restore file to original position from ~/.trash 
    -v, --view                        view file in .trash
    -c, --compress [compress_method]  compress file or directory by zip format (default: zip)
    -d, --delete trashed_file         delete file or directory in ~/.trash 
    --delete-all                      delete all file and directory in ~/.trash
USAGE
  
  attr_accessor :method, :log, :options
  
  def initialize(options: [])
    @log = CsvData.new(CSV_PATH)
    build_settings
    @options = options
    @method = find_compress(options)
  end
  
  def run(file_names: [])
    puts HOW_TO_USE if file_names.empty? && options.empty?
    dump(file_names)
    apply_options(@options)
  end
  
  private
  
  def find_compress(options)
    return nil unless options.any? { |option| /^-{1,2}c/.match(option) }
    options[options.find_index { |option| /^-{1,2}c/.match(option) } + 1] || 'zip'
  end
  
  def apply_options(options)
    options.each_with_index do |option, index| 
      next if /^[^-]/.match(option) || /^-{1,2}c/.match(option)
      case option
      when "-r","--restore"
        restore(check_exist(options[index +  1]))
      when "-v","--view"
        view
      when "-d", "--delete"
        delete(check_exist(options[index + 1]))
      when "--delete-all"
        delete_all
      else
        raise "error: unknown predicate `#{value}'"
      end
    end
  end
  
  def build_settings
    Dir.mkdir(TRASH_PATH) unless Dir.exist?(TRASH_PATH)
    @log.create(HEADER) unless File.exist?(CSV_PATH)
  end
  
  def check_exist(value)
    raise "error: that options's argument is not found" if value.nil?
    raise "error: that directory or file is not exist in ~/.trash" if @log.count_samefile(value) == 0
    value
  end
  
  def dump(file_names)
    file_names.each do |file_name| 
      raise "same file is exist in ~/.trash. plese rename" unless @log.count_samefile(file_name) == 0
      raise "error: no '#{file_name}' in current directory" unless File.exist?(file_name)
      trashed_file = TrashedFile.new(file_name, File.expand_path(file_name), @method)
      trashed_file.move_to(TRASH_PATH)
      @log.write(trashed_file.info)
      trashed_file.compress unless @method.nil?
    end
  end
  
  def restore(file_name)
    trashed_file = TrashedFile.new("#{TRASH_PATH}/#{file_name}", nil, @log.find_matchline(file_name)['compressed'])
    trashed_file.uncompress unless @log.find_matchline(file_name)['compressed'] == 'nil'
    trashed_file.move_to(@log.find_matchline(file_name)['original_path'])
    @log.update(@log.select_other_than(file_name), HEADER)
  end
  
  def view
    puts HEADER.join("\t")
    @log.read.each { |texts| puts texts.values.join("\t") }
  end
  
  def delete(file_name)
    TrashedFile.new("#{TRASH_PATH}/#{file_name}").delete
    @log.update(@log.select_other_than(file_name), HEADER)
  end
  
  def delete_all
    FileUtils.rm_r(TRASH_PATH)
  end
  
end

if __FILE__ == $0
  argv = ArgvFromatter.new(ARGV)
  TrashHandler.new(options: argv.options).run(file_names: argv.arguments)
end



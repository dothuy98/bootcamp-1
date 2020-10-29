require './lib/csv_data'
require './lib/trashed_file'
require 'fileutils'

class TrashHandler
  
  TRASH_PATH = "#{Dir.home}/.trash"
  CSV_PATH = "#{TRASH_PATH}/trashed_log.csv"
  HEADER = ['file_name', 'original_path','compressed']
  
  attr_accessor :trashed_file, :method, :log
  
  def initialize(options: [])
    build_settings
    apply_options(options)
  end
  
  def run(file_names: [])
    file_names.each { |file_name| dump(file_name) }
  end
  
  private
  
  def apply_options(options)
    options.each_with_index do |value, index| 
      next if /^[^-]/.match(value)
      case value
      when "-r","--restore"
        restore(check_exist(options[index +  1]))
      when "-v","--view"
        view
      when "-d", "--delete"
        delete(check_exist(options[index + 1]))
      when "--delete-all"
        delete_all
      when "-c","--compress"
        @method = options[index + 1] || 'zip'
      else
        raise "error: unknown predicate `#{value}'"
      end
    end
    
  end
  
  def build_settings
    @log = CsvData.new(CSV_PATH)
    Dir.mkdir(TRASH_PATH) unless Dir.exist?(TRASH_PATH)
    @log.create(HEADER) unless File.exist?(CSV_PATH)
  end
  
  def check_exist(value)
    raise "error: that options's argument is not found" if value.nil?
    raise "error: that directory or file is not exist in ~/.trash" if @log.count_samefile(value) == 0
    value
  end
  
  def dump(file_name)
    raise "same file is exist in ~/.trash. plese rename" unless @log.count_samefile(file_name) == 0
    raise "error: no '#{file_name}' in current directory" unless File.exist?(file_name)
    trashed_file = TrashedFile.new(file_name, File.expand_path(file_name), @method)
    trashed_file.move_to(TRASH_PATH)
    @log.write(trashed_file.info)
    trashed_file.compress unless @method.nil?
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
  TrashHandler.new(ARGV).run
end


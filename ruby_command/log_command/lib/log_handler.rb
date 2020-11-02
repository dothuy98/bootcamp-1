require './lib/argv_formatter'
require './lib/time_measurer'
require './lib/csv_manager'

class LogHandler
  
  HEADER = ['id', 'log_at', 'elapsed_time', 'message']
  LOG_PATH = "#{Dir.home}/.command_log.csv"
  HOW_TO_USE = <<~USAGE
  Usage: ruby ./lib/log_handler.rb [options] message
    always log message and current directory with the date and time.
    (options)
    -v, --view [how_view]         view log. (default: all)
    ex) -v 3 : view 3 line from new log.
        -v r : view all in reverse order
    -i, --id id_number             find id and print message.
USAGE
  
  attr_reader :options, :csv_manager
  
  def initialize(options: {})
    @options = options
    @csv_manager = CsvManager.new(LOG_PATH)
    @csv_manager.create(HEADER) unless File.exist?(LOG_PATH)
  end
  
  def run(message: nil)
    log(message)
    apply_options
  end
  
  private
  
  def log(message)
    return unless @options.empty?
    message = Dir.pwd if message == "."
    time_measurer = TimeMeasurer.new
    @csv_manager.add([@csv_manager.count_line, time_measurer.time, time_measurer.passed_since(@csv_manager.last_line['log_at']), message])
  end
  
  def apply_options
    @options.each do |parameter, option| 
      case parameter
      when "-v", "--view"
        view_log(option)
      when "-i", "--id"
        find_id(option)
      when "-r", "--reset"
        delete_log
      else
        raise "error: unknown predicate `#{parameter}'"
      end
    end
  end
  
  def view_log(option = nil)
    puts HEADER.join("\t")
    log_texts = @csv_manager.read.map { |log| log.values.join("\t") }
    log_texts.reverse! if option.include?("r")
    log_texts.slice!($~[1].to_i..) if option =~ /([0-9]+)/
    puts log_texts
  end
  
  def find_id(option = nil)
    raise "add id_number after '-i' or '--id'" if option.nil?
    raise "such id_number is not exist" if @csv_manager.count_line <= option.to_i
    puts @csv_manager.read.find { |log| log['id'] == option }['message']
  end
  
  def delete_log
    File.delete(LOG_PATH)
  end
  
end

if __FILE__ == $0
  argv_formatter = ArgvFormatter.new(ARGV)
  LogHandler.new(options: argv_formatter.options).run(message: argv_formatter.message)
end
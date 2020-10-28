require 'csv'

module CsvEditable
  TRASH_PATH = "#{Dir.home}/.trash"
  CSV_PATH = "#{TRASH_PATH}/name_and_original_path.csv"
  HEADER = ['file_name', 'original_path','compress_method']
  
  def build_settings
    Dir.mkdir(TRASH_PATH) unless Dir.exist?(TRASH_PATH)
    FileUtils.touch(CSV_PATH) unless File.exist?(CSV_PATH)
    File.open(CSV_PATH, "w") { |csv| csv << HEADER } unless File.exist?(CSV_PATH)
  end
  
  def write(array)
    File.open(CSV_PATH, "a") { |csv| csv << array }
  end
  
  def write_2d_arr(array_in_array)
    CSV.open(CSV_PATH, "w") do |csv|
      array_in_array.each { |array| csv << array }
    end
  end
  
  # 2次元配列
  def read
    CSV.read(CSV_PATH)
  end
  
  def erase(file_name)
    read.map { |line| line unless only_name(line) == file_name }.compact
  end 
  
  def count_samefile(file_name)
    read.count { |line| line[0].include(file_name) }
  end
  
  def select_samefile(file_name)
    read.select { |line| only_name(line).gsub(/(\(\d\))/,'') == file_name }
  end
  
  def find_original_path(file_name)
    read.find { |line| only_name(line) == file_name }.gsub(/.* : (.*)/, '\1').chomp("\n")
  end
  
  def only_name(text)
    text.gsub(/(.*) : .*/, '\1').chomp("\n")
  end
end

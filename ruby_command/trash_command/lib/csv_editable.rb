require 'csv'

module CsvEditable
  TRASH_PATH = "#{Dir.home}/.trash"
  CSV_PATH = "#{TRASH_PATH}/name_and_original_path.csv"
  HEADER = ['file_name', 'original_path','compressed?']
  
  def build_settings
    Dir.mkdir(TRASH_PATH) unless Dir.exist?(TRASH_PATH)
    CSV.open(CSV_PATH, "w") { |csv| csv << HEADER } unless File.exist?(CSV_PATH)
  end
  
  def write(array)
    CSV.open(CSV_PATH, "a") { |csv| csv << array }
  end
  
  def write_2d_arr(array_in_array)
    CSV.open(CSV_PATH, "w") do |csv|
      array_in_array.each { |array| csv << array }
    end
  end
  
  def read
    CSV.read(CSV_PATH)
  end
 
  def count_samefile(file_name)
    read.count { |line| line[0].gsub(/\(\d\)/,'') == file_name } 
  end
  
  def select_other_than(file_name)
    read.select { |line| line[0] != file_name }
  end
  
  def find_matchline(file_name)
    read.find { |line| line[0] == file_name }
  end
  
  def find_name(file_name)
    find_matchline(file_name)[0]
  end
  
  def find_path(file_name)
    find_matchline(file_name)[1]
  end
  
  def find_compressed?(file_name)
    return false if find_matchline(file_name)[2] == "false"
    true 
  end
  
end

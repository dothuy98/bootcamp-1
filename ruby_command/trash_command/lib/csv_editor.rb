require 'csv'

class CsvEditor
  
  attr_reader :path
    
  def initialize(path)
    @path = path
  end
  
  def write_newly(texts)
    CSV.open(@path, "w") { |csv| csv << texts }
  end
  
  def write(texts)
    CSV.open(@path, "a") { |csv| csv << texts }
  end
  
  def write_2d_arr(array_in_texts)
    CSV.open(@path, "w") do |csv|
      array_in_texts.each { |text| csv << texts }
    end
  end
  
  def read
    CSV.read(@path)
  end
  
  def count_samefile(target_file)
    read.count { |line| line.first.gsub(/\(\d\)/,'') == target_file } 
  end
  
  def select_other_than(extra_file)
    read.select { |line| line.first != extra_file }
  end
  
  def find_matchline(target_file)
    read.find { |line| line.first == target_file }
  end
  
  def find_path(target_file)
    find_matchline(target_file)[1]
  end
  
  def find_compress_method(target_file)
    return false if find_matchline(target_file)[2] == "false"
    find_matchline(target_file)[2]
  end
  
end
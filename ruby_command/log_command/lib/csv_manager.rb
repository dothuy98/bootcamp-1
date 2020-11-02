require 'csv'

class CsvManager

  def initialize(file_path)
    @file_path = file_path
  end

  def create(headers)
    CSV.open(@file_path, "w") { |csv| csv << headers }
  end

  def add(texts)
    CSV.open(@file_path, "a") { |csv| csv << texts }
  end

  def read
    CSV.read(@file_path, headers: true).map(&:to_hash)
  end
  
  def count_line
    CSV.read(@file_path, headers: true).count
  end
  
  def last_line
    return {} if count_line == 0
    read.last
  end
  
end 
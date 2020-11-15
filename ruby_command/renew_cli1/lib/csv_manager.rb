require 'csv'

class CsvManager
  
  def initialize(csv_path)
    @csv_path = csv_path
  end

  def create(headers)
    CSV.open(@csv_path, "w") { |csv| csv << headers }
  end

  def write(texts)
    CSV.open(@csv_path, "a") { |csv| csv << texts }
  end
  
  def read
    CSV.read(@csv_path, headers: true).map(&:to_hash)
  end 

  def update(file_name, headers)
    tmp_texts = read
    CSV.open(@csv_path, "w") do |csv|
      csv << headers
      tmp_texts.each do |texts| 
        next if texts['file_name'] == file_name
        csv << texts.values
      end
    end
  end
  
  def find_path(file_name)
    read.find { |line| line['file_name'] == file_name }.fetch('original_path')
  end
  
end
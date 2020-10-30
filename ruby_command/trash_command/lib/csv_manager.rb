require 'csv'

class CsvManager

  def initialize(file_path)
    @file_path = file_path
  end

  def create(headers)
    CSV.open(@file_path, "w") { |csv| csv << headers }
  end

  def write(texts)
    CSV.open(@file_path, "a") { |csv| csv << texts }
  end

  def update(array_in_texts, headers)
    CSV.open(@file_path, "w") do |csv|
      csv << headers
      array_in_texts.each { |texts| csv << texts.values }
    end
  end

  def read
    CSV.read(@file_path, headers: true).map(&:to_hash)
  end

  def count_samefile(target_file)
    read.count { |line| line['file_name'] == target_file } 
  end

  def select_other_than(extra_file)
    read.select { |line| line['file_name'] != extra_file }
  end

  def find_matchline(target_file)
    read.find { |line| line['file_name'] == target_file }
  end

end 
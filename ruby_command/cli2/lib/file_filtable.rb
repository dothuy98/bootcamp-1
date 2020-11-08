module FileFiltable
  
  def include_file?(words)
    words.any? { |word| File.file?(word) }
  end
  
  def extract_texts(file_names)
    text = ""
    file_names.each do |file_name|
      next unless File.file?(file_name)
      text += File.read(file_name)
    end
    text.gsub("\n", '')
  end
  
end
module FileFiltable
  
  def include_file?(words)
    words.any? { |word| File.file?(word) }
  end
  
  def extract_text(file_name)
    File.read(file_name).gsub("\n", '')
  end
  
end
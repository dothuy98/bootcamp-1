module FileFiltable
  
  def extract_text(file_name)
    File.read(file_name).gsub("\n", '')
  end
  
end
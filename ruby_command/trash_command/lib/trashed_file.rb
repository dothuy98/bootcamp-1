class TrashedFile
  
  attr_accessor :file_name, :file_path
  
  def initialize(file_name, file_path = nil)
    @file_name = file_name
    @file_path = file_path
  end
  
  def move_to(file_path)
    system("mv #{@file_name} #{file_path}")
  end
  
  def delete
    FileUtils.rm_r(@file_name)
  end
  
  def parameters
    [@file_name, @file_path]
  end
  
end

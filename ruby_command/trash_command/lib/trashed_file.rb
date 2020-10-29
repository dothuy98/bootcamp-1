class TrashedFile
  
  TRASH_PATH = "#{Dir.home}/.trash"
  
  attr_accessor :file_name, :file_path, :method
  
  def initialize(file_name, file_path = nil, method = nil)
    @file_name = file_name
    @file_path = file_path
    @method = method
  end
  
  def move_to(file_path)
    system("mv #{@file_name} #{file_path}")
  end
  
  def delete
    FileUtils.rm_r(@file_name)
  end
  
  def compress
    file_name = "#{TRASH_PATH}/#{@file_name}"
    system("zip -r #{file_name + '.' + @method} #{file_name}")
  end
  
  def uncompress
    raise "error: unsupported extension" unless @method == "zip"
    system("unzip #{@file_name + '.' + @method}")
  end
  
  def info
    [@file_name, @file_path, @method.nil? ? 'nil' : @method]
  end
  
end
class TrashedFile
  TRASH_PATH = "#{Dir.home}/.trash"
  
  attr_reader :file
  
  def initialize(file)
    @file = file
  end
  
  def moveto(path)
    raise unless system("mv #{@file} #{path}")
  end
  
  def delete
    FileUtils.rm_r(@file)
  end
  
  def delete_all
    FileUtils.rm_r(@TRASH_PATH)
  end
  
  def compress(method)
    file = "#{TRASH_PATH}/#{@file}"
    case method
    when "zip"
      system("zip -r #{add_extension(file, method)} #{file}")
    else
      raise "does not support this compression method"
    end
  end
  
  def uncompress(method)
    case method
    when "zip"
      system("unzip #{add_extension(@file, method)}")
    else
      raise "\nerror: unsupported extension"
    end
  end
  
  private
  
  def add_extension(file, method)
    "#{file}.#{method}"
  end
  
end
module FileProcessable

  TRASHED_FILES_PATH = "#{Dir.home}/.trash"
  
  def move_to_trash(file_name)
    system("mv #{file_name} #{TRASHED_FILES_PATH}")
  end

  def restore(file_name, file_path)
    system("mv #{TRASHED_FILES_PATH}/#{file_name} #{file_path}")
  end
  
  def delete(file_name)
    system("rm -rf #{TRASHED_FILES_PATH}/#{file_name}")
  end
  
end

class FileCleaner
  
  def initialize(orders)
    @orders = orders
    @option = find_option
  end
  
  def find_option
    return nil if /^-/.match(@orders)
  end
  
  def run
    # help
    # view
    move_to(target_path)
  end
  
  def move_to
    # delete
    # restore
    # move trash
  end
  
  def target_path
    
  end
  
  def 
  
  
  
end
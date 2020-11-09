class FileCleaner
  
  def initialize(orders)
    @orders = orders
    @option = find_option
  end
  
  def find_option
    return 'move_to_trash' unless /^-/.match(@orders)
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
    # @optionによって移動先のpathを変える
  end
  
end
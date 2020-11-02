class ArgvFormatter
  
  attr_reader :orders
    
  def initialize(orders = [])
    @orders = orders
  end
  
  def message
    return nil if /^-/.match(@orders.first)
    @orders.first
  end
  
  def options
    options = {}
    @orders.each_with_index do |parameter, index|
      next if /^[^-]/.match(parameter) 
      option = @orders[index + 1]
      raise "error: exist multiple options in a row" if /^-/.match(option) 
      options[parameter] = option
    end
    options
  end
  
end
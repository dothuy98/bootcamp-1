class ArgvFormater
  
  attr_reader :orders
    
  def initialize(orders = [])
    @orders = orders
  end
  
  def file_names
    return [] if /^-/.match(@orders.first)
    @orders[0...@orders.find_index { |index| /^-/.match(index) } || @orders.size]
  end
  
  def options
    options = {}
    @orders.each_with_index do |parameter, index|
      next if /^[^-]/.match(parameter) 
      option = @orders[index + 1] || "default"
      raise "error: exist multiple options in a row" if /^-/.match(option) 
      options[parameter] = option
    end
    options
  end
  
end

class ArgvFromatter
  
  attr_reader :orders
    
  def initialize(orders = [])
    @orders = orders
  end
  
  def arguments
    return [] if /^-/.match(@orders.first)
    @orders[0...@orders.find_index { |index| /^-/.match(index) } || @orders.size]
  end
  
  def options
    return [] unless @orders.any? { |value| /^-/.match(value) }
    @orders[@orders.find_index { |index| /^-/.match(index) } || 0..]
  end
  
end

require 'time'

class TimeMeasurer
  
  attr_reader :time
  
  def initialize 
    @time = Time.now
  end
  
  def passed_since(prev_time)
    return 0 if prev_time.nil?
    sec = (@time - Time.parse(prev_time)).to_i
    "#{sec / 3600}h#{sec % 3600 / 60}m#{sec % 3600 % 60}s"
  end
  
end
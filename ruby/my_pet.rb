class MyPet
  # amount_eat's unit is gram.
  attr_accessor :name, :amount_eat_per_day, :species

  def initialize(name,amount_eat_per_day,species)
    @name = name
    @amount_eat_per_day = amount_eat_per_day
    @species = species
  end

  def how_long_last_feed(remaining_amount_feed)
    remaining_amount_feed / @amount_eat_per_day
  end
  
end


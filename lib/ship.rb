class Ship
  attr_reader :name, :length, :health

  def initialize(name, length)
    @name = name
    @length = length
    @health = length
  end
end

require "./lib/ship"

class Cell
  attr_reader :coordinate, :ship

  def initialize(coordinate)
    @coordinate = coordinate
    @ship = nil
    @fired_upon = false
  end

  def empty?
    @ship == nil
  end

  def place_ship(new_ship)
    @ship = new_ship
  end

  def fired_upon?
    @fired_upon
  end

  def fire_upon
    @ship.hit if @ship && !fired_upon?
    @fired_upon = true
  end

  def render(show_ship = false)
    if fired_upon?
      @ship ? @ship.visual : "M"
    else
      show_ship && @ship ? "S" : "."
    end
  end
end

class Board
  attr_reader :cells
  def initialize
    @cells = make_cells
  end

  def make_cells
    letter_array = ("A".."D")
    number_array = (1..4)

    letter_array.map { |letter|
      number_array.map do |num|
        location = letter + num.to_s
        [location, Cell.new(location)]
      end
    }.flatten(1).to_h
  end

  def valid_coordinate?(coordinate)
    @cells.has_key?(coordinate)
  end
end

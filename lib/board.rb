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

  def valid_placement?(ship, coords)
    return false if ship.length != coords.length

    return false if not_empty?(coords)

    in_a_line?(coords, coords.first) && consecutive?(coords)
  end

  def not_empty?(coords)
    coords.any? do |coord|
      @cells[coord].ship
    end
  end

  def in_a_line?(coords, first_coord)
    same_row?(coords, first_coord[0]) || same_column?(coords, first_coord[1])
  end

  def same_row?(coords, letter)
    coords.all? do |coord|
      coord.start_with?(letter)
    end
  end

  def same_column?(coords, num)
    coords.all? do |coord|
      coord.end_with?(num)
    end
  end

  def consecutive?(coords)
    no_row_gaps?(coords) || no_column_gaps?(coords)
  end

  def no_column_gaps?(coords)
    columns = coords.map { |coord| coord[0] }

    columns == (columns.first..columns.last).to_a
  end

  def no_row_gaps?(coords)
    rows = coords.map { |coord| coord[1] }

    rows == (rows.first..rows.last).to_a
  end

  def place(ship, coords)
    coords.each do |coord|
      @cells[coord].place_ship(ship)
    end
  end

  def render(show_ship = false)
    @cells.values.each_slice(4).map do |row|

    end 
  end
end

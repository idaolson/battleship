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

  def valid_placement?(ship, coordinates)
    return false if ship.length != coordinates.length

    coords = make_coords(coordinates)

    in_a_line?(coords, coords.first) && consecutive?(coords)
  end

  def make_coords(coordinates)
    coordinates.map { |coord| coord.chars }
  end

  def in_a_line?(coords, first_coord)
    same_row?(coords, first_coord) || same_column?(coords, first_coord)
  end

  def same_row?(coords, first_coord)
    coords.all? do |coord|
      first_coord.first == coord.first
    end
  end

  def same_column?(coords, first_coord)
    coords.all? do |coord|
      first_coord.last == coord.last
    end
  end

  def consecutive?(coords)
    no_row_gaps?(coords) || no_column_gaps?(coords)
  end

  def no_column_gaps?(coords)
    columns = coords.map { |coord| coord.first }

    columns == (columns.first..columns.last).to_a
  end

  def no_row_gaps?(coords)
    rows = coords.map { |coord| coord.last }

    rows == (rows.first..rows.last).to_a
  end
end

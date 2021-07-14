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

    split_coords = coordinates.map { |coord| coord.chars }

    first_coord = split_coords.first

    same_row = split_coords.all? do |coord|
      first_coord.first == coord.first
    end

    same_column = split_coords.all? do |coord|
      first_coord.last == coord.last
    end

    rows = split_coords.map { |coord| coord.first }
    columns = split_coords.map { |coord| coord.last }

    no_row_gaps = rows == (rows.first..rows.last).to_a
    no_column_gaps = columns == (columns.first..columns.last).to_a

    (same_row || same_column) && (no_row_gaps || no_column_gaps)
  end
end

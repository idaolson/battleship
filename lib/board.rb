require "./lib/placement_validator"

class Board
  include PlacementValidator
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

    PlacementValidator.valid?(coords)
  end

  def not_empty?(coords)
    coords.any? do |coord|
      @cells[coord].ship
    end
  end

  def place(ship, coords)
    coords.each do |coord|
      @cells[coord].place_ship(ship)
    end
  end

  def render(show_ship = false)
    headers = "  1 2 3 4 "

    board_image = formatted(show_ship)

    board_image.unshift(headers).join("\n") + "\n"
  end

  def rows
    @cells.values.each_slice(4)
  end

  def formatted(show_ship)
    rows.each_with_index.map do |cells, i|
      format_row(cells, i, show_ship)
    end
  end

  def format_row (cells, i, show_ship)
    letters = %w(A B C D)

    row = make_row(cells, show_ship)

    row.unshift(letters[i]).join(" ") + " "
  end

  def make_row(cells, show_ship)
    cells.map do |cell|
      cell.render(show_ship)
    end
  end
end

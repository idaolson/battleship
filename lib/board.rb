require "./lib/placement_validator"

class Board
  include PlacementValidator
  attr_reader :cells

  def initialize(dimensions = [4, 4])
    @rows = ("A".."Z").take(dimensions.first)
    @columns = ("1"..dimensions.last.to_s).to_a
    @cells = make_cells
  end

  def make_cells
    @rows.map { |letter|
      @columns.map do |num|
        location = letter + num
        [location, Cell.new(location)]
      end
    }.flatten(1).to_h
  end

  def valid_coordinate?(coordinate)
    @cells.has_key?(coordinate)
  end

  def valid_placement?(ship, coords)
    return false if ship.length != coords.length

    return false unless coords.all? { |coord| valid_coordinate?(coord) }

    return false if not_empty?(coords)

    valid?(coords)
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

    headers = make_headers

    board_image = formatted(show_ship)

    board_image.unshift(headers).join("\n") + "\n"
  end

  def make_headers
    if @columns.length > 10
      part_one = @columns[0..8].join("  ") + "  "
      part_two = @columns[9..].join(" ")
      "   " + part_one + part_two + " "
    else
      "  " + @columns.join(" ") + " "
    end
  end

  def rows
    @cells.values.each_slice(@columns.length)
  end

  def formatted(show_ship)
    rows.each_with_index.map do |cells, i|
      format_row(cells, i, show_ship)
    end
  end

  def format_row (cells, i, show_ship)
      row = make_row(cells, show_ship)

    if @columns.length > 10
      row.unshift(@rows[i]).join("  ") + " "
    else
      row.unshift(@rows[i]).join(" ") + " "
    end
  end

  def make_row(cells, show_ship)
    cells.map do |cell|
      cell.render(show_ship)
    end
  end
end

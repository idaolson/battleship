module RandomShipPlacer
  extend self

  def place_ships(person)

    person_assets = {
      :player => [@player_board, @player_ships],
      :computer => [@computer_board, @computer_ships]
    }

    board, ships = person_assets[person]
    
    ships.each do |ship|
      placement = make_ship_placement(ship)

      while !board.valid_placement?(ship, placement) do
        placement = make_ship_placement(ship)
      end

      board.place(ship, placement)
    end
  end

  def make_ship_placement(ship)
    rows = ("A".."Z").take(@dimensions.first)
    columns = ("1"..@dimensions.last.to_s).to_a

    alignment = ["column", "row"].sample

    if alignment == "row"
      horizontal_placement(ship, columns, rows)
    else
      vertical_placement(ship, columns, rows)
    end
  end

  def horizontal_placement(ship, columns, rows)
    row = rows.sample

    columns.each_cons(ship.length).map { |columns|
      columns.map do |column|
        row + column.to_s
      end
    }.sample
  end

  def vertical_placement(ship, columns, rows)
    column = columns.sample

    rows.each_cons(ship.length).map { |rows|
      rows.map do |row|
        row + column.to_s
      end
    }.sample
  end
end

module RandomPlacementGenerator
  extend self

  def make_ship_placement(ship, dimensions)

    rows = ("A".."Z").take(dimensions.first)
    columns = ("1"..dimensions.last.to_s).to_a

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

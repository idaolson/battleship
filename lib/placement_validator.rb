module PlacementValidator
  extend self

  def valid?(coords)
    in_a_line?(coords, coords.first) && consecutive?(coords)
  end

  def in_a_line?(coords, first_coord)
    number = first_coord.scan(/\d+/).first
    same_row?(coords, first_coord[0]) || same_column?(coords, number)
  end

  def same_row?(coords, letter)
    coords.all? do |coord|
      coord.start_with?(letter)
    end
  end

  def same_column?(coords, num)
    coords.all? do |coord|
      coord.scan(/\d+/).first == num
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
    rows = coords.map { |coord| coord.scan(/\d+/).first }

    rows == (rows.first..rows.last).to_a
  end
end

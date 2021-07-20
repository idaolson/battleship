module PlacementValidator
  extend self

  def valid?(coords)
    coords = coords.map { |coord| coord.bytes }

    coords[..-2].each_with_index.all? do |coord, i|
      next_coord = coords[i + 1]

      result = get_result(coord, next_coord)

      result.one? { |num| num == 1 }
    end
  end

  def get_result(coord, next_coord)
    coord.each_with_index.map do |coord2, i|
      if coord2 == 57
        1 if coord2 - next_coord[i] == 8
      else
        next_coord[i] - coord2
      end
    end
  end
end

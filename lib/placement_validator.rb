module PlacementValidator
  extend self

  def valid?(coords)
    coords = coords.map { |coord| coord.bytes }
    coords[..-2].each_with_index.all? do |coord, i|
      next_coord = coords[i + 1]

      result = [next_coord.first - coord.first, next_coord.last - coord.last]

      result == [1, 0] || result == [0, 1]
    end
  end
end

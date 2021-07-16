require './lib/placement_validator'

RSpec.describe PlacementValidator do
  context 'placement validation' do
    valid_coords_1 = ["A1", "A2", "A3"]
    valid_coords_2 = ["A1", "B1", "C1"]

    invalid_coords_1 = ["A1", "A2", "A4"]
    invalid_coords_2 = ["A1", "B1", "D1"]
    invalid_coords_3 = ["A1", "B2", "A3"]
    invalid_coords_4 = ["A1", "B2", "C1"]

    it 'can check same row' do
      expect(PlacementValidator.same_row?(valid_coords_1, valid_coords_1.first[0])).to be(true)
      expect(PlacementValidator.same_row?(invalid_coords_3, invalid_coords_3.first[0])).to be(false)
    end

    it 'can check same column' do
      expect(PlacementValidator.same_column?(valid_coords_2, valid_coords_2.first[1])).to be(true)
      expect(PlacementValidator.same_column?(invalid_coords_4, invalid_coords_4.first[1])).to be(false)
    end

    it 'can check no row gaps' do
      expect(PlacementValidator.no_row_gaps?(valid_coords_1)).to be(true)
      expect(PlacementValidator.no_row_gaps?(invalid_coords_1)).to be(false)
    end

    it 'can check no column gaps' do
      expect(PlacementValidator.no_column_gaps?(valid_coords_2)).to be(true)
      expect(PlacementValidator.no_column_gaps?(invalid_coords_2)).to be(false)
    end

    it 'can check for no gaps anywhere' do
      expect(PlacementValidator.consecutive?(valid_coords_2)).to be(true)
      expect(PlacementValidator.consecutive?(invalid_coords_2)).to be(false)
    end

    it 'can verify its in a line' do
      expect(PlacementValidator.in_a_line?(valid_coords_1, valid_coords_1.first)).to be(true)
      expect(PlacementValidator.in_a_line?(invalid_coords_3, invalid_coords_3.first)).to be(false)
    end
  end
end

require './lib/placement_validator'

RSpec.describe PlacementValidator do
  context 'placement validation' do
    valid_coords_1 = ["A1", "A2", "A3"]
    valid_coords_2 = ["A8", "A9", "A10"]

    invalid_coords_1 = ["A1", "A2", "A4"]
    invalid_coords_2 = ["A1", "B1", "D1"]
    invalid_coords_3 = ["A1", "B2", "A3"]
    invalid_coords_4 = ["A1", "B2", "C1"]

    it 'can check same row' do
      expect(PlacementValidator.valid?(valid_coords_1)).to be(true)
      expect(PlacementValidator.valid?(invalid_coords_3)).to be(false)
    end

    it 'can check same column' do
      expect(PlacementValidator.valid?(valid_coords_2)).to be(true)
      expect(PlacementValidator.valid?(invalid_coords_4)).to be(false)
    end

    it 'can check no row gaps' do
      expect(PlacementValidator.valid?(valid_coords_1)).to be(true)
      expect(PlacementValidator.valid?(invalid_coords_1)).to be(false)
    end

    it 'can check no column gaps' do
      expect(PlacementValidator.valid?(valid_coords_2)).to be(true)
      expect(PlacementValidator.valid?(invalid_coords_2)).to be(false)
    end

    it 'can check for no gaps anywhere' do
      expect(PlacementValidator.valid?(valid_coords_2)).to be(true)
      expect(PlacementValidator.valid?(invalid_coords_2)).to be(false)
    end

    it 'can verify its in a line' do
      expect(PlacementValidator.valid?(valid_coords_1)).to be(true)
      expect(PlacementValidator.valid?(invalid_coords_3)).to be(false)
    end
  end
end

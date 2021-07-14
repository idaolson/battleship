require './lib/board'
require './lib/ship'
require './lib/cell'

RSpec.describe Board do
  context "initialize" do
    it "exists" do
      board = Board.new
      expect(board).to be_a(Board)
    end

    it "has cells" do
      board = Board.new
      board.cells

      expect(board.cells.size).to eq(16)

      all_cells = board.cells.values.all? do |cell|
        cell.class == Cell
      end

      expect(all_cells).to be(true)
    end
  end

  context "validating coordinates" do
    it "can validate a coordinate" do
      board = Board.new

      expect(board.valid_coordinate?("A1")).to be(true)
      expect(board.valid_coordinate?("D4")).to be(true)
      expect(board.valid_coordinate?("A5")).to be(false)
      expect(board.valid_coordinate?("E1")).to be(false)
      expect(board.valid_coordinate?("A22")).to be(false)
    end
  end

  context "validating placement" do
    board = Board.new
    cruiser = Ship.new("Cruiser", 3)
    submarine = Ship.new("Submarine", 2)

    it "can check same size" do
      expect(board.valid_placement?(cruiser, ["A1", "A2"])).to be(false)
      expect(board.valid_placement?(submarine, ["A2", "A3", "A4"])).to be(false)
    end

    it "can check for consecutive" do
      expect(board.valid_placement?(cruiser, ["A1", "A2", "A4"])).to be(false)
      expect(board.valid_placement?(submarine, ["A1", "C1"])).to be(false)
    end

    it "rejects diagonal" do
      expect(board.valid_placement?(cruiser, ["A1", "B2", "C3"])).to be(false)
      expect(board.valid_placement?(submarine, ["C2", "D3"])).to be(false)
    end

    it "accepts valid placement" do
      expect(board.valid_placement?(submarine, ["A1", "A2"])).to be(true)
      expect(board.valid_placement?(cruiser, ["B1", "C1", "D1"])).to be(true)
    end
  end

  context 'helper methods' do
    board = Board.new
    
    it 'can format coordinates' do
      expect(board.make_coords(["A1", "B1"])).to eq([["A", "1"], ["B", "1"]])
    end

    context 'validation steps' do
      valid_coords_1 = board.make_coords(["A1", "A2", "A3"])
      valid_coords_2 = board.make_coords(["A1", "B1", "C1"])

      invalid_coords_1 = board.make_coords(["A1", "A2", "A4"])
      invalid_coords_2 = board.make_coords(["A1", "B1", "D1"])
      invalid_coords_3 = board.make_coords(["A1", "B2", "A3"])
      invalid_coords_4 = board.make_coords(["A1", "B2", "C1"])


      it 'can check same row' do
        expect(board.same_row?(valid_coords_1, valid_coords_1.first)).to be(true)
        expect(board.same_row?(invalid_coords_3, invalid_coords_3.first)).to be(false)
      end

      it 'can check same column' do
        expect(board.same_column?(valid_coords_2, valid_coords_2.first)).to be(true)
        expect(board.same_column?(invalid_coords_4, invalid_coords_4.first)).to be(false)
      end

      it 'can check no row gaps' do
        expect(board.no_row_gaps?(valid_coords_1)).to be(true)
        expect(board.no_row_gaps?(invalid_coords_1)).to be(false)
      end

      it 'can check no column gaps' do
        expect(board.no_column_gaps?(valid_coords_2)).to be(true)
        expect(board.no_column_gaps?(invalid_coords_2)).to be(false)
      end

      it 'can check for no gaps anywhere' do
        expect(board.consecutive?(valid_coords_2)).to be(true)
        expect(board.consecutive?(invalid_coords_2)).to be(false)
      end

      it 'can verify its in a line' do
        expect(board.in_a_line?(valid_coords_1, valid_coords_1.first)).to be(true)
        expect(board.in_a_line?(invalid_coords_3, invalid_coords_3.first)).to be(false)
      end
    end
  end
end

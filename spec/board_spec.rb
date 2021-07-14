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
      expect(board.valid_placement?(cruiser, ["B1", "C1", "D1"])).to be(false)
    end

    it "accepts valid placement" do
      expect(board.valid_placement?(submarine, ["A1", "A2"])).to be(true)
      expect(board.valid_placement?(cruiser, ["B1", "C1", "D1"])).to be(true)
    end
  end
end

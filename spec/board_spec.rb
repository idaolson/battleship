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

    valid_coords_1 = ["A1", "A2", "A3"]
    valid_coords_2 = ["A1", "B1", "C1"]

    invalid_coords_1 = ["A1", "A2", "A4"]
    invalid_coords_2 = ["A1", "B1", "D1"]
    invalid_coords_3 = ["A1", "B2", "A3"]
    invalid_coords_4 = ["A1", "B2", "C1"]


    it 'can check same row' do
      expect(board.same_row?(valid_coords_1, valid_coords_1.first[0])).to be(true)
      expect(board.same_row?(invalid_coords_3, invalid_coords_3.first[0])).to be(false)
    end

    it 'can check same column' do
      expect(board.same_column?(valid_coords_2, valid_coords_2.first[1])).to be(true)
      expect(board.same_column?(invalid_coords_4, invalid_coords_4.first[1])).to be(false)
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

  context "ship placement" do
    it "can place a ship in multiple cells" do
      board = Board.new
      cruiser = Ship.new("Cruiser", 3)
      board.place(cruiser, ["A1", "A2", "A3"])
      cell_1 = board.cells["A1"]
      cell_2 = board.cells["A2"]
      cell_3 = board.cells["A3"]

      expect(cell_1.ship == cell_2.ship).to be(true)
      expect(cell_2.ship == cell_3.ship).to be(true)
    end

    it "can identify if a cell already has a ship" do
      board = Board.new
      cruiser = Ship.new("Cruiser", 3)
      board.place(cruiser, ["A1", "A2", "A3"])
      submarine = Ship.new("Submarine", 2)

      expect(board.valid_placement?(submarine, ["A1", "B1"])).to be(false)
    end
  end

  context "board rendering" do
    board = Board.new
    cruiser = Ship.new("Cruiser", 3)
    board.place(cruiser, ["A1", "A2", "A3"])
    cells = [board.cells["A1"], board.cells["A2"], board.cells["A3"]]

    it "can render an empty board" do
      expected = "  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n"
      expect(board.render).to eq(expected)
    end

    it "can render a board with a ship displayed" do
      expected = "  1 2 3 4 \nA S S S . \nB . . . . \nC . . . . \nD . . . . \n"
      expect(board.render(true)).to eq(expected)
    end

    it "rows" do
      expect(board.rows.size).to eq(4)
    end

    it "make_row" do
      expect(board.make_row(cells, true)).to eq(%w(S S S))
    end

    it "format_row" do
      expect(board.format_row(cells, 2, true)).to eq("C S S S ")
    end

    it "formatted" do
      expected = ["A S S S . ", "B . . . . ", "C . . . . ", "D . . . . "]
      expect(board.formatted(true)).to eq(expected)
    end
  end
end

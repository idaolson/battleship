require './lib/ship'
require './lib/cell'

RSpec.describe Cell do
  context "initialize" do
    cell = Cell.new("B4")

    it "exists" do
      expect(cell).to be_a(Cell)
    end

    it "has a coordinate" do
      expect(cell.coordinate).to eq("B4")
    end

    it "has no ship" do
      expect(cell.ship).to eq(nil)
    end
  end

  context "holding ships" do
    it "is empty by default" do
      cell = Cell.new("B4")

      expect(cell.empty?).to be(true)
    end

    it "can take a ship" do
      cell = Cell.new("B4")
      cruiser = Ship.new("Cruiser", 3)
      cell.place_ship(cruiser)

      expect(cell.ship).to eq(cruiser)
      expect(cell.empty?).to be(false)
    end
  end

  context "firing on cells" do
    it "not fired on by default" do
      cell = Cell.new("B4")

      expect(cell.fired_upon?).to be(false)
    end

    it "can be fired on" do
      cell = Cell.new("B4")
      cell.fire_upon

      expect(cell.fired_upon?).to be(true)
    end

    it "reduces its ship health when fired on" do
      cell = Cell.new("B4")
      cruiser = Ship.new("Cruiser", 3)
      cell.place_ship(cruiser)
      cell.fire_upon

      expect(cell.ship.health).to eq(2)
    end
  end
end

require './lib/ship'

RSpec.describe Ship do
  context "initialize" do
    cruiser = Ship.new("Cruiser", 3)

    it "exists" do
      expect(cruiser).to be_a(Ship)
    end

    it "has a name" do
      expect(cruiser.name).to eq("Cruiser")
    end

    it "has a length" do
      expect(cruiser.length).to eq(3)
    end

    it "has health" do
      expect(cruiser.health).to eq(3)
    end
  end

  context "taking hits" do
    it "is not sunk by default" do
      cruiser = Ship.new("Cruiser", 3)

      expect(cruiser.sunk?).to be(false)
    end

    it "loses 1 health when hit" do
      cruiser = Ship.new("Cruiser", 3)
      cruiser.hit

      expect(cruiser.health).to eq(2)
    end

    it "sinks when gets hit health amount of times" do
      cruiser = Ship.new("Cruiser", 3)

      3.times do
        cruiser.hit
      end

      expect(cruiser.health).to eq(0)
      expect(cruiser.sunk?).to be(true)
    end
  end
end

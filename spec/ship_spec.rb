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
end

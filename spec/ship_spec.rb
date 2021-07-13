require './lib/ship'

RSpec.describe Ship do
  it "exists" do
    cruiser = Ship.new("Cruiser", 3)

    expect(cruiser).to be_a(Ship)
  end
end

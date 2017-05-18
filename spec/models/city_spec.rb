require 'rails_helper'

RSpec.describe City, type: :model do
  let(:city) { build(:city) }

  it "is valid with valid attributes" do
    expect(city).to be_valid
  end

  it "is not valid with no city name" do
    city.name = ""
    expect(city).to_not be_valid
  end

  it "is not valid with city name longer than 45 characters" do
    city.name = 'a' * 46
    expect(city).to_not be_valid
  end

  it "is not valid with no country" do
    city = build(:city, country: nil)
    expect(city).to_not be_valid
  end

end
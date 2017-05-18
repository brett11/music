require 'rails_helper'

RSpec.describe Country, type: :model do
  let(:country) { build(:country) }

  it "is valid with valid attributes" do
    expect(country).to be_valid
  end

  it "is not valid with no country name" do
    country.name = ""
    expect(country).to_not be_valid
  end

  it "is not valid with country name longer than 45 characters" do
    country.name = 'a' * 46
    expect(country).to_not be_valid
  end

end
require 'rails_helper'

RSpec.describe Venue, type: :model do
  let(:venue) { build(:venue) }

  it "is valid with valid attributes" do
    venue.save!
    expect(venue).to be_valid
  end

  it "is not valid with no venue name" do
    venue.name = ""
    expect(venue).to_not be_valid
  end

  it "is not valid with venue name longer than 60 characters" do
    venue.name = 'a' * 61
    expect(venue).to_not be_valid
  end

  it "is not valid with no city" do
    venue = build(:venue, city: nil)
    expect(venue).to_not be_valid
  end

end
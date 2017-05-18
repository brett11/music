require 'rails_helper'

RSpec.describe Artist, type: :model do
  let(:artist) { build(:artist) }

  it "is valid with valid attributes" do
    expect(artist).to be_valid
  end

  it "is not valid with no artist stage name" do
    artist.name_stage = ""
    expect(artist).to_not be_valid
  end

  it "is not valid with artist stage name longer than 45 characters" do
    artist.name_stage = 'a' * 46
    expect(artist).to_not be_valid
  end

  it "is not valid with artist first name longer than 45 characters" do
    artist.name_first = 'a' * 46
    expect(artist).to_not be_valid
  end

  it "is not valid with artist last name longer than 45 characters" do
    artist.name_last = 'a' * 46
    expect(artist).to_not be_valid
  end

end
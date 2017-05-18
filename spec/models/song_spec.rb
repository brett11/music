require 'rails_helper'

RSpec.describe Song, type: :model do
  let(:song) { build(:song) }

  it "is valid with valid attributes" do
    expect(song).to be_valid
  end

  it "is not valid with no song name" do
    song.name = ""
    expect(song).to_not be_valid
  end

  it "is not valid with song name longer than 100 characters" do
    song.name = 'a' * 101
    expect(song).to_not be_valid
  end

  #must use build because create will fail because of validation
  #must use empty artist_array as opposed to nil, because source code tries to call each, which causes error when called on nil
  it "is not valid with no album" do
    album1 = build(:album)
    song1 = build(:song, album: album1)
    expect(song1).to_not be_valid
  end

end
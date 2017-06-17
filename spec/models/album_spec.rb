require 'rails_helper'
require 'pry'

RSpec.describe Album, type: :model do
  let(:album) { build(:album) }


  it "is valid with valid attributes" do
    expect(album).to be_valid
  end

  it "is not valid with no album name" do
    album.name = ""
    expect(album).to_not be_valid
  end

  it "is not valid with album name longer than 100 characters" do
    album.name = 'a' * 101
    expect(album).to_not be_valid
  end

  it "is not valid with no release date" do
    album.release_date = ""
    expect(album).to_not be_valid
  end

  #must use build because create will fail because of validation
  #must use empty artist_array as opposed to nil, because source code tries to call each, which causes error when called on nil
  it "is not valid with no artist" do
    artist_array = []
    album = build(:album, artists: artist_array)
    expect(album).to_not be_valid
  end

  it "is valid with a newly created artist" do
    artist2 = create(:artist, name_stage: "Kevin Morby")
    album.artists.clear
    album.artists << artist2
    expect(album).to be_valid
    expect(album.errors).to be_empty
    #binding.pry
  end
end

require 'rails_helper'

RSpec.describe Concert, type: :model do
  let(:concert) { create(:concert) }

  it "is valid with valid attributes" do
    expect(concert).to be_valid
  end

  it "is not valid with no venue" do
    concert = build(:concert, venue: nil)
    expect(concert).to_not be_valid
  end

  #must use build because create will fail because of validation
  #must use empty artist_array as opposed to nil, because source code tries to call each, which causes error when called on nil
  it "is not valid with no artists" do
    artist_array = []
    concert = build(:concert, artists: artist_array)
    expect(concert).to_not be_valid
  end

  specify "concert associations are working" do
    artist1 = create(:artist, name_stage: "St. Vincent")
    concert1 = create(:concert, artists: [artist1] )
    expect(concert1.artists.first).to be(artist1)
  end

end

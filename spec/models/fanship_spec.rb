require 'rails_helper'
require 'pry'

RSpec.describe Fanship, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:artist) { FactoryBot.create(:artist) }
  let(:fanship) { FactoryBot.create(:fanship, user: user, artist: artist) }

  it "is valid with valid attributes" do
    expect(fanship).to be_valid
  end

  it "is not valid with no user" do
    fanship.user_id = nil
    expect(fanship).to_not be_valid
  end

  it "is not valid with no artist" do
    fanship.artist_id = nil
    expect(fanship).to_not be_valid
  end

  it "shows when user follows artists" do
    #need local fanship below line because fanship is needed and lazily instantiated
    fanship = FactoryBot.create(:fanship, user: user, artist: artist)
    other_artist = FactoryBot.create(:artist, name_stage: "Arcade Fire")
    #Rails Tutorial chapter 14
    user.following << other_artist
    expect(user.following.include?(artist)).to be_truthy
    expect(user.following.include?(other_artist)).to be_truthy
  end

  it "follows and unfollows artists" do
    expect(user.following?(artist)).to be_falsey
    user.follow(artist)
    expect(user.following?(artist)).to be_truthy
    other_artist = FactoryBot.create(:artist, name_stage: "Arcade Fire")
    user.follow(other_artist)
    expect(user.following?(other_artist)).to be_truthy
    user.unfollow(artist)
    expect(user.following?(artist)).to be_falsey
  end
end

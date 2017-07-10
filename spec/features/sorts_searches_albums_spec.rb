require 'pry'
require 'rails_helper'
require_relative '../support/appear_before_matcher'

RSpec.describe "sorts and searches albums" do
  #can't use below because lazily loaded and need for once visit artists_path
  # let(:frank_ocean) { FactoryGirl.create(:artist, name_stage: "Frank Ocean", avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/files/FrankOcean.jpg", 'image/jpeg') ) }
  # let(:u2) { FactoryGirl.create(:artist, name_stage: "U2", avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/files/U2.jpg", 'image/jpeg') ) }
  # let(:bon_iver) { FactoryGirl.create(:artist, name_stage: "Bon Iver", avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/files/BonIver.jpg", 'image/jpeg') ) }
  before(:example) do
    @frank_ocean = FactoryGirl.create(:artist, name_stage: "Frank Ocean", avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/files/FrankOcean.jpg", 'image/jpeg') )
    @u2 = FactoryGirl.create(:artist, name_stage: "U2", avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/files/U2.jpg", 'image/jpeg') )
    @bon_iver = FactoryGirl.create(:artist, name_stage: "Bon Iver", avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/files/BonIver.jpg", 'image/jpeg') )
    @channel_orange = FactoryGirl.create(:album, name: "Channel Orange", album_cover: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/files/album_ChannelOrange.jpg", 'image/jpeg'), artists: [@frank_ocean] )
    @the_joshua_tree = FactoryGirl.create(:album, name: "The Joshua Tree", album_cover: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/files/album_TheJoshuaTree.jpg", 'image/jpeg'), artists: [@u2] )
    @for_emma = FactoryGirl.create(:album, name: "For Emma, Forever Ago", album_cover: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/files/album_ForEmmaForeverAgo.png", 'image/png'), artists: [@bon_iver] )
  end


  it "sorts albums alphabetically" do
    visit albums_path
    #http://stackoverflow.com/questions/5228371/how-to-get-current-path-with-query-string-using-capybara
    # binding.pry
    expect(page).to have_selector("#channel_orange")
    expect(page).to have_selector("#the_joshua_tree")
    expect(page).to have_selector("#for_emma_forever_ago")
    # expect(page).to have_selector("div#all_artists div:nth-child(1)", content: @date1.content)
    #note that default of aritsts index is to be sorted alphabetically.
    expect(@channel_orange.name).to appear_before(@for_emma.name)
    expect(@for_emma.name).to appear_before(@the_joshua_tree.name)
    click_button "Sort alphabetically (albums)"
    #since sort_alphabetically reverses itself, the following should be in reverse alphabetical order
    expect(@the_joshua_tree.name).to appear_before(@for_emma.name)
    expect(@for_emma.name).to appear_before(@channel_orange.name)
  end

  it "searches albums", :pending do
    visit albums_path
    expect(page).to have_selector("#frank_ocean")
    expect(page).to have_selector("#u2")
    expect(page).to have_selector("#bon_iver")
    fill_in "search", with: "Frank"
    click_button "Search"
    expect(page).to have_selector("#frank_ocean")
    expect(page).to_not have_selector("#u2")
    expect(page).to_not have_selector("#bon_iver")
  end
end
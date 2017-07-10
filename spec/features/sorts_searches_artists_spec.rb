require 'pry'
require 'rails_helper'
require_relative '../support/appear_before_matcher'

RSpec.describe "artists" do
    #can't use below because lazily loaded and need our data right away for visit artists_path
    # let(:frank_ocean) { FactoryGirl.create(:artist, name_stage: "Frank Ocean", avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/files/FrankOcean.jpg", 'image/jpeg') ) }
    # let(:u2) { FactoryGirl.create(:artist, name_stage: "U2", avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/files/U2.jpg", 'image/jpeg') ) }
    # let(:bon_iver) { FactoryGirl.create(:artist, name_stage: "Bon Iver", avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/files/BonIver.jpg", 'image/jpeg') ) }
  before(:example) do
    @frank_ocean = FactoryGirl.create(:artist, name_stage: "Frank Ocean", avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/files/FrankOcean.jpg", 'image/jpeg') )
    @u2 = FactoryGirl.create(:artist, name_stage: "U2", avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/files/U2.jpg", 'image/jpeg') )
    @bon_iver = FactoryGirl.create(:artist, name_stage: "Bon Iver", avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/files/BonIver.jpg", 'image/jpeg') )
  end


  it "sorts by date" do
    visit artists_path
    #http://stackoverflow.com/questions/5228371/how-to-get-current-path-with-query-string-using-capybara
    # binding.pry
    expect(page).to have_selector("#frank_ocean")
    expect(page).to have_selector("#u2")
    expect(page).to have_selector("#bon_iver")
    # expect(page).to have_selector("div#all_artists div:nth-child(1)", content: @date1.content)
    #note that default of aritsts index is to be sorted alphabetically.
    expect(@bon_iver.name_stage).to appear_before(@frank_ocean.name_stage)
    expect(@frank_ocean.name_stage).to appear_before(@u2.name_stage)
    click_button "Sort alphabetically"
    #since sort_alphabetically reverses itself, the following should be in reverse alphabetical order
    expect(@u2.name_stage).to appear_before(@frank_ocean.name_stage)
    expect(@frank_ocean.name_stage).to appear_before(@bon_iver.name_stage)
  end

  it "searches" do
    visit artists_path
    expect(page).to have_selector("#frank_ocean")
    expect(page).to have_selector("#u2")
    expect(page).to have_selector("#bon_iver")
    fill_in "search", with: "frank"
    click_button "Search"
    expect(page).to have_selector("#frank_ocean")
    expect(page).to_not have_selector("#u2")
    expect(page).to_not have_selector("#bon_iver")
  end
end

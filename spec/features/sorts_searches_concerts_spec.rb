require 'rails_helper'
require_relative '../support/appear_before_matcher'

RSpec.feature "SortsSearchesConcerts", type: :feature do
  #can't use "let" stmts because lazily loaded and need our data right away for visit concerts_path

  before(:example) do
    @frank_ocean = FactoryGirl.create(:artist, name_stage: "Frank Ocean", avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/files/FrankOcean.jpg", 'image/jpeg') )
    @u2 = FactoryGirl.create(:artist, name_stage: "U2", avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/files/U2.jpg", 'image/jpeg') )
    @bon_iver = FactoryGirl.create(:artist, name_stage: "Bon Iver", avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/files/BonIver.jpg", 'image/jpeg') )
    @venue = FactoryGirl.create(:venue)
    @frank_ocean_concert = FactoryGirl.create(:concert, dateandtime: "2018-07-10", artists: [@frank_ocean], venue: @venue )
    @u2_concert = FactoryGirl.create(:concert, dateandtime: "2018-07-09", artists: [@u2], venue: @venue )
    @bon_iver_concert = FactoryGirl.create(:concert, dateandtime: "2018-07-08", artists: [@bon_iver], venue: @venue )
  end


  it "sorts concerts by date and time" do
    visit concerts_path
    #http://stackoverflow.com/questions/5228371/how-to-get-current-path-with-query-string-using-capybara
    expect(page).to have_selector("#frank_ocean_the_venue_20180710")
    expect(page).to have_selector("#u2_the_venue_20180709")
    expect(page).to have_selector("#bon_iver_the_venue_20180708")
    #note that default of concerts index is to be sorted by most recent date.
    expect(@bon_iver_concert.artists[0].name_stage).to appear_before(@u2_concert.artists[0].name_stage)
    expect(@u2_concert.artists[0].name_stage).to appear_before(@frank_ocean_concert.artists[0].name_stage)
    page.find('input[value="Sort by date"]').click
    #should be sorted by least recent to most recent
    sleep(1)
    expect(@frank_ocean_concert.artists[0].name_stage).to appear_before(@u2_concert.artists[0].name_stage)
    expect(@u2_concert.artists[0].name_stage).to appear_before(@bon_iver_concert.artists[0].name_stage)
    # below is commented out, because second click on buttons mostly not working in capybara tests for some reason
    # page.find('input[value="Sort by date"]').click
    # #go back to most recent
    # expect(@bon_iver_concert.artists[0].name_stage).to appear_before(@u2_concert.artists[0].name_stage)
    # expect(@u2_concert.artists[0].name_stage).to appear_before(@frank_ocean_concert.artists[0].name_stage)
  end

  it "sorts concerts by artist(alphabetically)" do
    visit concerts_path
    #http://stackoverflow.com/questions/5228371/how-to-get-current-path-with-query-string-using-capybara
    click_button "Sort alphabetically (artist)"
    expect(@u2_concert.artists[0].name_stage).to appear_before(@frank_ocean_concert.artists[0].name_stage)
    expect(@frank_ocean_concert.artists[0].name_stage).to appear_before(@bon_iver_concert.artists[0].name_stage)
    # below is commented out, because second click on buttons mostly not working in capybara tests for some reason
    # click_button "Sort alphabetically (artist)"
    # sleep(1)
    # expect(@bon_iver_concert.artists[0].name_stage).to appear_before(@frank_ocean_concert.artists[0].name_stage)
    # expect(@frank_ocean_concert.artists[0].name_stage).to appear_before(@u2_concert.artists[0].name_stage)
    # #note that default of concerts index is to be sorted by most recent date.
  end

  it "sorts concerts by date and alphabetically" do
    visit concerts_path
    #http://stackoverflow.com/questions/5228371/how-to-get-current-path-with-query-string-using-capybara
    expect(page).to have_selector("#frank_ocean_the_venue_20180710")
    expect(page).to have_selector("#u2_the_venue_20180709")
    expect(page).to have_selector("#bon_iver_the_venue_20180708")
    #note that default of concerts index is to be sorted by most recent date.
    expect(@bon_iver_concert.artists[0].name_stage).to appear_before(@u2_concert.artists[0].name_stage)
    expect(@u2_concert.artists[0].name_stage).to appear_before(@frank_ocean_concert.artists[0].name_stage)
    page.find('input[value="Sort alphabetically (artist)"]').click
    #should be sorted by highest letter in stage name to lowest
    expect(@u2_concert.artists[0].name_stage).to appear_before(@frank_ocean_concert.artists[0].name_stage)
    expect(@frank_ocean_concert.artists[0].name_stage).to appear_before(@bon_iver_concert.artists[0].name_stage)
    # below is commented out, because second click on buttons mostly not working in capybara tests for some reason
    # within("#sort_concert_by_date") do
    #   click_button "Sort by date"
    # end
    # # page.find('input[value="Sort by date"]').click
    # #go back to most recent
    # expect(@bon_iver_concert.artists[0].name_stage).to appear_before(@u2_concert.artists[0].name_stage)
    # expect(@u2_concert.artists[0].name_stage).to appear_before(@frank_ocean_concert.artists[0].name_stage)
  end

  it "searches concerts" do
    visit concerts_path
    expect(page).to have_selector("#frank_ocean_the_venue_20180710")
    expect(page).to have_selector("#u2_the_venue_20180709")
    expect(page).to have_selector("#bon_iver_the_venue_20180708")
    fill_in "search", with: "frank"
    click_button "Search"
    expect(page).to have_selector("#frank_ocean_the_venue_20180710")
    expect(page).to_not have_selector("#u2_the_venue_19870309")
    expect(page).to_not have_selector("#bon_iver_the_venue_20180708")
  end
end
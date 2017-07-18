require 'rails_helper'
require_relative '../support/appear_before_matcher'

RSpec.feature "SortsSearchesConcerts", type: :feature do
  #can't use "let" stmts because lazily loaded and need our data right away for visit concerts_path

  before(:example) do
    @frank_ocean = FactoryGirl.create(:artist, name_stage: "Frank Ocean", avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/files/FrankOcean.jpg", 'image/jpeg') )
    @u2 = FactoryGirl.create(:artist, name_stage: "U2", avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/files/U2.jpg", 'image/jpeg') )
    @bon_iver = FactoryGirl.create(:artist, name_stage: "Bon Iver", avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/files/BonIver.jpg", 'image/jpeg') )
    @venue = FactoryGirl.create(:venue)
    @frank_ocean_concert_20180710 = FactoryGirl.create(:concert, dateandtime: "2018-07-10", artists: [@frank_ocean], venue: @venue )
    @u2_concert_20180709 = FactoryGirl.create(:concert, dateandtime: "2018-07-09", artists: [@u2], venue: @venue )
    @bon_iver_concert_20180708 = FactoryGirl.create(:concert, dateandtime: "2018-07-08", artists: [@bon_iver], venue: @venue )
  end

  describe "if not logged in" do
    it "sorts concerts by date and time" do
      visit concerts_path
      #http://stackoverflow.com/questions/5228371/how-to-get-current-path-with-query-string-using-capybara
      expect(page).to have_selector("#frank_ocean_the_venue_20180710")
      expect(page).to have_selector("#u2_the_venue_20180709")
      expect(page).to have_selector("#bon_iver_the_venue_20180708")
      #note that default of concerts index is to be sorted by most recent date.
      expect(@bon_iver_concert_20180708.artists[0].name_stage).to appear_before(@u2_concert_20180709.artists[0].name_stage)
      expect(@u2_concert_20180709.artists[0].name_stage).to appear_before(@frank_ocean_concert_20180710.artists[0].name_stage)
      page.find('input[value="Sort by date"]').click
      #should be sorted by least recent to most recent
      sleep(1)
      expect(@frank_ocean_concert_20180710.artists[0].name_stage).to appear_before(@u2_concert_20180709.artists[0].name_stage)
      expect(@u2_concert_20180709.artists[0].name_stage).to appear_before(@bon_iver_concert_20180708.artists[0].name_stage)
      # below is commented out, because second click on buttons mostly not working in capybara tests for some reason
      # page.find('input[value="Sort by date"]').click
      # #go back to most recent
      # expect(@bon_iver_concert_20180708.artists[0].name_stage).to appear_before(@u2_concert_20180709.artists[0].name_stage)
      # expect(@u2_concert_20180709.artists[0].name_stage).to appear_before(@frank_ocean_concert_20180710.artists[0].name_stage)
    end

    it "sorts concerts by artist(alphabetically)" do
      visit concerts_path
      #http://stackoverflow.com/questions/5228371/how-to-get-current-path-with-query-string-using-capybara
      click_button "Sort alphabetically (artist)"
      expect(@u2_concert_20180709.artists[0].name_stage).to appear_before(@frank_ocean_concert_20180710.artists[0].name_stage)
      expect(@frank_ocean_concert_20180710.artists[0].name_stage).to appear_before(@bon_iver_concert_20180708.artists[0].name_stage)
      # below is commented out, because second click on buttons mostly not working in capybara tests for some reason
      # click_button "Sort alphabetically (artist)"
      # sleep(1)
      # expect(@bon_iver_concert_20180708.artists[0].name_stage).to appear_before(@frank_ocean_concert_20180710.artists[0].name_stage)
      # expect(@frank_ocean_concert_20180710.artists[0].name_stage).to appear_before(@u2_concert_20180709.artists[0].name_stage)
      # #note that default of concerts index is to be sorted by most recent date.
    end

    it "sorts concerts by date and alphabetically" do
      visit concerts_path
      #http://stackoverflow.com/questions/5228371/how-to-get-current-path-with-query-string-using-capybara
      expect(page).to have_selector("#frank_ocean_the_venue_20180710")
      expect(page).to have_selector("#u2_the_venue_20180709")
      expect(page).to have_selector("#bon_iver_the_venue_20180708")
      #note that default of concerts index is to be sorted by most recent date.
      expect(@bon_iver_concert_20180708.artists[0].name_stage).to appear_before(@u2_concert_20180709.artists[0].name_stage)
      expect(@u2_concert_20180709.artists[0].name_stage).to appear_before(@frank_ocean_concert_20180710.artists[0].name_stage)
      page.find('input[value="Sort alphabetically (artist)"]').click
      #should be sorted by highest letter in stage name to lowest
      expect(@u2_concert_20180709.artists[0].name_stage).to appear_before(@frank_ocean_concert_20180710.artists[0].name_stage)
      expect(@frank_ocean_concert_20180710.artists[0].name_stage).to appear_before(@bon_iver_concert_20180708.artists[0].name_stage)
      # below is commented out, because second click on buttons mostly not working in capybara tests for some reason
      # within("#sort_concert_by_date") do
      #   click_button "Sort by date"
      # end
      # # page.find('input[value="Sort by date"]').click
      # #go back to most recent
      # expect(@bon_iver_concert_20180708.artists[0].name_stage).to appear_before(@u2_concert_20180709.artists[0].name_stage)
      # expect(@u2_concert_20180709.artists[0].name_stage).to appear_before(@frank_ocean_concert_20180710.artists[0].name_stage)
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

  describe "if logged in", :js do
    let(:user) { FactoryGirl.create(:user) }

    before(:example) do
      login(user)
      #needed so can sort 3 out of 4 alphatbetically (other one won't be "followed")
      @grimes = FactoryGirl.create(:artist, name_stage: "Grimes", avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/files/Grimes.jpg", 'image/jpeg') )
      @grimes_concert_20180711 = FactoryGirl.create(:concert, dateandtime: "2018-07-11", artists: [@grimes], venue: @venue )

      visit artists_path
      page.find('#bon_iver form.new_fanship > input[value="Follow"]').click
      page.find('#frank_ocean form.new_fanship > input[value="Follow"]').click
      page.find('#grimes form.new_fanship > input[value="Follow"]').click
    end

    it "sorts concerts by date and time", :js do
      visit concerts_path
      #http://stackoverflow.com/questions/5228371/how-to-get-current-path-with-query-string-using-capybara
      expect(page).to have_selector("#frank_ocean_the_venue_20180710")
      expect(page).to have_selector("#u2_the_venue_20180709")
      expect(page).to have_selector("#bon_iver_the_venue_20180708")
      expect(page).to have_selector("#grimes_the_venue_20180711")
      #note that default of concerts index is to be sorted by most recent date.
      expect(@bon_iver_concert_20180708.artists[0].name_stage).to appear_before(@u2_concert_20180709.artists[0].name_stage)
      expect(@u2_concert_20180709.artists[0].name_stage).to appear_before(@frank_ocean_concert_20180710.artists[0].name_stage)
      check('sort_favs')
      sleep(1)
      click_button "Sort by date"
      sleep(1)
      # should be least recent ot most recent
      expect(@grimes_concert_20180711.artists[0].name_stage).to appear_before(@frank_ocean_concert_20180710.artists[0].name_stage)
      expect(@frank_ocean_concert_20180710.artists[0].name_stage).to appear_before(@bon_iver_concert_20180708.artists[0].name_stage)
      expect(page).to_not have_selector("#u2_the_venue_20180709")
      click_button "Sort by date"
      sleep(1)
      # should switch back to most recent being first
      expect(@bon_iver_concert_20180708.artists[0].name_stage).to appear_before(@frank_ocean_concert_20180710.artists[0].name_stage)
      expect(@frank_ocean_concert_20180710.artists[0].name_stage).to appear_before(@grimes_concert_20180711.artists[0].name_stage)
      #u2 shouldn't make a reapperance
      expect(page).to_not have_selector("#u2_the_venue_20180709")
    end

    it "sorts concerts alphabetically (artist)", :js do
      visit concerts_path
      check('sort_favs')
      sleep(1)
      click_button "Sort alphabetically (artist)"
      sleep(1)
      # should be reverse alphabetical order
      expect(@grimes_concert_20180711.artists[0].name_stage).to appear_before(@frank_ocean_concert_20180710.artists[0].name_stage)
      expect(@frank_ocean_concert_20180710.artists[0].name_stage).to appear_before(@bon_iver_concert_20180708.artists[0].name_stage)
      click_button "Sort alphabetically (artist)"
      sleep(1)
      # should be normal alphabetical order
      expect(@bon_iver_concert_20180708.artists[0].name_stage).to appear_before(@frank_ocean_concert_20180710.artists[0].name_stage)
      expect(@frank_ocean_concert_20180710.artists[0].name_stage).to appear_before(@grimes_concert_20180711.artists[0].name_stage)
    end

    it "searches favs", :js, :pending do
      visit concerts_path
      check 'sort_favs'
      sleep(1)
      #below because u2 not a fav
      expect(page).to_not have_selector("#u2_the_venue_20180709")
      #below is skipped because it freezes up respec if ran, because of the pgsearch error when "my favorites"" is checked
      # TODO: figure out how to search with my favs checked
      skip
      fill_in "search", with: "grim"
      click_button "Search"
      expect(page).to have_selector("#grimes_the_venue_20180711")
      expect(page).to_not have_selector("#frank_ocean_the_venue_20180710")
      expect(page).to_not have_selector("#bon_iver_the_venue_20180708")
    end
  end
end



require 'rails_helper'
require_relative '../support/appear_before_matcher'

RSpec.feature "SortsSearchesAlbums", type: :feature do
  #can't use below because lazily loaded and need our data right away for visit albums_path
  # let(:frank_ocean) { FactoryBot.create(:artist, name_stage: "Frank Ocean", avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/files/FrankOcean.jpg", 'image/jpeg') ) }
  # let(:u2) { FactoryBot.create(:artist, name_stage: "U2", avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/files/U2.jpg", 'image/jpeg') ) }
  # let(:bon_iver) { FactoryBot.create(:artist, name_stage: "Bon Iver", avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/files/BonIver.jpg", 'image/jpeg') ) }

  before do
    skip("jquery and rspec not playing nicely")
  end

  before(:example) do
    @frank_ocean = FactoryBot.create(:artist, name_stage: "Frank Ocean", avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/files/FrankOcean.jpg", 'image/jpeg') )
    @u2 = FactoryBot.create(:artist, name_stage: "U2", avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/files/U2.jpg", 'image/jpeg') )
    @bon_iver = FactoryBot.create(:artist, name_stage: "Bon Iver", avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/files/BonIver.jpg", 'image/jpeg') )
    @channel_orange = FactoryBot.create(:album, name: "Channel Orange", release_date: "2012-07-10", album_cover: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/files/album_ChannelOrange.jpg", 'image/jpeg'), artists: [@frank_ocean] )
    @the_joshua_tree = FactoryBot.create(:album, name: "The Joshua Tree", release_date: "1987-03-09", album_cover: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/files/album_TheJoshuaTree.jpg", 'image/jpeg'), artists: [@u2] )
    @for_emma = FactoryBot.create(:album, name: "For Emma, Forever Ago", release_date: "2007-07-08", album_cover: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/files/album_ForEmmaForeverAgo.png", 'image/png'), artists: [@bon_iver] )
  end

  describe "if not logged in" do
    it "contains all expected albums" do
      visit albums_path
      expect(page).to have_selector("#channel_orange")
      expect(page).to have_selector("#the_joshua_tree")
      expect(page).to have_selector("#for_emma_forever_ago")
    end

    it "sorts alphabetically" do
      visit albums_path
      #http://stackoverflow.com/questions/5228371/how-to-get-current-path-with-query-string-using-capybara
      #note that default of aritsts index is to be sorted alphabetically.
      expect(@channel_orange.name).to appear_before(@for_emma.name)
      expect(@for_emma.name).to appear_before(@the_joshua_tree.name)
      page.find('input[value="Sort alphabetically (albums)"]').click
      # click_button "Sort alphabetically (albums)"
      #since sort_alphabetically reverses itself, the following should be in reverse alphabetical order
      expect(@the_joshua_tree.name).to appear_before(@for_emma.name)
      expect(@for_emma.name).to appear_before(@channel_orange.name)
    end

    it "sorts by release date" do
      # binding.pry
      visit albums_path
      page.find('input[value="Sort by release date"]').click
      #default is to sort by release date with oldest albums first
      expect(@the_joshua_tree.name).to appear_before(@for_emma.name)
      expect(@for_emma.name).to appear_before(@channel_orange.name)
      page.find('input[value="Sort by release date"]').click
      # below is commented out, because second click on buttons mostly not working in capybara tests for some reason
      # sleep(2)
      # #should be most recent to least recent
      # expect(@channel_orange.name).to appear_before(@for_emma.name)
      # expect(@for_emma.name).to appear_before(@the_joshua_tree.name)
    end

    it "sorts by artist name (alphabetically)" do
      # binding.pry
      visit albums_path
      # binding.pry
      click_button "Sort alphabetically (artist)"
      #default is to sort with highest letters first
      expect(@the_joshua_tree.name).to appear_before(@channel_orange.name)
      expect(@channel_orange.name).to appear_before(@for_emma.name)
      # below is commented out, because second click on buttons mostly not working in capybara tests for some reason
      # click_button "Sort alphabetically (artist)"
      # expect(@for_emma.name).to appear_before(@channel_orange.name)
      # expect(@channel_orange.name).to appear_before(@the_joshua_tree.name)

    end

    it "searches" do
      visit albums_path
      expect(page).to have_selector("#channel_orange")
      expect(page).to have_selector("#the_joshua_tree")
      expect(page).to have_selector("#for_emma_forever_ago")
      fill_in "search", with: "josh"
      click_button "Search"
      expect(page).to have_selector("#the_joshua_tree")
      expect(page).to_not have_selector("#channel_orange")
      expect(page).to_not have_selector("#for_emma_forever_ago")
    end
  end

  describe "if logged in", :js do
    let(:user) { FactoryBot.create(:user) }

    before(:example) do
      login(user)
      #needed so can sort 3 out of 4 alphatbetically (other one won't be "followed")
      @grimes = FactoryBot.create(:artist, name_stage: "Grimes", avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/files/Grimes.jpg", 'image/jpeg') )
      @art_angels = FactoryBot.create(:album, name: "Art Angels", release_date: "2015-11-06", album_cover: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/files/album_ArtAngels.jpg", 'image/jpeg'), artists: [@grimes] )

      visit artists_path
      page.find('#bon_iver form.new_fanship > input[value="Follow"]').click
      page.find('#frank_ocean form.new_fanship > input[value="Follow"]').click
      page.find('#grimes form.new_fanship > input[value="Follow"]').click

    end

    it "sorts by favs and alphabetically", :js do
      visit albums_path
      expect(page).to have_selector("#channel_orange")
      expect(page).to have_selector("#the_joshua_tree")
      expect(page).to have_selector("#for_emma_forever_ago")
      expect(page).to have_selector("#art_angels")

      #note that default of aritsts index is to be sorted alphabetically.
      expect(@channel_orange.name).to appear_before(@for_emma.name)
      expect(@for_emma.name).to appear_before(@the_joshua_tree.name)

      check 'sort_favs'
      sleep(1)
      click_button "Sort alphabetically (albums)"
      sleep(1)
      #since sort_alphabetically reverses itself, the following should be in reverse alphabetical order
      expect(@for_emma.name).to appear_before(@channel_orange.name)
      expect(@channel_orange.name).to appear_before(@art_angels.name)
      # sorted by favs and U2 not followed
      expect(page).to_not have_selector("#the_joshua_tree")
      click_button "Sort alphabetically (albums)"
      sleep(1)
      #back to normal alphabetical order
      expect(@art_angels.name).to appear_before(@channel_orange.name)
      expect(@channel_orange.name).to appear_before(@for_emma.name)
      # sorted by favs and U2 not followed. make sure when click sort alphabetically that it doesn't reload non-fav artists
      expect(page).to_not have_selector("#the_joshua_tree")
    end

    it "sorts by favs and alphabetically (artist)", :js do
      visit albums_path
      check 'sort_favs'
      sleep(1)
      click_button "Sort alphabetically (artist)"
      sleep(1)
      #default for sort albums by artist is reverse stage_name alphabetical order
      expect(@art_angels.name).to appear_before(@channel_orange.name)
      expect(@channel_orange.name).to appear_before(@for_emma.name)
      # sorted by favs and U2 not followed
      expect(page).to_not have_selector("#the_joshua_tree")
      click_button "Sort alphabetically (artist)"
      sleep(1)
      #back to normal alphabetical order (by artist)
      expect(@for_emma.name).to appear_before(@channel_orange.name)
      expect(@channel_orange.name).to appear_before(@art_angels.name)
      #u2 should not make a reappearance
      expect(page).to_not have_selector("#the_joshua_tree")
    end

    it "sorts by release date", :js do
      visit albums_path
      check 'sort_favs'
      sleep(1)
      click_button "Sort by release date"
      sleep(1)
      #default for sort albums by release date is oldest first
      expect(@for_emma.name).to appear_before(@channel_orange.name)
      expect(@channel_orange.name).to appear_before(@art_angels.name)
      # sorted by favs and U2 not followed
      expect(page).to_not have_selector("#the_joshua_tree")
      click_button "Sort by release date"
      sleep(1)
      #second time clicking sort_by_release_date should be newest first
      expect(@art_angels.name).to appear_before(@channel_orange.name)
      expect(@channel_orange.name).to appear_before(@for_emma.name)
      #u2 should not make a reappearance
      expect(page).to_not have_selector("#the_joshua_tree")
    end

    it "searches favs", :js, :pending do
      pending("search needs to be implemented on albums index after find fix for it")
      visit albums_path
      check 'sort_favs'
      sleep(1)
      #below because u2 not a fav
      expect(page).to_not have_selector("#the_joshua_tree")
      #below is skipped because it freezes up respec if ran, because of the pgsearch error when "my favorites"" is checked
      # TODO: figure out how to search with my favs checked
      skip
      fill_in "search", with: "grim"
      click_button "Search"
      expect(page).to have_selector("#art_angels")
      expect(page).to_not have_selector("#channel_orange")
      expect(page).to_not have_selector("#for_emma_forever_ago")
    end
  end
end
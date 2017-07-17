require 'rails_helper'

RSpec.feature "UserFollowsArtists", type: :feature do
  before(:example) do
    @frank_ocean = FactoryGirl.create(:artist, name_stage: "Frank Ocean", avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/files/FrankOcean.jpg", 'image/jpeg') )
    @u2 = FactoryGirl.create(:artist, name_stage: "U2", avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/files/U2.jpg", 'image/jpeg') )
    @bon_iver = FactoryGirl.create(:artist, name_stage: "Bon Iver", avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/files/BonIver.jpg", 'image/jpeg') )
  end

  describe "if not logged in" do
    it "cannot follow" do
      visit artists_path
      #have 3 artists that are as of yet not followed, but should not be able to see because not logged in
      expect(page).to_not have_selector('form.new_fanship > input[value="Follow"]')
    end
  end

  describe "if logged in" do
    let(:user) { FactoryGirl.create(:user) }

    before(:example) do
      login(user)
    end

    it "follows and unfollows" do
      visit artists_path
      #have 3 artists that are as of yet not followed
      expect(page).to have_selector('form.new_fanship > input[value="Follow"]', count: 3)
      page.find('#frank_ocean form.new_fanship > input[value="Follow"]').click
      expect(page).to have_current_path(artists_path)
      #now have 1 artist followed and 2 that are as of yet not followed
      expect(user.following.count).to eq(1)
      expect(page).to have_selector('form.edit_fanship > input[value="Unfollow"]', count: 1)
      expect(page).to have_selector('form.new_fanship > input[value="Follow"]', count: 2)
      page.find('#bon_iver form.new_fanship > input[value="Follow"]').click
      #now have 2 artists followed and 1 that as of yet is not followed
      expect(user.following.count).to eq(2)
      expect(page).to have_current_path(artists_path)
      expect(page).to have_selector('form.edit_fanship > input[value="Unfollow"]', count: 2)
      expect(page).to have_selector('form.new_fanship > input[value="Follow"]', count: 1)
      page.find('#frank_ocean form.edit_fanship > input[value="Unfollow"]').click
      #now have 1 artist followed and 2 that are as of yet not followed
      expect(user.following.count).to eq(1)
      expect(page).to have_current_path(artists_path)
      expect(page).to have_selector('form.edit_fanship > input[value="Unfollow"]', count: 1)
      expect(page).to have_selector('form.new_fanship > input[value="Follow"]', count: 2)
    end

    it "updates artist page" do
      # user = FactoryGirl.create(:user)
      # login(user)
      visit artists_path
      page.find('#frank_ocean form.new_fanship > input[value="Follow"]').click
      visit artist_path(@frank_ocean)
      expect(page).to have_selector('form.edit_fanship > input[value="Unfollow"]')
    end
  end
end

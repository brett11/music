require 'rails_helper'

RSpec.feature "Logins", type: :feature do
  it "logs in user" do
    user = FactoryGirl.create(:user)
    visit root_path
    within("#menuContent") do
      expect(page).to_not have_content("Account")
      expect(page).to have_content("Log in")
    end
    login(user)
    within("#menuContent") do
      expect(page).to have_content("Account")
      expect(page).to_not have_content("Log in")
    end
  end

  it "logs in admin and shows edit artist(only admin can see this)" do
    artist = FactoryGirl.create(:artist)
    visit artist_path(artist)
    expect(page).to_not have_content("Edit artist info")
    login_admin
    visit artist_path(artist)
    expect(page).to have_content("Edit artist info")
  end
end

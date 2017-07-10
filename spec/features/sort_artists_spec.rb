require 'pry'
require 'rails_helper'
require_relative '../support/appear_before_matcher'

RSpec.describe "sorts artists" do
  it "sorts artists alphabetically" do
    FactoryGirl.create(:artist)
    FactoryGirl.create(:artist, name_stage: "U2", avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/files/U2.jpg", 'image/jpeg') )
    FactoryGirl.create(:artist, name_stage: "Bon Iver", avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/files/BonIver.jpg", 'image/jpeg') )
    visit artists_path
    # click_button "Sort alphabetically"
    #http://stackoverflow.com/questions/5228371/how-to-get-current-path-with-query-string-using-capybara
    # binding.pry
    expect(page).to have_selector("#the_band")
    expect(page).to have_selector("#u2")
    expect(page).to have_selector("#bon_iver")
    expect(page).to have_selector("ul#dates div:nth-child(1)", content: @date1.content)
  end
end

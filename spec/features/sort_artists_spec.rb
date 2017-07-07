require 'pry'
require 'rails_helper'

RSpec.describe "sorts artists" do
  it "sorts artists alphabetically" do
    FactoryGirl.create(:artist)
    visit artists_path
    click_button "Sort alphabetically"
    #http://stackoverflow.com/questions/5228371/how-to-get-current-path-with-query-string-using-capybara
    binding.pry
    expect(page).to have_selector("#the_band")
  end
end

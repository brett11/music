require 'rails_helper'
require_relative '../support/appear_before_matcher'

RSpec.feature "SortsSearchesVenues", type: :feature do
  #can't use "let" stmts because lazily loaded and need our data right away for visit concerts_path

  before(:example) do
    @auditorium = FactoryGirl.create(:venue, name: "Auditorium Theatre")
    @chicago = FactoryGirl.create(:venue, name: "Chicago Theatre")
    @vic = FactoryGirl.create(:venue, name: "Vic Theatre")
  end

  it "sorts alphabetically (venue name)" do
    visit venues_path
    #http://stackoverflow.com/questions/5228371/how-to-get-current-path-with-query-string-using-capybara
    expect(page).to have_selector("#auditorium_theatre_chicago")
    expect(page).to have_selector("#chicago_theatre_chicago")
    expect(page).to have_selector("#vic_theatre_chicago")
    #note that default of concerts index is to be sorted by most recent date.
    expect(@auditorium.name).to appear_before(@chicago.name)
    expect(@chicago.name).to appear_before(@vic.name)
  end


  it "searches" do
    visit venues_path
    expect(page).to have_selector("#auditorium_theatre_chicago")
    expect(page).to have_selector("#chicago_theatre_chicago")
    expect(page).to have_selector("#vic_theatre_chicago")
    fill_in "search", with: "auditori"
    click_button "Search"
    expect(page).to have_selector("#auditorium_theatre_chicago")
    expect(page).to_not have_selector("#chicago_theatre_chicago")
    expect(page).to_not have_selector("#vic_theatre_chicago")
  end
end
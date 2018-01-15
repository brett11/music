require 'rails_helper'
require_relative '../support/appear_before_matcher'

RSpec.feature "SortsSearchesVenues", type: :feature do
  #can't use "let" stmts because lazily loaded and need our data right away for visit concerts_path

  before do
    skip("jquery and rspec not playing nicely")
  end

  before(:example) do
    @auditorium = FactoryBot.create(:venue, name: "Auditorium Theatre")
    @chicago = FactoryBot.create(:venue, name: "Chicago Theatre")
    @vic = FactoryBot.create(:venue, name: "Vic Theatre")
  end

  describe "if not logged in" do
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

  describe "if logged in" do
    let(:user) { FactoryBot.create(:user) }

    before(:example) do
      login(user)
      #needed so can sort 3 out of 4 alphatbetically (other one won't be "followed")
      @riviera = FactoryBot.create(:venue, name: "Riviera Theatre")
    end

    it "sorts venues by name", :js do
      visit venues_path
      expect(page).to have_selector("#auditorium_theatre_chicago")
      expect(page).to have_selector("#chicago_theatre_chicago")
      expect(page).to have_selector("#riviera_theatre_chicago")
      expect(page).to have_selector("#vic_theatre_chicago")
      #default order is alphabetical
      expect(@auditorium.name).to appear_before(@chicago.name)
      expect(@chicago.name).to appear_before(@vic.name)
      click_button "Sort by venue name"
      sleep(1)
      #should be reverse alphatbetical order
      expect(@vic.name).to appear_before(@chicago.name)
      expect(@chicago.name).to appear_before(@auditorium.name)
      click_button "Sort by venue name"
      sleep(1)
      #now should be back to alphabetical
      expect(@auditorium.name).to appear_before(@chicago.name)
      expect(@chicago.name).to appear_before(@vic.name)
    end
  end
end
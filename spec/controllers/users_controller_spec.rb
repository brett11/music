require 'rails_helper'


RSpec.describe UsersController, type: :controller do
  #https://relishapp.com/rspec/rspec-rails/v/2-99/docs/controller-specs/use-of-capybara-in-controller-specs
  include Capybara::DSL

  describe "GET index" do
    it "redirects to root path when user not logged in" do
      get :index
      #http://stackoverflow.com/questions/5228371/how-to-get-current-path-with-query-string-using-capybara
      expect(page).to have_current_path(root_path)
    end
  end

end

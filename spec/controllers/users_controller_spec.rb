require 'rails_helper'


RSpec.describe UsersController, type: :controller do
  #https://relishapp.com/rspec/rspec-rails/v/2-99/docs/controller-specs/use-of-capybara-in-controller-specs
  include Capybara::DSL

  describe "GET index" do
    it "redirects to login path when user not logged in and shows login flash" do
      get :index
      #http://stackoverflow.com/questions/5228371/how-to-get-current-path-with-query-string-using-capybara
      #expect(page).to have_current_path(root_path)


      expect(response).to redirect_to(:login)
      #flash generated by logged_in_user helper
      expect(flash[:danger]).to eq("Please log in.")
    end
  end

  describe "GET new" do
    it "is a successful signup request which assigns a blank user instance variable" do
      get :new
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:new)
      #pg 57 of Rails book
      expect(assigns(:user)).to be_present
    end
  end

  describe "POST create" do
    it "redirects to root_url upon successful user creation and shows flash" do
      new_user_params = FactoryGirl.attributes_for(:user)
      post :create, params: {user: new_user_params}
      expect(assigns(:user)).to be_present
      #pg 57 of Rails testing book
      expect(response).to redirect_to(:root)
      #pg 143 of Rails testing book
      expect(flash[:info]).to eq("Please check your email to activate your account.")
    end

    it "renders signup upon user creation failure" do
      #posting below with password_confirmation that doesn't match
      post :create, params: {user: {name_first: 'Bob', name_last: 'Smith', email:'foo@bar.com', password:'foo', password_confirmation: 'bar'} }
      #pg 141 of Rails testing book
      expect(response).to render_template(:new)
    end
  end


end

require 'rails_helper'
require 'pry'

RSpec.describe ArtistsController, type: :controller do
  describe "POST create" do

    before(:example) do
      login_admin
    end

    it "redirects to artists_url upon successful artist creation and shows flash" do
      new_artist_params = FactoryGirl.attributes_for(:artist)
      post :create, params: {artist: new_artist_params}
      expect(assigns(:artist)).to be_present
      #pg 57 of Rails testing book
      expect(response).to redirect_to(:artists)
      #pg 143 of Rails testing book
      expect(flash[:success]).to eq("Artist successfully created.")
    end

    it "renders new upon artist creation failure" do
      #posting below with password_confirmation that doesn't match
      #binding.pry
      post :create, params: {artist: {name_first: 'Bob', name_last: ''} }
      #pg 141 of Rails testing book
      expect(response).to render_template(:new)
    end
  end
end

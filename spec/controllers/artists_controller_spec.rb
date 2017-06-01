require 'rails_helper'

RSpec.describe ArtistsController, type: :controller do
  describe "POST create" do
    it "redirects to root_url upon successful user creation and shows flash" do
      new_artist_params = FactoryGirl.attributes_for(:artist)
      post :create, params: {artist: new_artist_params}
      expect(assigns(:artist)).to be_present
      #pg 57 of Rails testing book
      expect(response).to redirect_to(:root)
      #pg 143 of Rails testing book
      expect(flash[:success]).to eq("Artist info successfully updated")
    end

    it "renders new upon user creation failure" do
      #posting below with password_confirmation that doesn't match
      post :create, params: {artist: {name_first: 'Bob', name_last: 'Smith', email:'foo@bar.com', password:'foo', password_confirmation: 'bar'} }
      #pg 141 of Rails testing book
      expect(response).to render_template(:new)
    end
  end
end

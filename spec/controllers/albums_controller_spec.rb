require 'rails_helper'
require 'pry'

RSpec.describe AlbumsController, type: :controller do
  describe "POST create" do
    let(:new_album_params) { FactoryGirl.attributes_for(:album) }

    before(:example) do
      #because of how factories work, the "new_album_params" has an artists attribute. Need to delete and replace
      #with artist_ids, as this is how the params will be coming in through the view
      artist_ids = []
      new_album_params[:artists].each do |artist|
        artist_ids << artist.id
      end
      new_album_params[:artist_ids] = artist_ids
    end

    it "redirects to albums_url upon successful album creation and shows flash" do
      #binding.pry
      post :create, params: {album: new_album_params}
      expect(assigns(:album)).to be_present
      #pg 57 of Rails testing book
      expect(response).to redirect_to(:albums)
      #pg 143 of Rails testing book
      expect(flash[:success]).to eq("Album successfully added.")
    end

    it "renders new upon album creation failure" do
      #below will trigger validation error
      new_album_params[:name] = ""
      #binding.pry
      post :create, params: {album: new_album_params}
      #pg 141 of Rails testing book
      expect(response).to render_template(:new)
    end
  end
end

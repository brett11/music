require 'rails_helper'
require 'pry'

RSpec.describe AlbumsController, type: :controller do
  describe "POST create" do
    it "redirects to albums_url upon successful album creation and shows flash" do
      new_album_params = FactoryGirl.attributes_for(:album)
      #because of how factories work, the "new_album_params" have an artists attribute. Need to delete and replace
      #with artist_ids, as this is how the params will be coming in through the view
      artist_ids = []
      new_album_params[:artists].each do |artist|
        artist_ids << artist.id
      end
      new_album_params[:artist_ids] = artist_ids
      #binding.pry
      post :create, params: {album: new_album_params}
      expect(assigns(:album)).to be_present
      #pg 57 of Rails testing book
      expect(response).to redirect_to(:albums)
      #pg 143 of Rails testing book
      expect(flash[:success]).to eq("Album successfully added.")
    end

    it "renders new upon album creation failure" do
      new_album_params = FactoryGirl.attributes_for(:album)
      #because of how factories work, the "new_album_params" have an artists attribute. Need to delete and replace
      #with artist_ids, as this is how the params will be coming in through the view
      artist_ids = []
      new_album_params[:artists].each do |artist|
        artist_ids << artist.id
      end
      new_album_params[:artist_ids] = artist_ids
      #below will trigger validation error
      new_album_params[:name] = ""
      #binding.pry
      post :create, params: {album: new_album_params}
      #pg 141 of Rails testing book
      expect(response).to render_template(:new)
    end
  end
end

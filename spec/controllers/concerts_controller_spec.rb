require 'rails_helper'
require 'pry'

RSpec.describe ConcertsController, type: :controller do
  describe "POST create" do
    it "redirects to concerts_url upon successful concert creation and shows flash" do
      new_concert_params = FactoryGirl.attributes_for(:concert)
      artist_ids = []
      new_concert_params[:artists].each do |artist|
        artist_ids << artist.id
      end
      new_concert_params[:artist_ids] = artist_ids

      new_concert_params[:venue_id] = new_concert_params[:venue].id

      post :create, params: {concert: new_concert_params}
      expect(assigns(:concert)).to be_present
      expect(response).to redirect_to(:concerts)
      expect(flash[:success]).to eq("Show successfully added.")
    end

    it "renders new upon concert creation failure" do
      new_concert_params = FactoryGirl.attributes_for(:concert)
      artist_ids = []
      new_concert_params[:artists].each do |artist|
        artist_ids << artist.id
      end
      new_concert_params[:artist_ids] = artist_ids
      new_concert_params[:venue_id] = new_concert_params[:venue].id
      #below is so that the create will fail validations
      post :create, params: {concert: new_concert_params}
      expect(response).to render_template(:new)
    end
  end
end

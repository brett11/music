require 'rails_helper'
require 'pry'

RSpec.describe ConcertsController, type: :controller do
  describe "POST create" do
    let(:new_concert_params) { FactoryGirl.attributes_for(:concert) }

    before(:example) do
      #because of how factories work, the "new_concert_params" has an artists attribute. Need to delete and replace
      #with artist_ids, as this is how the params will be coming in through the view
      artist_ids = []
      new_concert_params[:artists].each do |artist|
        artist_ids << artist.id
      end
      new_concert_params[:artist_ids] = artist_ids
    end

    before(:example) do
      #because of how factories work, the "new_concert_params" has a venue attribute. Need to delete and replace
      #with venue_id, as this is how the params will be coming in through the view
      new_concert_params[:venue_id] = new_concert_params[:venue].id
    end


    it "redirects to concerts_url upon successful concert creation and shows flash" do
      post :create, params: {concert: new_concert_params}
      expect(assigns(:concert)).to be_present
      expect(response).to redirect_to(:concerts)
      expect(flash[:success]).to eq("Show successfully added.")
    end

    it "renders new upon concert creation failure" do
      #pg 123 of rails testing book
      concert_partial_stub = Concert.new(new_concert_params)
      expect(concert_partial_stub).to receive(:save).and_return(false)
      expect(Concert).to receive(:new_from_controller).and_return(concert_partial_stub)
      post :create, params: {concert: new_concert_params}
      expect(response).to render_template(:new)
    end
  end
end

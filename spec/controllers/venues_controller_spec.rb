require 'rails_helper'

RSpec.describe VenuesController, type: :controller do


  describe "POST create" do
    let(:new_venue_params) { FactoryGirl.attributes_for(:venue)}

    before(:example) do
      #because of how factories work, the "new_venue_params" has a city attribute, containing an instance of City. Need to delete and replace
      #with city_id, as this is how the params will be coming in through the view
      new_venue_params[:city_id] = new_venue_params[:city].id
    end

    it "redirects to venues_url upon successful venue creation and shows flash" do
      post :create, params: {venue: new_venue_params}
      expect(assigns(:venue)).to be_present
      #pg 57 of Rails testing book
      expect(response).to redirect_to(:venues)
      #pg 143 of Rails testing book
      expect(flash[:success]).to eq("Venue successfully added.")
    end

    it "renders new upon venue creation failure" do
      #pg 123 of rails testing book
      venue_partial_stub = Venue.new(new_venue_params)
      expect(venue_partial_stub).to receive(:save).and_return(false)
      expect(Venue).to receive(:new_from_controller).and_return(venue_partial_stub)
      post :create, params: {venue: new_venue_params}
      expect(response).to render_template(:new)
    end
  end
end

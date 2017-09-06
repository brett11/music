require 'rails_helper'
require_relative '../support/shared_examples'

RSpec.describe VenuesController, type: :controller do
  before(:example) do
    @venue = FactoryGirl.create(:venue)
  end

  describe "GET index" do
    custom_params = { direction: "desc", page: "1", sort: "name", sort_table: "Venue" }

    it_behaves_like "working get index controller", :venues, custom_params
  end

  describe "GET new" do
    it_behaves_like "working get new controller", :venue, :root
  end

  describe "POST create" do
    new_venue_params = FactoryGirl.attributes_for(:venue)

    before(:example) do
      #because of how factories work, the "new_venue_params" has a city attribute, containing an instance of City. Need to delete and replace
      #with city_id, as this is how the params will be coming in through the view
      new_venue_params[:city_id] = new_venue_params[:city].id
    end

    it_behaves_like "working post create controller", :venue, new_venue_params
  end

  describe "GET edit" do
    venue_instance = FactoryGirl.create(:venue)
    it_behaves_like "working get edit controller", :venue, venue_instance
  end

  describe "POST update" do
    venue_instance = FactoryGirl.create(:venue)
    it_behaves_like "working post update controller", :venue, venue_instance, :name, "New Venue Name"

    # describe "before admin login" do
    #   it "does not allow" do
    #     post :update, params: {id: @venue.id, venue: {name: "New Venue Name"}}
    #     expect(assigns(:venue)).to_not be_present
    #     expect(response).to redirect_to(:root)
    #   end
    # end
    #
    # describe"after admin login" do
    #   before(:example) do
    #     login_admin
    #   end
    #
    #   it "redirects to venues_url upon successful creation and shows flash" do
    #     post :update, params: {id: @venue.id, venue: {name: "New Venue Name"}}
    #     expect(assigns(:venue)).to be_present
    #     #pg 57 of Rails testing book
    #     expect(response).to redirect_to(@venue)
    #     #pg 143 of Rails testing book
    #     expect(flash[:success]).to eq("Venue info successfully updated")
    #   end
    #
    #   it "renders edit upon update failure" do
    #     #posting below without name, which will cause failure of update
    #     #binding.pry
    #     post :update, params: {id: @venue.id, venue: {name: ""}}
    #     #pg 141 of Rails testing book
    #     expect(response).to render_template(:edit)
    #   end
    # end
  end
end

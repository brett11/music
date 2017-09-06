require 'rails_helper'
require 'pry'
require_relative '../support/shared_examples'

RSpec.describe ConcertsController, type: :controller do
  before(:example) do
    @concert = FactoryGirl.create(:concert)
  end

  describe "GET index" do
    custom_params = { direction: "desc", page: "1", sort: "dateandtime", sort_table: "Concert" }

    it_behaves_like "working get index controller", :concerts, custom_params
  end

  describe "GET new" do
    it_behaves_like "working get new controller", :concert, :root
  end

  describe "POST create" do
    new_concert_params = FactoryGirl.attributes_for(:concert)

    before(:example) do
      #because of how factories work, the "new_concert_params" has an artists attribute. Need to delete and replace
      #with artist_ids, as this is how the params will be coming in through the view
      new_concert_params[:artist_ids] = new_concert_params[:artists].collect do |artist|
        artist.id
      end
      #because of how factories work, the "new_concert_params" has a venue attribute. Need to delete and replace
      #with venue_id, as this is how the params will be coming in through the view
      new_concert_params[:venue_id] = new_concert_params[:venue].id
    end

    it_behaves_like "working post create controller", :concert, new_concert_params

  end

  describe "GET edit" do
    concert_instance = FactoryGirl.create(:concert)
    it_behaves_like "working get edit controller", :concert, concert_instance
  end

  describe "POST update" do
    concert_instance = FactoryGirl.create(:concert)
    it_behaves_like "working post update controller", :concert, concert_instance, :dateandtime, "2017-12-15 20:00:00"
  end
end

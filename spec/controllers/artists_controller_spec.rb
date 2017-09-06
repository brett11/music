require 'rails_helper'
require 'pry'
require_relative '../support/shared_examples'

RSpec.describe ArtistsController, type: :controller do
  #below needed so that @albums will be assigned within controller to something, be non-nil, and pass GET index works be_present test
  before(:example) do
    @artist1 = FactoryGirl.create(:artist)
  end

  describe "GET index" do
    custom_params = { direction: "desc", page: "1", sort: "name_stage", sort_table: "Artist" }

    it_behaves_like "working get index controller", :artists, custom_params
  end


  describe "GET new" do
    it_behaves_like "working get new controller", :artist, :root
  end

  describe "POST create" do
    new_artist_params =  FactoryGirl.attributes_for(:artist)

    it_behaves_like "working post create controller", :artist, new_artist_params
  end

  describe "GET edit" do
    artist_instance = FactoryGirl.create(:artist)
    it_behaves_like "working get edit controller", :artist, artist_instance
  end

  describe "POST update" do
    artist_instance = FactoryGirl.create(:artist)
    it_behaves_like "working post update controller", :artist, artist_instance, :name_stage, "New Band Name"
  end
end

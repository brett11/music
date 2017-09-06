require 'rails_helper'
require_relative '../support/shared_examples'

RSpec.describe AlbumsController, type: :controller do
  #below needed so that @albums will be assigned within controller to something, be non-nil, and pass GET index works be_present test
  before(:each) do
    @album = FactoryGirl.create(:album)
  end

  describe "GET index" do
    custom_params = { direction: "desc", page: "1", search: "", sort: "name", sort_table: "Album", sort_favs: "" }

    it_behaves_like "working get index controller", :albums, custom_params
  end

  describe "GET new" do
    it_behaves_like "working get new controller", :album, :root
  end

  describe "POST create" do
    new_album_params = FactoryGirl.attributes_for(:album)

    before(:example) do
      #because of how factories work, the "new_album_params" has an artists attribute. Need to delete and replace
      #with artist_ids, as this is how the params will be coming in through the view
      new_album_params[:artist_ids] =  new_album_params[:artists].collect do |artist|
         artist.id
      end
    end

    it_behaves_like "working post create controller", :album, new_album_params
  end

  describe "GET edit" do
    album_instance = FactoryGirl.create(:album)
    it_behaves_like "working get edit controller", :album, album_instance
  end

  describe "POST update" do
    album_instance = FactoryGirl.create(:album)
    it_behaves_like "working post update controller", :album, album_instance, :name, "New Album Name"
  end
end

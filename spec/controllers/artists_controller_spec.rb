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
    let(:new_artist_params) { FactoryGirl.attributes_for(:artist) }

    describe "before admin login" do
      it "does not allow" do
        post :create, params: {artist: new_artist_params}
        expect(assigns(:artist)).to_not be_present
        expect(response).to redirect_to(:root)
      end
    end

    describe"after admin login" do
      before(:example) do
        login_admin
      end

      it "redirects to artists_url upon successful artist creation and shows flash" do
        post :create, params: {artist: new_artist_params}
        expect(assigns(:artist)).to be_present
        #pg 57 of Rails testing book
        expect(response).to redirect_to(:artists)
        #pg 143 of Rails testing book
        expect(flash[:success]).to eq("Artist successfully created.")
      end

      it "renders new upon artist creation failure" do
        #posting below without name_stage, which will cause failure
        #binding.pry
        post :create, params: {artist: {name_stage: ''} }
        #pg 141 of Rails testing book
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET edit" do
    describe "before admin login" do
      it "does not work" do
        get :edit, params: {id: @artist1.id }
        expect(assigns(:artist)).to_not be_present
        expect(response).to redirect_to(:root)
      end
    end

    describe "after login" do
      before(:example) do
        login_admin
      end

      it "does work" do
        get :edit, params: {id: @artist1.id }
        expect(assigns(:artist)).to be_present
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "POST update" do
    describe "before admin login" do
      it "does not allow" do
        post :update, params: {id: @artist1.id, artist: {name_stage: "New Band Name"}}
        expect(assigns(:artist)).to_not be_present
        expect(response).to redirect_to(:root)
      end
    end

    describe"after admin login" do
      before(:example) do
        login_admin
      end

      it "redirects to artists_url upon successful artist creation and shows flash" do
        post :update, params: { id: @artist1.id, artist: {name_stage: "New Band Name"}}
        expect(assigns(:artist)).to be_present
        #pg 57 of Rails testing book
        expect(response).to redirect_to(@artist1)
        #pg 143 of Rails testing book
        expect(flash[:success]).to eq("Artist info successfully updated")
      end

      it "renders edit upon artist update failure" do
        #posting below without name_stage, which will cause failure of update
        #binding.pry
        post :update, params: { id: @artist1.id, artist: {name_stage: ""}}
        #pg 141 of Rails testing book
        expect(response).to render_template(:edit)
      end
    end
  end
end

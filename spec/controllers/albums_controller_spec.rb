require 'rails_helper'
require 'pry'

RSpec.describe AlbumsController, type: :controller do
  before(:example) do
    @album = FactoryGirl.create(:album)
  end

  describe "GET index" do
    #below needed so that @albums will be assigned within controller to something, be non-nil, and pass GET index works be_present test
    it "works" do
      get :index
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
      expect(assigns(:albums)).to be_present
    end
  end

  describe "GET new" do
    describe "before admin login" do
      it "does not work" do
        get :new
        expect(assigns(:album)).to_not be_present
        expect(response).to redirect_to(:root)
      end
    end

    describe "after login" do
      before(:example) do
        login_admin
      end

      it "does work" do
        get :new
        expect(assigns(:album)).to be_present
        expect(response).to render_template(:new)
      end
    end
  end

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

    describe "before admin login" do
      it "does not allow" do
        post :create, params: {album: new_album_params}
        expect(assigns(:album)).to_not be_present
        expect(response).to redirect_to(:root)
      end
    end


    describe "after admin login" do
      before(:example) do
        login_admin
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

  describe "GET edit" do
    describe "before admin login" do
      it "does not work" do
        get :edit, params: {id: @album.id }
        expect(assigns(:album)).to_not be_present
        expect(response).to redirect_to(:root)
      end
    end

    describe "after login" do
      before(:example) do
        login_admin
      end

      it "does work" do
        get :edit, params: {id: @album.id }
        expect(assigns(:album)).to be_present
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "POST update" do
    describe "before admin login" do
      it "does not allow" do
        post :update, params: {id: @album.id, album: {name: "New Album Name"}}
        expect(assigns(:album)).to_not be_present
        expect(response).to redirect_to(:root)
      end
    end

    describe"after admin login" do
      before(:example) do
        login_admin
      end

      it "redirects to albums_url upon successful creation and shows flash" do
        post :update, params: { id: @album.id, album: {name: "New Album Name"}}
        expect(assigns(:album)).to be_present
        #pg 57 of Rails testing book
        expect(response).to redirect_to(@album)
        #pg 143 of Rails testing book
        expect(flash[:success]).to eq("Album info successfully updated")
      end

      it "renders edit upon update failure" do
        #posting below without name, which will cause failure of update
        #binding.pry
        post :update, params: { id: @album.id, album: {name: ""}}
        #pg 141 of Rails testing book
        expect(response).to render_template(:edit)
      end
    end
  end
end

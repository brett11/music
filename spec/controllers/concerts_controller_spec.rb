require 'rails_helper'
require 'pry'

RSpec.describe ConcertsController, type: :controller do
  before(:example) do
    @concert = FactoryGirl.create(:concert)
  end

  describe "GET index" do
    it "works" do
      get :index
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
      expect(assigns(:concerts)).to be_present
    end
  end

  describe "GET new" do
    describe "before admin login" do
      it "does not work" do
        get :new
        expect(assigns(:concert)).to_not be_present
        expect(response).to redirect_to(:root)
      end
    end

    describe "after login" do
      before(:example) do
        login_admin
      end

      it "does work" do
        get :new
        expect(assigns(:concert)).to be_present
        expect(response).to render_template(:new)
      end
    end
  end

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

    describe "before admin login" do
      it "does not allow" do
        post :create, params: {concert: new_concert_params}
        expect(assigns(:concert)).to_not be_present
        expect(response).to redirect_to(:root)
      end
    end

    describe "after admin login" do
      before(:example) do
        login_admin
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

  describe "GET edit" do
    describe "before admin login" do
      it "does not work" do
        get :edit, params: {id: @concert.id }
        expect(assigns(:concert)).to_not be_present
        expect(response).to redirect_to(:root)
      end
    end

    describe "after login" do
      before(:example) do
        login_admin
      end

      it "does work" do
        get :edit, params: {id: @concert.id }
        expect(assigns(:concert)).to be_present
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "POST update" do
    describe "before admin login" do
      it "does not allow" do
        post :update, params: {id: @concert.id, concert: {dateandtime: "2017-12-15 20:00:00"}}
        expect(assigns(:concert)).to_not be_present
        expect(response).to redirect_to(:root)
      end
    end

    describe"after admin login" do
      before(:example) do
        login_admin
      end

      it "redirects to concerts_url upon successful creation and shows flash" do
        post :update, params: {id: @concert.id, concert: {dateandtime: "2017-12-15 20:00:00"}}
        expect(assigns(:concert)).to be_present
        #pg 57 of Rails testing book
        expect(response).to redirect_to(@concert)
        #pg 143 of Rails testing book
        expect(flash[:success]).to eq("Concert info successfully updated")
      end

      it "renders edit upon update failure" do
        #posting below without dateandtime, which will cause failure of update
        #binding.pry
        post :update, params: {id: @concert.id, concert: {dateandtime: ""}}
        #pg 141 of Rails testing book
        expect(response).to render_template(:edit)
      end
    end
  end
end

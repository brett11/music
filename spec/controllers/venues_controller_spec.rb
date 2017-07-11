require 'rails_helper'

RSpec.describe VenuesController, type: :controller do
  before(:example) do
    @venue = FactoryGirl.create(:venue)
  end

  describe "GET index" do
    it "works" do
      get :index
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
      expect(assigns(:venues)).to be_present
    end
  end

  describe "GET new" do
    describe "before admin login" do
      it "does not work" do
        get :new
        expect(assigns(:venue)).to_not be_present
        expect(response).to redirect_to(:root)
      end
    end

    describe "after login" do
      before(:example) do
        login_admin
      end

      it "does work" do
        get :new
        expect(assigns(:venue)).to be_present
        expect(response).to render_template(:new)
      end
    end
  end

  describe "POST create" do
    let(:new_venue_params) { FactoryGirl.attributes_for(:venue)}

    before(:example) do
      #because of how factories work, the "new_venue_params" has a city attribute, containing an instance of City. Need to delete and replace
      #with city_id, as this is how the params will be coming in through the view
      new_venue_params[:city_id] = new_venue_params[:city].id
    end

    describe "before admin login" do
      it "does not allow" do
        post :create, params: {venue: new_venue_params}
        expect(assigns(:venue)).to_not be_present
        expect(response).to redirect_to(:root)
      end
    end


    describe "after admin login" do
      before(:example) do
        login_admin
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

  describe "GET edit" do
    describe "before admin login" do
      it "does not work" do
        get :edit, params: {id: @venue.id }
        expect(assigns(:venue)).to_not be_present
        expect(response).to redirect_to(:root)
      end
    end

    describe "after login" do
      before(:example) do
        login_admin
      end

      it "does work" do
        get :edit, params: {id: @venue.id }
        expect(assigns(:venue)).to be_present
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "POST update" do
    describe "before admin login" do
      it "does not allow" do
        post :update, params: {id: @venue.id, venue: {name: "New Venue Name"}}
        expect(assigns(:venue)).to_not be_present
        expect(response).to redirect_to(:root)
      end
    end

    describe"after admin login" do
      before(:example) do
        login_admin
      end

      it "redirects to venues_url upon successful creation and shows flash" do
        post :update, params: {id: @venue.id, venue: {name: "New Venue Name"}}
        expect(assigns(:venue)).to be_present
        #pg 57 of Rails testing book
        expect(response).to redirect_to(@venue)
        #pg 143 of Rails testing book
        expect(flash[:success]).to eq("Venue info successfully updated")
      end

      it "renders edit upon update failure" do
        #posting below without name, which will cause failure of update
        #binding.pry
        post :update, params: {id: @venue.id, venue: {name: ""}}
        #pg 141 of Rails testing book
        expect(response).to render_template(:edit)
      end
    end
  end
end

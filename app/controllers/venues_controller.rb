class VenuesController < ApplicationController
  before_action :set_venue, only:[:show, :edit, :update, :destroy]

  def show
  end

  def index
    @venues = Venue.paginate(page: params[:page]).order(id: :desc)
  end

  def new
    @venue = Venue.new
  end

  def create
    # album params artist returns artist id only per pry byebug
    #binding.pry
    #rails 4 testing pg 134 --it is best to create method that calls third party method, if you are planning to stub in a test, as we are in the create failure test
    @venue = Venue.new_from_controller(venue_params_name_only)
    @venue.city = City.find(venue_params[:city_id])
    respond_to do |format|
      format.html do
        if @venue.save
          flash[:success] = "Venue successfully added."
          redirect_to venues_url
        else
          flash[:warning] = "Please try again."
          render 'new'

        end
      end
      format.js
    end
  end

  private
  def venue_params
    params.require(:venue).permit(:name, :city_id)
  end

  def venue_params_name_only
    params.require(:venue).permit(:name)
  end

  def set_venue
    @venue= Venue.find(params[:id])
  end
end

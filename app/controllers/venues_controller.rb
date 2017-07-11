#require 'pry'

class VenuesController < ApplicationController
  before_action :admin_user, only: [:new, :create, :edit, :update]
  # before_action :set_venue, only:[:show, :edit, :update]

  #http://railscasts.com/episodes/228-sortable-table-columns?view=comments
  helper_method :sort_column, :sort_direction, :sort_table

  def index
    if sort_params[:sort_table] == "City"
      @venues = sort_by_city
    else
      # binding.pry
      @venues = sort
    end
  end

  def show
    @venue= Venue.find(params[:id])
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

  def edit
    @venue = Venue.find(params[:id])
  end

  def update
    @venue = Venue.find(params[:id])
    if @venue.update_attributes(venue_params)
      flash[:success] = "Venue info successfully updated"
      redirect_to @venue
    else
      render 'edit'
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

  def sort_params
    params.permit(:sort_table, :sort, :direction, :page, :search, :utf8)
  end

  def sort_table
    if sort_params[:sort_table].present?
      sort_params[:sort_table]
    else
      "Venue"
    end
  end

  def sort_direction
    %w[asc desc].include?(sort_params[:direction]) ? sort_params[:direction] : "asc"
  end

  def sort_column(sort_table)
    if sort_table == "Venue"
      Venue.column_names.include?(sort_params[:sort]) ? sort_params[:sort] : "name"
    elsif sort_table == "City"
      City.column_names.include?(sort_params[:sort]) ? sort_params[:sort] : "name"
    end
  end

  def sort
    Venue.search(sort_params[:search]).reorder(sort_column(sort_table) + " " + sort_direction).paginate(page: sort_params[:page])
  end

  #http://railscasts.com/episodes/228-sortable-table-columns?view=comments nico44
  #https://apidock.com/rails/ActiveRecord/QueryMethods/order, "User.order('name DESC, email')" example
  # def sort_by_city
  #   Venue.search(sort_params[:search]).includes(:city).reorder("\"cities\"." + "\"" + sort_column(sort_table) + "\"" + " #{sort_direction}")
  #     .paginate( page: params[:page] )
  # end

  #https://stackoverflow.com/questions/19616611/rails-order-by-association-field Gary S. Weaver's comment
  # below doesn't work because sort_column result is name, which is interpreted as venue name. Specifying cities.name results in error
  # def sort_by_city
  #   Venue.search(sort_params[:search]).joins(:city).merge(City.reorder(sort_column(sort_table) + " #{sort_direction}"))
  #     .paginate( page: params[:page] )
  # end

end

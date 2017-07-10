#require 'pry'

class ConcertsController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy]

  #http://railscasts.com/episodes/228-sortable-table-columns?view=comments
  helper_method :sort_column, :sort_direction, :sort_table

  def show
    @concert = Concert.find(params[:id])
  end

  def index
    #@concerts = Concert.paginate(page: params[:page]).where('dateandtime > ?', DateTime.now).order("dateandtime ASC")
    # sometimes sort albums based on artist
    if sort_params[:sort_table] == "Artist"
      @concerts = sort_by_artist
    else
      # binding.pry
      @concerts = sort
    end
  end

  def new
    @concert = Concert.new
  end

  def create
    # album params artist returns artist id only per pry byebug
    #binding.pry
    #rails 4 testing pg 134 --it is best to create method that calls third party method, if you are planning to stub in a test, as we are in the create failure test
    @concert = Concert.new_from_controller(concert_params_dateandtime_only)
    @concert.venue = Venue.find(concert_params[:venue_id])
    @artist_ids = concert_params[:artist_ids]
    @artist_ids.each do |artist_id|
      artist = Artist.find(artist_id)
      @concert.artists << artist
    end
    respond_to do |format|
      format.html do
        if @concert.save
          flash[:success] = "Show successfully added."
          redirect_to concerts_url
        else
          flash[:warning] = "Please try again."
          render 'new'

        end
      end
      format.js
    end
  end

  private

    def concert_params
      params.require(:concert).permit(:dateandtime, :venue_id, artist_ids: [] )
    end

    def concert_params_dateandtime_only
      params.require(:concert).permit(:dateandtime)
    end

    def sort_params
      params.permit(:sort_table, :sort, :direction, :page, :search, :utf8)
    end

    def sort_table
      if sort_params[:sort_table].present?
        sort_params[:sort_table]
      else
        "Concert"
      end
    end

    def sort_direction
      %w[asc desc].include?(sort_params[:direction]) ? sort_params[:direction] : "asc"
    end

    def sort_column(sort_table)
      if sort_table == "Concert"
        Concert.column_names.include?(sort_params[:sort]) ? sort_params[:sort] : "id"
      elsif sort_table == "Artist"
        Artist.column_names.include?(sort_params[:sort]) ? sort_params[:sort] : "name_stage"
      end
    end

    def sort
      # Concert.paginate(page: params[:page]).where('dateandtime > ?', DateTime.now).order("dateandtime ASC")
      # binding.pry
      Concert.search(sort_params[:search]).where('dateandtime > ?', DateTime.now).reorder(sort_column(sort_table) + " " + sort_direction).paginate(page: sort_params[:page])
    end

    #http://railscasts.com/episodes/228-sortable-table-columns?view=comments nico44
    #https://apidock.com/rails/ActiveRecord/QueryMethods/order, "User.order('name DESC, email')" example
    # def sort_by_artist
    #   Concert.search(sort_params[:search]).includes(:artists).reorder("\"artists\"." + "\"" + sort_column(sort_table) + "\"" + " #{sort_direction}")
    #     .paginate( page: params[:page] )
    #https://stackoverflow.com/questions/19616611/rails-order-by-association-field Gary S. Weaver's comment
    def sort_by_artist
      Concert.search(sort_params[:search]).where('dateandtime > ?', DateTime.now).joins(:artists).merge(Artist.reorder(sort_column(sort_table) + " #{sort_direction}"))
        .paginate( page: params[:page] )
    end

end

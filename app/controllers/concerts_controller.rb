class ConcertsController < ApplicationController
  before_action :admin_user, only: [:new, :create, :edit, :update]

  #http://railscasts.com/episodes/228-sortable-table-columns?view=comments
  helper_method :sort_column, :sort_direction, :sort_table

  def show
    @concert = Concert.find(params[:id])
  end

  def index
    #@concerts = Concert.paginate(page: params[:page]).where('dateandtime > ?', DateTime.now).order("dateandtime ASC")
    # sometimes sort albums based on artist
    if sort_favs?
      if params[:sort_table] == "Artist"
        @concerts = sort_my_favs_by_artist
      else
        @concerts = sort_my_favs
      end
    else
      if params[:sort_table] == "Artist"
        @concerts = sort_by_artist
      else
        # binding.pry
        @concerts = sort
      end
    end

    respond_to do |format|
      format.html
      format.js
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
          flash[:success] = "Concert successfully added."
          redirect_to concerts_url
        else
          flash[:warning] = "Please try again."
          render 'new'

        end
      end
      format.js
    end
  end

  def edit
    @concert = Concert.find(params[:id])
  end

  def update
    @concert = Concert.find(params[:id])
    if @concert.update_attributes(concert_params)
      flash[:success] = "Concert info successfully updated"
      redirect_to @concert
    else
      render 'edit'
    end
  end

  private

    def concert_params
      params.require(:concert).permit(:dateandtime, :venue_id, artist_ids: [] )
    end

    def concert_params_dateandtime_only
      params.require(:concert).permit(:dateandtime)
    end

    # below not necessary because no mass assignment used in sorting
    # def sort_params
    #   params.permit(:sort_table, :sort, :direction, :page, :search, :utf8, :sort_favs)
    # end

    def sort_table
      artist_album_array = %w(Artist Concert)
      artist_album_array.include?(params[:sort_table]) ? params[:sort_table] : "Concert"
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

    def sort_column(sort_table)
      if sort_table == "Concert"
        Concert.column_names.include?(params[:sort]) ? params[:sort] : "dateandtime"
      elsif sort_table == "Artist"
        Artist.column_names.include?(params[:sort]) ? params[:sort] : "name_stage"
      end
    end

    def sort_favs?
      #in below, we need to make sure that method returns a boolean and not a string, as "false" as string evaluates to true
      if params[:sort_favs].present? && params[:sort_favs] == "true"
        true
      else
        false
      end
    end

    def sort
      # Concert.paginate(page: params[:page]).where('dateandtime > ?', DateTime.now).order("dateandtime ASC")
      # binding.pry
      Concert.search(params[:search]).where('dateandtime > ?', DateTime.now).reorder(sort_column(sort_table) + " " + sort_direction).paginate(page: params[:page])
    end

    #http://railscasts.com/episodes/228-sortable-table-columns?view=comments nico44
    #https://apidock.com/rails/ActiveRecord/QueryMethods/order, "User.order('name DESC, email')" example
    # def sort_by_artist
    #   Concert.search(params[:search]).includes(:artists).reorder("\"artists\"." + "\"" + sort_column(sort_table) + "\"" + " #{sort_direction}")
    #     .paginate( page: params[:page] )
    #https://stackoverflow.com/questions/19616611/rails-order-by-association-field Gary S. Weaver's comment
    def sort_by_artist
      Concert.search(params[:search]).where('dateandtime > ?', DateTime.now).joins(:artists).merge(Artist.reorder(sort_column(sort_table) + " " + sort_direction))
        .paginate( page: params[:page] )
    end

    def sort_my_favs
      Concert.search(params[:search]).where('dateandtime > ?', DateTime.now).joins(:artists).merge(current_user.following).reorder(sort_column(sort_table) + " " + sort_direction).paginate(page: params[:page])
    end

    def sort_my_favs_by_artist
      Concert.search(params[:search]).where('dateandtime > ?', DateTime.now).joins(:artists).merge(current_user.following).merge(Artist.reorder(sort_column(sort_table) + " " + sort_direction))
        .paginate( page: params[:page] )
    end

end

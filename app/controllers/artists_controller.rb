class ArtistsController < ApplicationController
  before_action :admin_user, only: [:new, :create, :edit, :update]

  #http://railscasts.com/episodes/228-sortable-table-columns?view=comments
  helper_method :sort_column, :sort_direction, :sort_table

  #http://railscasts.com/episodes/228-sortable-table-columns?view=comments
  #http://railscasts.com/episodes/240-search-sort-paginate-with-ajax?autoplay=true
  #reorder because https://stackoverflow.com/questions/14286207/how-to-remove-ranking-of-query-results
  def index
    # binding.pry
    if sort_favs?
      @artists=current_user.following.search(params[:search]).reorder(sort_column(sort_table) + " " + sort_direction).paginate(page: params[:page])
    else
      @artists=Artist.search(params[:search]).reorder(sort_column(sort_table) + " " + sort_direction).paginate(page: params[:page])
    end



    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @artist = Artist.find(params[:id])
    @artist_concerts = @artist.concerts.where('dateandtime > ?', DateTime.now).order("dateandtime ASC").paginate(page: params[:page])

  end

  def new
    @artist = Artist.new
  end

  def create
    @artist = Artist.new(artist_params)
    respond_to do |format|
      format.html do
        if @artist.save
          flash[:success] = "Artist successfully created."
          redirect_to artists_url
        else
          flash[:info] = "Please try again."
          render 'new'
        end
      end
      format.js
    end
  end

  def edit
    @artist = Artist.find(params[:id])
  end

  def update
    @artist = Artist.find(params[:id])
    if @artist.update_attributes(artist_params)
      flash[:success] = "Artist info successfully updated"
      redirect_to @artist
    else
      render 'edit'
    end
  end

  #http://guides.rubyonrails.org/routing.html 2.10.2
  def myfavartists
    @artists=current_user.following.search(params[:search]).reorder(sort_column(sort_table) + " " + sort_direction).paginate(page: params[:page])
  end

  private

    def artist_params
      params.require(:artist).permit(:name_first, :name_last, :name_stage, :avatar)
    end

  # below not needed. no mass assignment used when sorting
  # def sort_params
    #   params.permit(:sort_table, :sort, :direction, :page, :search, :utf8, :sort_favs)
    # end
    # not used as before callback, because would like to test that variable is or isn't set based on admin or not
    # def set_artist
    #   @artist = Artist.find(params[:id])
    # end

    def sort_column(sort_table)
      if sort_table == "Artist"
        Artist.column_names.include?(params[:sort]) ? params[:sort] : "name_stage"
      end
    end

    def sort_table
      if params[:sort_table].present?
        params[:sort_table]
      else
      "Artist"
      end
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

    def sort_favs?
      #in below, we need to make sure that method returns a boolean and not a string, as "false" as string evaluates to true
      if params[:sort_favs].present? && params[:sort_favs] == "true"
        true
      else
        false
      end
    end

end

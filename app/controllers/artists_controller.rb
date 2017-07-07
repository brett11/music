class ArtistsController < ApplicationController
  before_action :set_artist, only:[:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :admin_user, only: [:edit, :update, :destroy]

  #http://railscasts.com/episodes/228-sortable-table-columns?view=comments
  helper_method :sort_column, :sort_direction, :sort_table

  #http://railscasts.com/episodes/228-sortable-table-columns?view=comments
  #http://railscasts.com/episodes/240-search-sort-paginate-with-ajax?autoplay=true
  #reorder because https://stackoverflow.com/questions/14286207/how-to-remove-ranking-of-query-results
  def index
    @artists=Artist.search(sort_params[:search]).reorder(sort_column(sort_table) + " " + sort_direction).paginate(page: sort_params[:page])
    # respond_to do |format|
    #   format.html
    #   format.js
    # end
  end

  def show
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

  private

    def artist_params
      params.require(:artist).permit(:name_first, :name_last, :name_stage, :avatar)
    end

    def sort_params
      params.permit(:sort_table, :sort, :direction, :page, :search, :utf8)
    end

    def set_artist
      @artist = Artist.find(params[:id])
    end

    def sort_column(sort_table)
      if sort_table == "Artist"
        Artist.column_names.include?(sort_params[:sort]) ? sort_params[:sort] : "id"
      end
    end

    def sort_table
      if sort_params[:sort_table].present?
        sort_params[:sort_table]
      else
      "Artist"
      end
    end

    def sort_direction
      %w[asc desc].include?(sort_params[:direction]) ? sort_params[:direction] : "asc"
    end

end

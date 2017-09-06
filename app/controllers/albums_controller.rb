class AlbumsController < ApplicationController
  # before_action :set_album, only:[:show, :edit, :update]
  before_action :admin_user, only: [:new, :create, :edit, :update]

  #http://railscasts.com/episodes/228-sortable-table-columns?view=comments
  helper_method :sort_column, :sort_direction, :sort_table

  def index
    # sometimes sort albums based on artist
    # binding.pry
    if sort_favs?
      if params[:sort_table] == "Artist"
        @albums = sort_my_favs_by_artist
      else
        # binding.pry
        @albums = sort_my_favs
      end
    else
      if params[:sort_table] == "Artist"
        @albums = sort_by_artist
      else
        # binding.pry
        @albums = sort
      end
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @album = Album.find(params[:id])
  end


  def new
    @album = Album.new
  end

  def create
    #rails 4 testing pg 134 --it is best to create method that calls third party method, if you are planning to stub in a test, as we are in the create failure test
    # album params artist returns artist id only per pry byebug
    #binding.pry
    @album = Album.new_from_controller(album_params_less_artist)
    @artist_ids = album_params[:artist_ids]
    @artist_ids.each do |artist_id|
      artist = Artist.find(artist_id)
      @album.artists << artist
    end
    respond_to do |format|
      format.html do
        if @album.save
          flash[:success] = "Album successfully added."
          redirect_to albums_url
        else
          flash[:warning] = "Please try again."
          render 'new'

        end
      end
      format.js
    end
  end

  def edit
    @album = Album.find(params[:id])
  end

  def update
    @album = Album.find(params[:id])
    if @album.update_attributes(album_params)
      flash[:success] = "Album info successfully updated"
      redirect_to @album
    else
      render 'edit'
    end
  end

  private
    # def set_album
    #   @album = Album.find(params[:id])
    # end

    def album_params
      params.require(:album).permit(:name, :release_date, :album_cover, artist_ids: [] )
    end

  # below not needed. no mass assignment used when sorting
  # def sort_params
  #   params.permit(:sort_table, :sort, :direction, :page, :search, :utf8, :sort_favs)
  # end

    def album_params_less_artist
      params.require(:album).permit(:name, :release_date, :album_cover)
    end

    def sort_column(sort_table)
      if sort_table == "Album"
        Album.column_names.include?(params[:sort]) ? params[:sort] : "name"
      elsif sort_table == "Artist"
        Artist.column_names.include?(params[:sort]) ? params[:sort] : "name_stage"
      end
    end

    def sort_table
      artist_album_array = %w(Artist Album)
      artist_album_array.include?(params[:sort_table]) ? params[:sort_table] : "Album"
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

    #reorder because https://stackoverflow.com/questions/14286207/how-to-remove-ranking-of-query-results
    def sort
      Album.search(params[:search]).reorder(sort_column(sort_table) + " " + sort_direction).paginate(page: params[:page])
    end

    #http://railscasts.com/episodes/228-sortable-table-columns?view=comments nico44
    # superseded by below
    # def sort_by_artist
    #   Album.search(params[:search]).includes(:artists).reorder("artists." + sort_column(sort_table) + " " + sort_direction)
    #     .paginate( page: params[:page] )
    # end

    def sort_by_artist
      Album.search(params[:search]).joins(:artists).merge(Artist.reorder(sort_column(sort_table) + " " + sort_direction))
        .paginate( page: params[:page] )
    end


  # TODO: fix current_user.following.albums
  def sort_my_favs
    #Album.search(params[:search]).merge().reorder(sort_column(sort_table) + " " + sort_direction).paginate(page: params[:page])
    Album.search(params[:search]).joins(:artists).merge(current_user.following).merge(Album.reorder(sort_column(sort_table) + " " + sort_direction))
      .paginate( page: params[:page] ).references(:fanships)
    end

  # TODO: fix current_user.following.albums
    def sort_my_favs_by_artist
      Album.search(params[:search]).joins(:artists).merge(current_user.following).merge(Artist.reorder(sort_column(sort_table) + " " + sort_direction))
        .paginate( page: params[:page] )
    end

  #added by BF
  # def sort_column_table
  #   if params[:sort] == "artist"
  #     "Artist"
  #   else
  #     "Album"
  #   end
  # end
end

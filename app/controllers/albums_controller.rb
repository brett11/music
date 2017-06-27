# require 'pry'

class AlbumsController < ApplicationController
  before_action :set_album, only:[:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :admin_user, only: [:edit, :update, :destroy]

  #http://railscasts.com/episodes/228-sortable-table-columns?view=comments
  helper_method :sort_column, :sort_direction

  def index
    if sort_params[:sort_table] == "Artist"
      @albums = sort_by_artist
    else
    # binding.pry
    @albums = sort
    end
  end

  def show
  end


  def new
    @album = Album.new
  end

  def create
    # album params artist returns artist id only per pry byebug
    #binding.pry
    @album = Album.new(album_params_less_artist)
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
    def set_album
      @album = Album.find(params[:id])
    end

  def album_params
    params.require(:album).permit(:name, :release_date, :album_cover, artist_ids: [] )
  end

  def sort_params
    params.permit(:sort_table, :sort, :direction, :page)
  end

  def album_params_less_artist
    params.require(:album).permit(:name, :release_date, :album_cover)
  end

  def sort_column(sort_table)
    if sort_table == "Album"
      Album.column_names.include?(sort_params[:sort]) ? sort_params[:sort] : "id"
    elsif sort_table == "Artist"
      Artist.column_names.include?(sort_params[:sort]) ? sort_params[:sort] : "id"
    end
  end

  def sort_table
    sort_params[:sort_table] ||= "Album"
  end

  def sort_direction
    %w[asc desc].include?(sort_params[:direction]) ? sort_params[:direction] : "asc"
  end

  def sort
    Album.paginate(page: sort_params[:page]).order(sort_column(sort_table) + " " + sort_direction)
  end

  #http://railscasts.com/episodes/228-sortable-table-columns?view=comments nico44
  def sort_by_artist
    Album.includes(:artists).order("artists." + sort_column(sort_table) + " #{sort_direction}")
      .paginate( page: params[:page] )
  end

  #added by BF
  # def sort_column_table
  #   if sort_params[:sort] == "artist"
  #     "Artist"
  #   else
  #     "Album"
  #   end
  # end
end

require 'pry'

class AlbumsController < ApplicationController
  before_action :set_album, only:[:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :admin_user, only: [:edit, :update, :destroy]

  def index
    @albums = Album.paginate(page: params[:page]).order("release_date DESC")

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

  def album_params_less_artist
    params.require(:album).permit(:name, :release_date, :album_cover)
  end

end

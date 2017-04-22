class AlbumsController < ApplicationController
  before_action :set_album, only:[:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :admin_user, only: [:edit, :update, :destroy]

  def show

  end

  def index
    @albums = Album.paginate(page: params[:page]).order("release_date DESC")
    store_location
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
    params.require(:album).permit(:name, :release_date, :album_cover)
  end

end

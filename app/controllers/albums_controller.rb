class AlbumsController < ApplicationController
  before_action :set_album, only:[:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:edit, :update, :destroy]

  def show

  end

  def index
    @albums = Album.paginate(page: params[:page]).order("release_date DESC")
  end

  private
    def set_album
      @album = Album.find(params[:id])
    end

end

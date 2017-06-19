class ArtistsController < ApplicationController
  before_action :set_artist, only:[:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :admin_user, only: [:edit, :update, :destroy]

  def index
    @artists=Artist.order("id ASC").paginate(page: params[:page])
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

  def set_artist
    @artist = Artist.find(params[:id])
  end

end

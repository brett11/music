class ArtistsController < ApplicationController
  before_action :set_artist, only:[:show, :edit, :update, :destroy]

  def show
    @artist_concerts = @artist.concerts.where('dateAndTime > ?', DateTime.now).order("dateAndTime ASC").paginate(page: params[:page])
  end

  def index
    @artists=Artist.paginate(page: params[:page])
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

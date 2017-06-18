class ConcertsController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy]

  def show
    @concert = Concert.find(params[:id])
  end

  def index
    @concerts = Concert.paginate(page: params[:page]).where('dateandtime > ?', DateTime.now).order("dateandtime ASC")
  end

  def new
    @concert = Concert.new
  end

  def create
    # album params artist returns artist id only per pry byebug
    #binding.pry
    @concert = Concert.new(concert_params_dateandtime_only)
    @concert.venue = Venue.find(concert_params[:venue_id])
    @artist_ids = concert_params[:artist_ids]
    @artist_ids.each do |artist_id|
      artist = Artist.find(artist_id)
      @concert.artists << artist
    end
    respond_to do |format|
      format.html do
        if @concert.save
          flash[:success] = "Show successfully added."
          redirect_to concerts_url
        else
          flash[:warning] = "Please try again."
          render 'new'

        end
      end
      format.js
    end
  end

  private

  def concert_params
    params.require(:concert).permit(:dateandtime, :venue_id, artist_ids: [] )
  end

  def concert_params_dateandtime_only
    params.require(:concert).permit(:dateandtime)
  end

end

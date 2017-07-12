class FanshipsController < ApplicationController
  before_action :logged_in_user

  def create
    artist = Artist.find(params[:artist_id])
    current_user.follow(artist)
    # https://stackoverflow.com/questions/7465259/how-can-i-reload-the-current-page-in-ruby-on-rails
    redirect_back(fallback_location: current_user)
  end

  def destroy
    artist = Fanship.find(params[:id]).artist
    current_user.unfollow(artist)
    redirect_back(fallback_location: current_user)
  end
end

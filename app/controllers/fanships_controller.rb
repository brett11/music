class FanshipsController < ApplicationController
  before_action :logged_in_user

  def create
    artist = Artist.find(params[:artist_id])
    current_user.follow(artist)
    redirect_to current_user
  end

  def destroy
    artist = Fanship.find(params[:id]).artist
    current_user.unfollow(artist)
    redirect_to artist
  end
end

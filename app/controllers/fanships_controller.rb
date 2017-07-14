class FanshipsController < ApplicationController
  before_action :logged_in_user

  def create
    #made artist instance variable so it will be available in create.js.erb and destory.js.erb to pass to form partial
    @artist = Artist.find(params[:artist_id])
    current_user.follow(@artist)
    respond_to do |format|
      format.html do
        # https://stackoverflow.com/questions/7465259/how-can-i-reload-the-current-page-in-ruby-on-rails
        redirect_back(fallback_location: current_user)
      end
      format.js
    end

  end

  def destroy
    @artist = Fanship.find(params[:id]).artist
    current_user.unfollow(@artist)
    respond_to do |format|
      format.html do
        redirect_back(fallback_location: current_user)
      end
      format.js
    end
  end
end

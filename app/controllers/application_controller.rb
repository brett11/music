class ApplicationController < ActionController::Base
  include SessionsHelper
  include AlbumsHelper
  include ArtistsHelper
  include ConcertsHelper
  include VenuesHelper

  protect_from_forgery with: :exception

  private

    #Confirms a logged-in user
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    def admin_user
      redirect_to root_url unless current_user.admin?
    end

end

class ApplicationController < ActionController::Base
  include SessionsHelper
  # include AlbumsHelper
  # include ArtistsHelper
  # include ConcertsHelper
  # include VenuesHelper

  protect_from_forgery with: :exception
  before_action :create_body_class

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
      redirect_to root_url unless current_user.present? && current_user.admin?
    end

  # https://stackoverflow.com/questions/4828477/dynamically-assigning-unique-ids-to-the-body-tag-of-pages-using-rails
  def create_body_class
    @body_class = "#{params[:controller]}-#{params[:action]}"
  end



end

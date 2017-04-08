class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

    def heroku
      render text: "Need this for heroku setup! Wombat!"
    end
end

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)


module Music
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    #https://stackoverflow.com/questions/24319353/ruby-form-using-ajax-with-remote-true-gives-actioncontrollerinvalidauthentici
    # Rails tutorial pg 726
    config.action_view.embed_authenticity_token_in_remote_forms = true
  end
end

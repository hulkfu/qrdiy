require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module QrdiyCom
  class Application < Rails::Application
    # load all models in app/models/ sub directory
    config.autoload_paths += Dir[Rails.root.join('app', 'models', '{*/}')]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.time_zone = 'Beijing'

    config.i18n.default_locale = 'zh-CN'

    # middlewares
    config.middleware.use Rack::Attack

    # ross-Origin Resource Sharing (CORS)
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '/assets', :headers => :any, :methods => [:get, :post]
      end
    end
  end


end

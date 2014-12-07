require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Epoch
  class Application < Rails::Application

    config.time_zone = 'Eastern Time (US & Canada)'

    config.generators do |g|
      g.assets false
      g.helper false

      g.controller_specs false
      g.view_specs false
    end

    # Asset Pipeline paths for bower and webfonts
    config.assets.paths << Rails.root.join("vendor","assets","bower_components")
    config.assets.paths << Rails.root.join("app", "assets", "fonts")

    # Enable gzip
    config.middleware.use Rack::Deflater

    # Precompile more files
    config.assets.precompile += %w( app.js ios-mobile-app-links.js facebook.js iNoBounce/inobounce.min.js )

    # Use react addons
    config.react.addons = true

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end
end

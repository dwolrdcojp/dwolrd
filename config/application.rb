require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Dwolrd
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.filepicker_rails.api_key = "Ac63AD9qJToycuTyHohqhz"

    config.assets.initialize_on_precompile = false

    config.load_defaults 6.0
  end
end

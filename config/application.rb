require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Myapp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.paths.add "lib/src", eager_load: true
    config.enable_dependency_loading = true
    config.autoload_paths += %W(#{config.root}/lib)

    # config.cache_store = :redis_store, {
    #   host: ENV['REDIS_HOST'],
    #   port: ENV['REDIS_PORT'],
    #   db: ENV['REDIS_DB_ID'],
    #   namespace: "cache",
    #   expire_in: 1.minutes
    # }
  end
end

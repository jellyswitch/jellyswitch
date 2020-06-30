# typed: false
require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require "action_view/component/base"

module Bristlecone
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Autoload paths
    config.eager_load_paths << Rails.root.join('lib')
    config.autoload_paths << Rails.root.join('lib')

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.time_zone = ENV['TIME_ZONE'] || "Pacific Time (US & Canada)"

    # Background jobs
    config.active_job.queue_adapter = :sidekiq


    config.action_mailer.default_url_options = { host: ENV['HOST'] }

    config.action_mailer.preview_path = "#{Rails.root}/spec/mailers"

    config.action_controller.asset_host = ENV['ASSET_HOST']
    config.beginning_of_week = :sunday
    config.hosts.clear
  end
end

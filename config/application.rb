require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module VPN
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    config.eager_load_paths << Rails.root.join('app','lib')
    config.autoload_paths << Rails.root.join('app','lib')

    # Don't generate system test files.
    config.generators.system_tests = nil

    # I18n
    config.i18n.default_locale = :en

    # ActiveJob queue
    config.active_job.queue_adapter = :async
    config.active_job.queue_name_prefix = Rails.env
    config.active_job.queue_name_delimiter = '_'

    # Configure the scheduler
    config.active_job.scheduler = :cron
    config.active_job.scheduler_options = { cron: '*/2 * * * *' }
  end
end

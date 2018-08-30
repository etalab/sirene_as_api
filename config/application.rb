require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'rails/test_unit/railtie'

Bundler.require(*Rails.groups)

module SireneAsAPI
  class Application < Rails::Application
    config.api_only = true
    config.active_record.schema_format = :sql

    # Background tasks
    config.active_job.queue_adapter = :resque

    # Custom config
    config.switch_server = config_for(:switch_server)

    config.autoload_paths +=
      %W[#{config.root}/lib
         #{config.root}/app/interactors
         #{config.root}/app/interactors/organizers
         #{config.root}/app/solr
         #{config.root}/db/checks_db]
  end
end

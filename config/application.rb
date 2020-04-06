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
    config.time_zone = 'Europe/Paris'
    config.api_only = true
    config.active_record.schema_format = :sql

    # Background tasks
    config.active_job.queue_adapter = :sidekiq
    config.active_job.queue_name_prefix = "sirene_api_#{Rails.env}"

    config.autoload_paths +=
      %W[#{config.root}/lib
         #{config.root}/app/interactors
         #{config.root}/app/interactors/organizers
         #{config.root}/app/solr
         #{config.root}/app/api
         #{config.root}/db/checks_db]
  end
end

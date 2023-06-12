# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'
# Sidekiq
require 'sidekiq/web'

run Sidekiq::Web
run Rails.application
Rails.application.load_server

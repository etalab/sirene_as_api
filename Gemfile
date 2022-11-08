source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

ruby "~> 2.7.6"

gem 'rack-cors'
gem 'rails', '~> 5'

gem 'listen', '~> 3.0.5'

gem 'pg', '~> 0.20'

# RDBM Agnostic connection pool manager
gem 'connection_pool', '~> 2.2'

# Backend jobs
gem 'redis', '~> 4.5'
gem 'redis-namespace'
gem 'redis-objects'
gem 'resque'
gem 'sidekiq', '~> 5.2.10'
gem 'sidekiq-cron'
gem 'sinatra', '>= 2.2.0'

# Sunspot / Solr friends
gem 'sunspot_rails'
gem 'sunspot_solr'

# Serializer
gem 'active_model_serializers', '~> 0.10.0'

# Import of data files
gem 'activerecord-import'
gem 'smarter_csv', git: 'https://github.com/tilo/smarter_csv.git', ref: '2b71026'

gem 'ruby-progressbar'
# Gem progress_bar required for displaying progress in rake sunspot:reindex
gem 'progress_bar'

# use `ap var` for awesome print
gem 'awesome_print'

# Generate logs for elasticsearch
gem 'logstasher'

# Interactors
gem 'interactor', '~> 3.0'
gem 'interactor-rails', '~> 2.0'

# Trailblazer
gem 'trailblazer'
gem 'trailblazer-activity'
gem 'trailblazer-operation'
gem 'trailblazer-rails'

# Map incoming requests to scopes
gem 'has_scope'

# Pagination
gem 'pagy'

# PostgreSQL full text search
gem 'pg_search'

gem 'sitemap_generator'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'colorize'
  gem 'pry'
  gem 'pry-byebug'

  gem 'rspec-activejob'
  gem 'rspec-collection_matchers'
  gem 'rspec-its'
  gem 'rspec-rails', '~> 3.5'
  gem 'shoulda-matchers'

  gem 'guard'
  gem 'guard-rails', require: false
  gem 'guard-rspec', require: false

  # factory_bot used for populating test database
  gem 'factory_bot_rails'

  gem 'growl'
end

group :test do
  gem 'fuubar'
  gem 'simplecov'
  gem 'simplecov-console'
  gem 'timecop'
  gem 'unindent'
  gem 'vcr'
  gem 'webmock'
end

group :development do
  gem 'brakeman', require: false
  gem 'bundler-audit', require: false
  gem 'mina'
  gem 'rails_best_practices'
  gem 'rubocop-checkstyle_formatter', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

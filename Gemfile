source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rack-cors'
gem 'rails', '~> 5.0.1'

gem 'listen', '~> 3.0.5'

gem 'pg', '~> 0.20'

# RDBM Agnostic connection pool manager
gem 'connection_pool', '~> 2.2'

# Backend jobs
gem 'redis', '~> 3.0'
gem 'redis-namespace'
gem 'redis-objects'
gem 'resque'
gem 'sinatra', '~> 2.0.2'

# Sunspot / Solr friends
gem 'sunspot_rails'
gem 'sunspot_solr'

gem 'smarter_csv'

gem 'ruby-progressbar'
# Gem progress_bar required for displaying progress in rake sunspot:reindex
gem 'progress_bar'

# Loader in terminal for heavy tasks
gem 'whirly'

# use `ap var` for awesome print
gem 'awesome_print'

# Generate logs for elasticsearch
gem 'logstasher'

# Interactors
gem 'interactor', '~> 3.0'
gem 'interactor-rails', '~> 2.0'

# Trailblazer
gem 'trailblazer-rails'

# Gem for deploying cron jobs
gem 'whenever', require: false

gem 'sitemap_generator'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'colorize'
  gem 'pry'
  gem 'pry-byebug'

  gem 'rspec-rails', '~> 3.5'
  gem 'rspec-its'
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
  gem 'vcr'
  gem 'webmock'
end

group :development do
  gem 'brakeman', require: false
  gem 'mina'
  gem 'mina-whenever'
  gem 'rails_best_practices'
  gem 'rubocop-checkstyle_formatter', require: false
  gem 'rubocop-rspec', require: false
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

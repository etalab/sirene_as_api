ruby '2.4.1'
source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.0.1'
gem 'rack-cors'

gem 'puma', '~> 3.0'

gem 'pg'

# RDBM Agnostic connection pool manager
gem 'connection_pool', '~> 2.2'

# Backend jobs
gem 'resque'
gem 'sinatra', '~> 2.0.0.beta2'
gem 'redis', '~> 3.0'
gem 'redis-namespace'
gem 'redis-objects'

# Sunspot / Solr friends
gem 'sunspot_rails'
gem 'sunspot_solr'

gem 'rubyzip'
gem 'smarter_csv'

gem 'ruby-progressbar'
# Gem progress_bar required for displaying progress in rake sunspot:reindex
gem 'progress_bar'

# Interactors
gem "interactor", "~> 3.0"
gem "interactor-rails", "~> 2.0"

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'pry'
  gem 'pry-byebug'

  gem 'rspec-rails', '~> 3.5'

  gem 'guard'
  gem 'guard-rails', require: false
  gem 'guard-rspec', require: false

# factory_girl used for populating test database
  gem 'factory_girl_rails'

  gem 'timecop'
  gem 'growl'
end

group :test do
  gem 'vcr'
  gem 'webmock'

# database_cleaner used for cleaning database before test
  gem 'database_cleaner'
end

group :development do
  gem 'brakeman', require: false
  gem 'listen', '~> 3.0.5'
  gem 'mina', ref: '343a7', git: 'https://github.com/mina-deploy/mina.git'
  gem 'rails_best_practices'
  gem 'rubocop-checkstyle_formatter', require: false
  gem 'rubocop-rspec', require: false
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

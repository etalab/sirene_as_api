require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'
require 'mina/whenever'
require 'colorize'

ENV['to'] ||= 'sandbox'
%w[sandbox production].include?(ENV['to']) || raise("target environment (#{ENV['to']}) not in the list")

print "Deploy to #{ENV['to']}\n".green

set :user, 'deploy' # Username in the server to SSH to.
set :application_name, 'sirene'

# FOR CLIENT MINA DEPLOYMENT : Replace this domain adress with your own
# set :domain, 'sirene.entreprise.api.gouv.fr'

# sirene_server1: 'ns372885.ip-178-33-234.eu'
# sirene_server2: 'ns3107905.ip-54-37-87.eu'
if ENV['server'] == '1'
  set :domain, 'ns372885.ip-178-33-234.eu'
elsif ENV['server'] == '2'
  set :domain, 'ns3107905.ip-54-37-87.eu'
else
  abort 'Please choose server=1 or 2'
end

set :deploy_to, "/var/www/sirene_#{ENV['to']}"
set :rails_env, ENV['to']

set :forward_agent, true
set :port, 22
set :repository, 'https://github.com/etalab/sirene_as_api.git'
if ENV['to'] == 'production'
  set :branch, 'master'
elsif ENV['to'] == 'sandbox'
  set :branch, 'sandbox'
else
  abort 'Environment must be set to sandbox or production'
end

# shared dirs and files will be symlinked into the app-folder by the 'deploy:link_shared_paths' step.
set :shared_dirs, fetch(:shared_dirs, []).push(
  'bin',
  'log',
  'public/system',
  'public/uploads',
  'tmp/cache',
  'tmp/files',
  'tmp/pids',
  'tmp/sockets',
  '.last_monthly_stock_applied',
  'solr/default',
  'solr/production',
  'solr/sandbox',
  'solr/development',
  'solr/pids',
  'solr/tests'
)

set :shared_files, fetch(:shared_files, []).push(
  'config/database.yml',
  'config/environments/production.rb',
  'config/secrets.yml'
)

# This task is the environment that is loaded for all remote run commands, such as
# `mina deploy` or `mina rake`.
task :remote_environment do
  set :rbenv_path, '/usr/local/rbenv'
  invoke :'rbenv:load'
end

# Put any custom commands you need to run at setup
# All paths in `shared_dirs` and `shared_paths` will be created on their own.
task :setup do
  # Production database has to be setup !
  # command %(rbenv install 2.3.0)
end

desc 'Deploys the current version to the server.'
task deploy: :remote_environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    # invoke :'rails:assets_precompile'

    on launch: :remote_environment do
      command "touch #{fetch(:deploy_to)}/current/tmp/restart.txt"
      invoke :passenger
    end

    invoke :warning_info
  end
end

task passenger: :remote_environment do
  comment %{Attempting to start Passenger app}.green
  command %{
    if (sudo passenger-status | grep sirene_#{ENV['to']}) >/dev/null
    then
      passenger-config restart-app /var/www/sirene_#{ENV['to']}/current
    else
      echo 'Skipping: no passenger app found (will be automatically loaded)'
    fi
  }
end

task warning_info: :remote_environment do
  warning_sign = '\xE2\x9A\xA0'
  comment %{#{warning_sign} #{warning_sign} #{warning_sign} #{warning_sign}}.yellow
  comment %{#{warning_sign} If it's the first install (or a reboot) run the folowing commands #{warning_sign}}.yellow
  comment %{#{warning_sign} in the following directory: #{fetch(:deploy_to)}/current #{warning_sign}}.yellow
  comment %{bundle exec rake sunspot:solr:start RAILS_ENV=#{ENV['to']}}.green
  comment %{bundle exec rake sirene_as_api:populate_database RAILS_ENV=#{ENV['to']}}.green
  comment %{#{warning_sign} #{warning_sign} #{warning_sign} #{warning_sign}}.yellow
  comment %{#{warning_sign} WARNING : Automatic wheneverize deactivated for now, update crontab manually #{warning_sign}}.yellow
end

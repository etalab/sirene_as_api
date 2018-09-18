# Learn more: http://github.com/javan/whenever
set :output, File.join(Whenever.path, 'log', 'rna_api_cron.log')

###### SANDBOX ######

if Rails.env.sandbox?
  every 2.days, at: '8:00 am' do
    rake 'sirene_as_api:automatic_update_database'
  end
end

###### PRODUCTION ######

if Rails.env.production?
  # CRON Job for single server update, uncomment if you have a single server

  # every 1.day, at: '4:30 am' do
  #   rake 'sirene_as_api:automatic_update_database'
  # end

  # CRON jobs for dual server update, comment out if you have a single server
  # The rake task is launched only if the server is not used, so each server will update every other day
  every 1.day, at: '4:30 am' do
    rake 'sirene_as_api:dual_server_update'
  end
end

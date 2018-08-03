###### SANDBOX ######

every 1.day, at: '8:00 am' do
  rake 'sirene_as_api:automatic_update_database', environment: 'sandbox'
end

###### PRODUCTION ######

# CRON Job for single server update, uncomment if you have a single server

# every 1.day, at: '4:30 am' do
#   rake 'sirene_as_api:automatic_update_database', :environment => 'production'
# end

# CRON jobs for dual server update, comment out if you have a single server
# The rake task is launched only if the server is not used, so each server will update every other day
every 1.day, at: '4:30 am' do
  rake 'sirene_as_api:dual_server_update', environment: 'production'
end

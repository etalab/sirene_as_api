# Learn more: http://github.com/javan/whenever
set :output, File.join(Whenever.path, 'log', 'rna_api_cron.log')

every 1.day, at: '4:30 am' do
  rake 'sirene_as_api:dual_server_update'
end

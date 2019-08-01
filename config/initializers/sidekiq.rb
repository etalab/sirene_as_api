def load_sidekiq_cron_jobs
  schedule_file = 'config/schedule.yml'

  if File.exists?(schedule_file)
    loaded_conf = YAML.load_file(schedule_file)
    Sidekiq::Cron::Job.load_from_hash(loaded_conf[Rails.env])
  end
end


Sidekiq.configure_server do |config|
  config.redis = { url: Rails.configuration.redis_database }

  load_sidekiq_cron_jobs
end

Sidekiq.configure_client do |config|
  config.redis = { url: Rails.configuration.redis_database }
end

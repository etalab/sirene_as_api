namespace :sirene do
  desc 'Automatic database update'
  task update_database: :environment do
    puts 'This operation will use Sidekiq to perform the job'
    UpdateDatabaseJob.perform_now
  end
end

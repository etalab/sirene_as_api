namespace :check_db do
  desc 'Check consistensy of :is_siege in the database'
  task test_is_siege: :environment do
    CheckIfOnlyOneSiege.call
  end
end

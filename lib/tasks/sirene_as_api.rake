namespace :sirene_as_api do
  desc 'Populate db with last monthly stock'
  task :import_last_monthly_stock => :environment do
    ImportLastMonthlyStock.call
  end

  desc 'Updates database'
  task :select_and_apply_patches => :environment do
    SelectAndApplyPatches.call
  end

  desc 'Populate database with stock and apply relevant patches'
  task :populate_database => :environment do
    PopulateDatabase.call
  end
end

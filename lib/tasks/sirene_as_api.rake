namespace :sirene_as_api do
  desc 'Populate db with last monthly stock (need manual reindex after)'
  task import_last_monthly_stock: :environment do
    ImportLastMonthlyStock.call
  end

  desc 'Updates database (manual mode)'
  task update_database: :environment do
    UpdateDatabase.call
  end

  desc 'Updates database (automatically accept user prompts and delete tmp files)'
  task automatic_update_database: :environment do
    AutomaticUpdateDatabase.call
  end

  desc 'Update database automatically, switch server when done'
  task dual_server_update: :environment do
    DualServerUpdate.call
  end

  desc 'Populate database with stock and apply relevant patches'
  task populate_database: :environment do
    PopulateDatabase.call
  end

  desc 'Delete all rows in database'
  task delete_database: :environment do
    DeleteDatabase.call
  end

  desc 'Delete temporary files (monthly stock and daily patches)'
  task delete_temporary_files: :environment do
    DeleteTemporaryFiles.call
  end

  desc 'Build the suggester dictionary for getting suggestions'
  task build_dictionary: :environment do
    SolrRequests.new.build_dictionary
  end
end

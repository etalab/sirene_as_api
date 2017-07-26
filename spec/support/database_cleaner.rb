require 'rails_helper'

def use_database_cleaner
  DatabaseCleaner.strategy = :delete

  before :all do
    DatabaseCleaner.start
  end

  after :all do
    DatabaseCleaner.clean
  end
end

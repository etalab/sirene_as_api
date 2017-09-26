require 'rails_helper'

def use_database_cleaner
  DatabaseCleaner.strategy = :deletion

  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end
end

require 'rails_helper'

def use_database_cleaner
  before :each do
    puts 'Cleaning the database before test...'
    DatabaseCleaner.start
  end

  after :each do
    puts 'Cleaning the database after test...'
    DatabaseCleaner.clean
  end
end

require 'rails_helper'

def use_solr
  before :each do
    puts '------> Starting solr before test, waiting 3 seconds to let it start...'
    system("RAILS_ENV='test'", 'rake', 'sunspot:solr:start')
    sleep 3;
  end

  after :each do
    puts '------> Stopping solr after test...'
    system("RAILS_ENV='test'", 'rake', 'sunspot:solr:stop')
  end
end

require 'rails_helper'

describe GetRelevantPatchesLinks do
  # You need to start solr before doing any tests on test database and stop it
  # cleanly after to avoid bad requests due to PID/logging problems.
  before :all do
    puts "Starting Sunspot Solr, waiting 3 sec to let it start..."
    system("rake", "sunspot:solr:start")
    sleep 3
    populate_test_database
  end

  after :all do
    DatabaseCleaner.clean
    system("rake", "sunspot:solr:stop")
  end

  context 'when in march & there are MORE than 5 patches', :vcr => { cassette_name: 'sirene_file_index_20170330' } do
    it 'retrieves the right number of patches' do
      right_number_of_patches = 63
      expect(described_class.call.links.size).to eq(right_number_of_patches)
    end
    it 'applies all patches'
  end

  context 'when in march & there are LESS than 5 patches', :vcr => { cassette_name: 'sirene_file_index_20170330' } do
    it 'retrieves the right number of patches' do
      add_one_recent_entry
      right_number_of_patches = 2
      expect(described_class.call.links.size).to eq(right_number_of_patches)
    end
  end

  def populate_test_database
    50.times do
      create(:etablissement)
    end
  end

  def add_one_recent_entry
    create(:etablissement, date_mise_a_jour: "2017-03-27T10:55:43")
  end
end

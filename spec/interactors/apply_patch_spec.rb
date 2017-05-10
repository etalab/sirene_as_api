require 'rails_helper'
require 'ruby-progressbar'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

describe ApplyPatch do
  # You need to start solr before doing any tests on test database and stop it
  # cleanly after to avoid bad requests due to PID/logging problems.
  before :all do
    puts "Starting sunspot solr"
    system("rake", "sunspot:solr:start")
    sleep 3 # Time for Solr to start
  end
  after :all do
    system("rake", "sunspot:solr:stop")
  end

  #this test will check the last update, then apply one patch in the ../fixtures/sample_patches folder,
  # then rollback and check if the last update is the same.
  context 'when a patch must be applied' do
    it 'rollback correctly the last patch' do
      populate_test_database
      # puts @all_etablissements.date_mise_a_jour
      # pending("ApplyPatch test not yet implemented")
      # ApplyPatch.new(link: test_link).call
      # expect().to eq()
    end
    DatabaseCleaner.clean
  end

  def test_link
    "http://files.data.gouv.fr/sirene/sirene_2017095_E_Q.zip"
  end

  def populate_test_database
    20.times do
      create(:etablissement)
    end
  end
end

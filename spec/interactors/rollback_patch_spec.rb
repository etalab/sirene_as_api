require 'rails_helper'
require 'ruby-progressbar'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

describe RollbackPatch do
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

  # This test check if the last update is different before applying the patch,
  # then if it is the same after rollback
  context 'when a patch must be rollback' do
    it 'rollback correctly the patch' do
      save_last_update = Etablissement.latest_mise_a_jour
      ApplyPatch.new(link: patch_link).call
      RollbackPatch.new(link: patch_link).call
      expect(save_last_update).to eq(Etablissement.latest_mise_a_jour)
    end
  end

  def patch_link
    "http://files.data.gouv.fr/sirene/sirene_2017095_E_Q.zip"
  end

  def last_update_after_applypatch
    "2017-04-05T19:34:44"
  end

  def populate_test_database
    50.times do
      create(:etablissement)
    end
  end
end

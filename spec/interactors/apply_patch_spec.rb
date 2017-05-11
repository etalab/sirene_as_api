require 'rails_helper'
require 'ruby-progressbar'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

describe ApplyPatch do
  # You need to start solr before doing any tests on test database and stop it
  # cleanly after to avoid bad requests due to PID/logging problems.
  before :all do
    puts "Starting Sunspot Solr, waiting 3 sec to let it start..."
    system("rake", "sunspot:solr:start")
    sleep 3
  end

  after :all do
    DatabaseCleaner.clean
    system("rake", "sunspot:solr:stop")
  end

  # The last update time should be inferior to the one in the patch,
  # and should be the same after patch is applied
  context 'when a patch must be applied' do
    it 'apply correctly the patch' do
      populate_test_database
      expect(last_update_before_applypatch).to be < last_update_after_applypatch
      ApplyPatch.new(link: patch_link).call
      expect(last_update_before_applypatch).to eq(last_update_after_applypatch)
    end
  end

  # Sample patch link which last update is in last_update_after_applypatch
  def patch_link
    "http://files.data.gouv.fr/sirene/sirene_2017095_E_Q.zip"
  end

  def last_update_before_applypatch
    Etablissement.latest_mise_a_jour
  end

  # Sample last update which is in patch from patch_link
  def last_update_after_applypatch
    "2017-04-05T19:34:44"
  end

  def populate_test_database
    50.times do
      create(:etablissement)
    end
  end
end

require 'rails_helper'
require 'ruby-progressbar'
require 'database_cleaner'

describe SelectAndApplyPatches do
  # You need to start solr before doing any tests on test database and stop it
  # cleanly after to avoid bad requests due to PID/logging problems.
  before :all do
    puts "Starting Sunspot Solr, waiting 3 sec to let it start..."
    system("rake", "sunspot:solr:start")
    sleep 3
    populate_test_database
  end

  after :all do
    # Timecop.return
    DatabaseCleaner.clean
    system("rake", "sunspot:solr:stop")
  end

  context 'when in march & there are MORE than 5 patches' do
    it 'retrieves the right number of patches' do
      add_one_recent_entry_7_patch_ago
      right_number_of_patches = 7
      VCR.use_cassette('sirene_file_index_20170330', :allow_playback_repeats => true) do
        expect(GetRelevantPatchesLinks.call.links.size).to eq(right_number_of_patches)
      end
    end
    # Checking if the first siren from the first patch is indeed in the database,
    # and if the date and siren of the last entry in the last patch are indeed the last entry in the database
    it 'apply 7 patches' do
      add_one_recent_entry_7_patch_ago
      VCR.use_cassette('sirene_file_index_20170330', :allow_playback_repeats => true) do
          described_class.call
      end
      siren_first_patch = first_entry_from_first_patch_7_ago[:siren]
      date_first_patch = first_entry_from_first_patch_7_ago[:date_mise_a_jour]
      date_first_patch_in_database = Etablissement.limit(1).find_by(siren: siren_first_patch).date_mise_a_jour
      expect(date_first_patch_in_database).to eq(date_first_patch)
      last_entry_from_database = {:siren => Etablissement.latest_entry.siren, :date_mise_a_jour => Etablissement.latest_mise_a_jour}
      expect(last_entry_from_database).to eq(last_entry_from_last_patch)
    end
  end

  context 'when in march & there are LESS than 5 patches' do
    it 'retrieves the right number of patches' do
      add_one_recent_entry_2_patch_ago
      right_number_of_patches = 5
      VCR.use_cassette('sirene_file_index_20170330', :allow_playback_repeats => true) do
        expect(GetRelevantPatchesLinks.call.links.size).to eq(right_number_of_patches)
      end
    end
    it 'apply 5 patches' do
      add_one_recent_entry_2_patch_ago
      VCR.use_cassette('sirene_file_index_20170330', :allow_playback_repeats => true) do
          described_class.call
      end
      siren_first_patch = first_entry_from_first_patch_5_ago[:siren]
      date_first_patch = first_entry_from_first_patch_5_ago[:date_mise_a_jour]
      date_first_patch_in_database = Etablissement.limit(1).find_by(siren: siren_first_patch).date_mise_a_jour
      expect(date_first_patch_in_database).to eq(date_first_patch)
      last_entry_from_database = {:siren => Etablissement.latest_entry.siren, :date_mise_a_jour => Etablissement.latest_mise_a_jour}
      expect(last_entry_from_database).to eq(last_entry_from_last_patch)
    end
  end

# First entry from patch 2017080 :
# Time 2017-03-20T20:10:09
# Siren 539339663
  def first_entry_from_first_patch_7_ago
    {:siren => '539339663', :date_mise_a_jour => '2017-03-20T20:10:09'}
  end

# First entry from patch 2017082 :
# Time 2017-03-23T03:06:56
# Siren 828093930
  def first_entry_from_first_patch_5_ago
    {:siren => '828093930', :date_mise_a_jour => '2017-03-23T03:06:56'}
  end

# Last entry from patch 2017088 :
# Time 2017-03-29T19:01:16
# Siren 828671222
  def last_entry_from_last_patch
    {:siren => '828671222', :date_mise_a_jour => '2017-03-29T19:01:16'}
  end

  def populate_test_database
    50.times do
      create(:etablissement)
    end
  end

  def add_one_recent_entry_2_patch_ago
    create(:etablissement, date_mise_a_jour: "2017-03-27T10:55:43")
  end

  def add_one_recent_entry_7_patch_ago
    create(:etablissement, date_mise_a_jour: "2017-03-20T10:55:43")
  end
end

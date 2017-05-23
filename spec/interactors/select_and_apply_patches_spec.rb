require 'rails_helper'

describe SelectAndApplyPatches do
  before :each do
    puts 'Cleaning the database before test...'
    DatabaseCleaner.start
    puts 'Populating the database before test...'
    populate_test_database
  end

  after :each do
    puts 'Cleaning the database after test...'
    DatabaseCleaner.clean
  end

  # Last entry from patch 2017088 :
  # Time 2017-03-29T19:01:16
  # Siren 828671222
  let(:last_entry_from_last_patch) {{ siren: '828671222', date_mise_a_jour: '2017-03-29T19:01:16' }}
  context 'when in march & there are MORE than 5 patches' do
    # First entry from patch 2017080 :
    # Time 2017-03-20T20:10:09
    # Siren 539339663
    let(:first_entry_from_first_patch_7_ago) {{ siren: '539339663', date_mise_a_jour: '2017-03-20T20:10:09' }}
    it 'retrieves the right number of patches' do
      add_one_recent_entry_7_patch_ago
      right_number_of_patches = 7
      VCR.use_cassette('sirene_file_index_20170330', allow_playback_repeats: true) do
        expect(GetRelevantPatchesLinks.call.links.size).to eq(right_number_of_patches)
      end
    end
    # Checking if the first siren from the first patch is indeed in the
    # database, and if the date and siren of the last entry in the last patch
    # are indeed the last entry in the database
    it 'apply 7 patches' do
      add_one_recent_entry_7_patch_ago
      VCR.use_cassette('sirene_file_index_20170330', allow_playback_repeats: true) do
          described_class.call
      end
      siren_first_patch = first_entry_from_first_patch_7_ago[:siren]
      date_first_patch = first_entry_from_first_patch_7_ago[:date_mise_a_jour]
      date_first_patch_in_database = Etablissement.unscoped.limit(1).find_by(siren: siren_first_patch).date_mise_a_jour
      expect(date_first_patch_in_database).to eq(date_first_patch)
      last_entry_from_database = {:siren => Etablissement.unscoped.latest_entry.siren, :date_mise_a_jour => Etablissement.unscoped.latest_mise_a_jour}
      expect(last_entry_from_database).to eq(last_entry_from_last_patch)
    end
  end

  context 'when in march & there are LESS than 5 patches' do
    # First entry from patch 2017082 :
    # Time 2017-03-23T03:06:56
    # Siren 828093930
    let(:first_entry_from_first_patch_5_ago) {{ siren: '828093930', date_mise_a_jour: '2017-03-23T03:06:56' }}
    it 'retrieves the right number of patches' do
      add_one_recent_entry_2_patch_ago
      right_number_of_patches = 5
      VCR.use_cassette('sirene_file_index_20170330', allow_playback_repeats: true) do
        expect(GetRelevantPatchesLinks.call.links.size).to eq(right_number_of_patches)
      end
    end
    it 'apply 5 patches' do
      add_one_recent_entry_2_patch_ago
      VCR.use_cassette('sirene_file_index_20170330', allow_playback_repeats: true) do
        described_class.call
      end
      siren_first_patch = first_entry_from_first_patch_5_ago[:siren]
      date_first_patch = first_entry_from_first_patch_5_ago[:date_mise_a_jour]
      date_first_patch_in_database = Etablissement.unscoped.limit(1).find_by(siren: siren_first_patch).date_mise_a_jour
      expect(date_first_patch_in_database).to eq(date_first_patch)
      last_entry_from_database = {siren: Etablissement.unscoped.latest_entry.siren, date_mise_a_jour: Etablissement.unscoped.latest_mise_a_jour}
      expect(last_entry_from_database).to eq(last_entry_from_last_patch)
    end
  end

  def populate_test_database
    50.times do
      create(:etablissement)
    end
  end

  def add_one_recent_entry_2_patch_ago
    create(:etablissement, date_mise_a_jour: '2017-03-27T10:55:43')
  end

  def add_one_recent_entry_7_patch_ago
    create(:etablissement, date_mise_a_jour: '2017-03-20T10:55:43')
  end
end

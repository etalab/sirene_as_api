require 'rails_helper'

describe ApplyPatch do
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

  # The last update time should be inferior to the one in the patch,
  # and should be the same after patch is applied
  context 'when a patch must be applied' do
    # Sample patch link which last update is in last_update_after_applypatch
    let(:patch_link) { 'http://files.data.gouv.fr/sirene/sirene_2017095_E_Q.zip' }
    # Sample last update which is in patch from patch_link
    let(:last_update_after_applypatch) { '2017-04-05T19:34:44' }
    it 'apply correctly the patch' do
      expect(last_update_before_applypatch).to be < last_update_after_applypatch
      ApplyPatch.new(link: patch_link).call
      expect(last_update_before_applypatch).to eq(last_update_after_applypatch)
    end
  end

  def last_update_before_applypatch
    Etablissement.unscoped.latest_mise_a_jour
  end

  def populate_test_database
    50.times do
      create(:etablissement)
    end
  end
end

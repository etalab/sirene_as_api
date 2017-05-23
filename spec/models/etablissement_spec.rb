require 'rails_helper'

describe Etablissement do
  before :each do
    puts 'Cleaning the database before test...'
    DatabaseCleaner.start
  end

  after :each do
    puts 'Cleaning the database after test...'
    DatabaseCleaner.clean
  end

  context 'when there are only etablissements in commercial diffusion' do
    it 'show them in the search results' do
      puts 'Populating the database before test...'
      populate_test_database_with_only_diffusion
      expect(Etablissement.all.size).to eq(50)
    end
  end

  context 'when there are only etablissements out of commercial diffusion' do
    it 'show nothing' do
      puts 'Populating the database before test...'
      populate_test_database_with_no_diffusion
      expect(Etablissement.all.size).to eq(0)
    end
  end
  context 'when there is every kind of etablissements' do
    it 'show no etablissements out of commercial diffusion' do
      puts 'Populating the database before test...'
      populate_test_database_with_all
      expect(Etablissement.where(nature_mise_a_jour: "O").size).to eq(0)
    end
  end

  def populate_test_database_with_only_diffusion
    50.times do
      create(:etablissement, nature_mise_a_jour: ["I", "F, ""C", "D", "E"].sample)
    end
  end

  def populate_test_database_with_no_diffusion
    20.times do
      create(:etablissement, nature_mise_a_jour: "O")
    end
  end

  def populate_test_database_with_all
    100.times do
      create(:etablissement, nature_mise_a_jour: ["I", "F, ""C", "D", "E", "O"].sample)
    end
  end
end

# system("curl 'localhost:3000/full_text/MA_RECHERCHE'")
# system("curl 'localhost:3000/siret/MON_SIRET'")

require 'rails_helper'

describe Etablissement do
  use_database_cleaner

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
end

# system("curl 'localhost:3000/full_text/MA_RECHERCHE'")
# system("curl 'localhost:3000/siret/MON_SIRET'")

require 'rails_helper'

describe Etablissement do
  context 'when there are only etablissements in commercial diffusion' do
    it 'show them in the search results' do
      populate_test_database_with_only_diffusion
      expect(Etablissement.all.size).to eq(5)
    end
  end

  context 'when there are only etablissements out of commercial diffusion' do
    it 'show nothing' do
      populate_test_database_with_no_diffusion
      expect(Etablissement.all.size).to eq(0)
    end
  end

  context 'when there is every kind of etablissements' do
    it 'show no etablissements out of commercial diffusion' do
      populate_test_database_with_only_diffusion
      populate_test_database_with_no_diffusion
      expect(Etablissement.where("nature_mise_a_jour='O' OR nature_mise_a_jour='E'").size).to eq(0)
    end
  end
end

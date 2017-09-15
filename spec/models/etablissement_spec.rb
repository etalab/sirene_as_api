require 'rails_helper'

# TODO adapt test for solr scoping instead of rails scoping
describe Etablissement do
  context 'when there are only etablissements in commercial diffusion', :type => :request do
    it 'show them in the search results' do
      populate_test_database_with_5_only_diffusion
      Etablissement.reindex

      get '/full_text/foobarcompany?activite_principale=APE42'

      result_hash = body_as_json

      puts result_hash

      result_etablissements = result_hash.extract!(:etablissement)
      number_results = result_etablissements[:etablissement].size

      expect(number_results).to match(5)
      # expect(Etablissement.all.size).to eq(5)
    end
  end

  context 'when there are only etablissements out of commercial diffusion' do
    it 'show nothing' do
      populate_test_database_with_no_diffusion
      # expect(Etablissement.all.size).to eq(0)
    end
  end

  context 'when there is every kind of etablissements' do
    it 'show no etablissements out of commercial diffusion' do
      populate_test_database_with_only_diffusion
      populate_test_database_with_no_diffusion
      # expect(Etablissement.where("nature_mise_a_jour='O'
      #   OR nature_mise_a_jour='E'").size).to eq(0)
    end
  end
end

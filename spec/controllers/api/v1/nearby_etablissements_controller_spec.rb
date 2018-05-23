require 'rails_helper'

describe API::V1::NearbyEtablissementsController do
  context 'when there are results', type: :request do
    let!(:etablissement_to_search) {create(
      :etablissement,
      id: 1,
      siret: '123456',
      latitude: '48.000001',
      longitude: '3.000001',
      activite_principale_entreprise: '6201Z',
    )}
    let!(:etablissement_to_find) {create(
      :etablissement,
      id: 2,
      siret: '123457',
      latitude: '48.000002',
      longitude: '3.000002',
      activite_principale_entreprise: '6201Z',
    )}
    let!(:etablissement_to_not_find) {create(
      :etablissement,
      id: 3,
      siret: '123458',
      latitude: '50.000000', # Unnamed road in Kazakhstan
      longitude: '50.000000',
      activite_principale_entreprise: '6201Z',
    )}
    it 'finds results' do
      Etablissement.reindex

      get '/v1/nearby_etablissements/123456'

      result_hash = body_as_json
      expect(response.body).to look_like_json
      expect(response).to have_http_status(200)
      expect(result_hash[:etablissements].size).to eq(1)
      expect(result_hash[:etablissements].first[:id]).to eq(2)
    end
  end

  context 'when there are no results', type: :request do
    let!(:etablissement_to_search) {create(
      :etablissement,
      id: 1,
      siret: '123456',
      latitude: '48.000001',
      longitude: '3.000001',
      activite_principale_entreprise: '6201Z',
    )}
    let!(:etablissement_to_not_find) {create(
      :etablissement,
      id: 3,
      siret: '123458',
      latitude: '50.000000', # Unnamed road in Kazakhstan
      longitude: '50.000000',
      activite_principale_entreprise: '6201Z',
    )}
    it 'finds results' do
      Etablissement.reindex

      get '/v1/nearby_etablissements/123456'

      result_hash = body_as_json
      expect(response.body).to look_like_json
      expect(body_as_json).to match(message: 'no results found')
      expect(response).to have_http_status(404)
    end
  end
end

require 'rails_helper'

describe API::V1::NearPointController do
  context 'when there are results', type: :request do
    let!(:etablissement_to_find) do
      create(
        :etablissement,
        id: 1,
        siret: '123457',
        latitude: '48.000002',
        longitude: '3.000002',
        activite_principale_entreprise: '6201Z'
      )
    end
    let!(:etablissement_to_not_find) do
      create(
        :etablissement,
        id: 2,
        siret: '123458',
        latitude: '50.000000',
        longitude: '50.000000',
        activite_principale_entreprise: '6201Z'
      )
    end
    it 'return results in 200 payload' do
      Etablissement.reindex

      get '/v1/near_point/?latitude=48.000&longitude=3.000'

      result_hash = body_as_json
      expect(body_as_json).to match(
        total_results: 1,
        total_pages: 1,
        etablissements: result_hash[:etablissements]
      )
      expect(result_hash[:etablissements].first[:id]).to eq(1)
      expect(response).to have_http_status(200)
    end
  end

  context 'when there are no results', type: :request do
    let!(:etablissement_to_not_find) do
      create(
        :etablissement,
        id: 3,
        siret: '123458',
        latitude: '50.000000',
        longitude: '50.000000',
        activite_principale_entreprise: '6201Z'
      )
    end
    it 'returns 404 payload' do
      Etablissement.reindex

      get '/v1/near_point/?latitude=20.000&longitude=20.000'

      expect(response.body).to look_like_json
      expect(body_as_json).to match(message: 'no results found')
      expect(response).to have_http_status(404)
    end
  end

  context 'when the request is bad', type: :request do
    let!(:etablissement_to_not_find) do
      create(
        :etablissement,
        id: 3,
        siret: '123458',
        latitude: '50.000000',
        longitude: '50.000000',
        activite_principale_entreprise: '6201Z'
      )
    end
    it 'returns 400 payload' do
      Etablissement.reindex

      get '/v1/near_point/?longitude=20.000'

      expect(response.body).to look_like_json
      expect(body_as_json).to match(message: 'bad request: missing latitude or longitude')
      expect(response).to have_http_status(400)
    end
  end
end

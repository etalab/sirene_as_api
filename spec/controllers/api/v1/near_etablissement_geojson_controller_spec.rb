require 'rails_helper'

describe API::V1::NearEtablissementGeojsonController do
  context 'when there are results', type: :request do
    let!(:etablissement_to_search) do
      create(
        :etablissement_v2,
        id: 1,
        siret: '123456',
        latitude: '48.000001',
        longitude: '3.000001',
        activite_principale: '6201Z',
        libelle_activite_principale: 'Programmation',
        nom_raison_sociale: 'SearchMe'
      )
    end
    let!(:etablissement_to_find) do
      create(
        :etablissement_v2,
        id: 2,
        siret: '123457',
        latitude: '48.000002',
        longitude: '3.000002',
        activite_principale: '6201Z',
        libelle_activite_principale: 'Programmation',
        nom_raison_sociale: 'FindMe'
      )
    end
    let!(:etablissement_to_not_find) do
      create(
        :etablissement_v2,
        id: 3,
        siret: '123458',
        latitude: '50.000000', # Unnamed road in Kazakhstan
        longitude: '50.000000',
        activite_principale: '6201Z',
        libelle_activite_principale: 'Programmation',
        nom_raison_sociale: 'DontFindMe'
      )
    end
    it 'return results in 200 payload' do
      EtablissementV2.reindex

      get '/v1/near_etablissement_geojson/123456'

      expect(body_as_json).to match(
        'type': 'FeatureCollection',
        'total_results': 1,
        'features': [{
          'type': 'Feature',
          'geometry': {
            'type': 'Point',
            'coordinates': [3.000002, 48.000002]
          },
          'properties': {
            'nom_raison_sociale': 'FindMe',
            'siret': '123457',
            'libelle_activite_principale': 'Programmation'
          }
        }]
      )
      expect(response).to have_http_status(200)
    end
  end

  context 'when no results', type: :request do
    let!(:etablissement_to_search) do
      create(
        :etablissement_v2,
        id: 1,
        siret: '123456',
        latitude: '48.000001',
        longitude: '3.000001',
        activite_principale: '6201Z'
      )
    end
    let!(:etablissement_to_not_find) do
      create(
        :etablissement_v2,
        id: 3,
        siret: '123458',
        latitude: '50.000000',
        longitude: '50.000000',
        activite_principale: '6201Z'
      )
    end
    it 'returns 404 payload' do
      EtablissementV2.reindex

      get '/v1/near_etablissement_geojson/123456'

      expect(response.body).to look_like_json
      expect(body_as_json).to match(message: 'no results found')
      expect(response).to have_http_status(404)
    end
  end

  context 'when SIRET isnt found', type: :request do
    let!(:etablissement_to_not_find) { create(:etablissement_v2, id: 1, siret: '123456') }
    it 'returns 400 payload' do
      EtablissementV2.reindex

      get '/v1/near_etablissement_geojson/999999'

      expect(response.body).to look_like_json
      expect(body_as_json).to match(message: 'invalid SIRET')
      expect(response).to have_http_status(400)
    end
  end

  context 'when there are etablissements with other activity', type: :request do
    let!(:etablissement_to_search) do
      create(
        :etablissement_v2,
        id: 1,
        siret: '123456',
        latitude: '48.000001',
        longitude: '3.000001',
        activite_principale: '6201Z'
      )
    end
    let!(:etablissement_to_find) do
      create(
        :etablissement_v2,
        id: 2,
        siret: '123457',
        latitude: '48.000002',
        longitude: '3.000002',
        activite_principale: '6201Z'
      )
    end
    let!(:etablissement_to_find2) do
      create(
        :etablissement_v2,
        id: 3,
        siret: '123458',
        latitude: '48.000001',
        longitude: '3.000002',
        activite_principale: '4242E'
      )
    end
    it 'find them' do
      EtablissementV2.reindex

      get '/v1/near_etablissement_geojson/123456'

      result_hash = body_as_json
      expect(response).to have_http_status(200)
      number_results = result_hash[:features].size
      expect(number_results).to eq(2)
    end
  end

  context 'when there are etablissements with other activity', type: :request do
    let!(:etablissement_to_search) do
      create(
        :etablissement_v2,
        id: 1,
        siret: '123456',
        latitude: '48.000001',
        longitude: '3.000001',
        activite_principale: '6201Z',
        nom_raison_sociale: 'SearchMe'
      )
    end
    let!(:etablissement_to_find) do
      create(
        :etablissement_v2,
        id: 2,
        siret: '123457',
        latitude: '48.000001',
        longitude: '3.000001',
        activite_principale: '6201Z',
        nom_raison_sociale: 'FindMe'
      )
    end
    let!(:etablissement_to_not_find) do
      create(
        :etablissement_v2,
        id: 3,
        siret: '123458',
        latitude: '48.000001',
        longitude: '3.000001',
        activite_principale: '4242E',
        nom_raison_sociale: 'DontFindMe'
      )
    end
    it 'doesnt find them if user doesnt want to' do
      EtablissementV2.reindex

      get '/v1/near_etablissement_geojson/123456?only_same_activity=true'

      result_hash = body_as_json
      expect(response).to have_http_status(200)
      number_results = result_hash[:features].size
      expect(number_results).to eq(1)
      expect(result_hash[:features].first[:properties][:nom_raison_sociale]).to eq('FindMe')
    end
  end

  context 'when there are etablissements with other approximate activity', type: :request do
    let!(:etablissement_to_search) do
      create(
        :etablissement_v2,
        id: 1,
        siret: '123456',
        latitude: '48.000001',
        longitude: '3.000001',
        activite_principale: '6201Z',
        nom_raison_sociale: 'SearchMe'
      )
    end
    let!(:etablissement_to_find) do
      create(
        :etablissement_v2,
        id: 2,
        siret: '123457',
        latitude: '48.000001',
        longitude: '3.000001',
        activite_principale: '6210E',
        nom_raison_sociale: 'FindMe'
      )
    end
    let!(:etablissement_to_not_find) do
      create(
        :etablissement_v2,
        id: 3,
        siret: '123458',
        latitude: '48.000001',
        longitude: '3.000001',
        activite_principale: '4242Z',
        nom_raison_sociale: 'DontFindMe'
      )
    end
    it 'find only them if user want to' do
      EtablissementV2.reindex

      get '/v1/near_etablissement_geojson/123456?approximate_activity=true'

      result_hash = body_as_json
      expect(response).to have_http_status(200)
      number_results = result_hash[:features].size
      expect(number_results).to eq(1)
      expect(result_hash[:features].first[:properties][:nom_raison_sociale]).to eq('FindMe')
    end
  end

  context 'when specifying the radius', type: :request do
    let!(:etablissement_to_search) do
      create(
        :etablissement_v2,
        id: 1,
        siret: '123456',
        latitude: '48.000001',
        longitude: '3.000001',
        activite_principale: '6201Z'
      )
    end
    let!(:etablissement_to_find) do
      create(
        :etablissement_v2,
        id: 2,
        siret: '123457',
        latitude: '48.000009',
        longitude: '3.000009',
        activite_principale: '6201Z'
      )
    end
    let!(:etablissement_to_find_after) do
      create(
        :etablissement_v2,
        id: 3,
        siret: '123458',
        latitude: '49.00000', # Unnamed road in Kazakhstan
        longitude: '4.000000',
        activite_principale: '6201Z'
      )
    end
    it 'correctly find the results' do
      EtablissementV2.reindex

      get '/v1/near_etablissement_geojson/123456'

      result_hash = body_as_json
      expect(result_hash[:features].size).to eq(1)

      get '/v1/near_etablissement_geojson/123456?radius=1000'
      result_hash = body_as_json
      expect(result_hash[:features].size).to eq(2)
    end
  end
end

require 'rails_helper'

describe API::V1::NearEtablissementController do
  context 'when there are results', type: :request do
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
    let!(:etablissement_to_not_find) do
      create(
        :etablissement_v2,
        id: 3,
        siret: '123458',
        latitude: '50.000000', # Unnamed road in Kazakhstan
        longitude: '50.000000',
        activite_principale: '6201Z'
      )
    end
    it 'return results in 200 payload' do
      EtablissementV2.reindex

      get '/v1/near_etablissement/123456'

      result_hash = body_as_json
      expect(body_as_json).to match(
        total_results: 1,
        total_pages: 1,
        per_page: 10,
        page: 1,
        etablissements: result_hash[:etablissements]
      )
      expect(result_hash[:etablissements].first[:id]).to eq(2)
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

      get '/v1/near_etablissement/123456'

      expect(response.body).to look_like_json
      expect(body_as_json).to match(message: 'no results found')
      expect(response).to have_http_status(404)
    end
  end

  context 'when SIRET isnt found', type: :request do
    let!(:etablissement_to_not_find) { create(:etablissement_v2, id: 1, siret: '123456') }
    it 'returns 400 payload' do
      EtablissementV2.reindex

      get '/v1/near_etablissement/999999'

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

      get '/v1/near_etablissement/123456'

      result_hash = body_as_json
      expect(response).to have_http_status(200)
      result_etablissements = result_hash.extract!(:etablissements)
      number_results = result_etablissements[:etablissements].size
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
        activite_principale: '6201Z'
      )
    end
    let!(:etablissement_to_find) do
      create(
        :etablissement_v2,
        id: 2,
        siret: '123457',
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
        latitude: '48.000001',
        longitude: '3.000001',
        activite_principale: '4242E'
      )
    end
    it 'doesnt find them if user doesnt want to' do
      EtablissementV2.reindex

      get '/v1/near_etablissement/123456?only_same_activity=true'

      result_hash = body_as_json
      expect(response).to have_http_status(200)
      result_etablissements = result_hash.extract!(:etablissements)
      number_results = result_etablissements[:etablissements].size
      expect(number_results).to eq(1)
      expect(result_etablissements[:etablissements].first[:id]).to eq(2)
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
        activite_principale: '6201Z'
      )
    end
    let!(:etablissement_to_find) do
      create(
        :etablissement_v2,
        id: 2,
        siret: '123457',
        latitude: '48.000001',
        longitude: '3.000001',
        activite_principale: '6210E'
      )
    end
    let!(:etablissement_to_not_find) do
      create(
        :etablissement_v2,
        id: 3,
        siret: '123458',
        latitude: '48.000001',
        longitude: '3.000001',
        activite_principale: '4242Z'
      )
    end
    it 'find only them if user want to' do
      EtablissementV2.reindex

      get '/v1/near_etablissement/123456?approximate_activity=true'

      result_hash = body_as_json
      expect(response).to have_http_status(200)
      result_etablissements = result_hash.extract!(:etablissements)
      number_results = result_etablissements[:etablissements].size
      expect(number_results).to eq(1)
      expect(result_etablissements[:etablissements].first[:id]).to eq(2)
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

      get '/v1/near_etablissement/123456'

      result_hash = body_as_json
      expect(result_hash[:etablissements].size).to eq(1)

      get '/v1/near_etablissement/123456?radius=1000'
      result_hash = body_as_json
      expect(result_hash[:etablissements].size).to eq(2)
    end
  end

  context 'when using param per_page', type: :request do
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
    it 'works' do
      populate_with_11_local_companies('48.000001', '3.000001')
      EtablissementV2.reindex

      get '/v1/near_etablissement/123456'
      result_hash = body_as_json
      result_hash.extract!(:etablissements)
      expect(result_hash).to match(
        total_results: 11,
        total_pages: 2,
        per_page: 10,
        page: 1
      )

      get '/v1/near_etablissement/123456?per_page=15'
      result_hash = body_as_json
      result_hash.extract!(:etablissements)
      expect(result_hash).to match(
        total_results: 11,
        total_pages: 1,
        per_page: 15,
        page: 1
      )

      get '/v1/near_etablissement/123456?per_page=5&page=2'
      result_hash = body_as_json
      result_hash.extract!(:etablissements)
      expect(result_hash).to match(
        total_results: 11,
        total_pages: 3,
        per_page: 5,
        page: 2
      )
    end
  end
end

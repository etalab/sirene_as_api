require 'rails_helper'

describe API::V1::NearPointController do
  context 'when there are results', type: :request do
    let!(:etablissement_to_find) do
      create(
        :etablissement_v2,
        id: 1,
        siret: '123457',
        latitude: '48.000002',
        longitude: '3.000002',
        activite_principale_entreprise: '6201Z'
      )
    end
    let!(:etablissement_to_not_find) do
      create(
        :etablissement_v2,
        id: 2,
        siret: '123458',
        latitude: '50.000000',
        longitude: '50.000000',
        activite_principale_entreprise: '6201Z'
      )
    end
    it 'return results in 200 payload' do
      EtablissementV2.reindex

      get '/v1/near_point/?lat=48.000&long=3.000'

      result_hash = body_as_json
      expect(body_as_json).to match(
        total_results: 1,
        total_pages: 1,
        per_page: 10,
        page: 1,
        etablissements: result_hash[:etablissements]
      )
      expect(result_hash[:etablissements].first[:id]).to eq(1)
      expect(response).to have_http_status(200)
    end
  end

  context 'when there are no results', type: :request do
    let!(:etablissement_to_not_find) do
      create(
        :etablissement_v2,
        id: 3,
        siret: '123458',
        latitude: '50.000000',
        longitude: '50.000000',
        activite_principale_entreprise: '6201Z'
      )
    end
    it 'returns 404 payload' do
      EtablissementV2.reindex

      get '/v1/near_point/?lat=20.000&long=20.000'

      expect(response.body).to look_like_json
      expect(body_as_json).to match(message: 'no results found')
      expect(response).to have_http_status(404)
    end
  end

  context 'when the request is bad', type: :request do
    let!(:etablissement_to_not_find) do
      create(
        :etablissement_v2,
        id: 3,
        siret: '123458',
        latitude: '50.000000',
        longitude: '50.000000',
        activite_principale_entreprise: '6201Z'
      )
    end
    it 'returns 400 payload' do
      EtablissementV2.reindex

      get '/v1/near_point/?long=20.000'

      expect(response.body).to look_like_json
      expect(body_as_json).to match(message: 'bad request: missing latitude or longitude')
      expect(response).to have_http_status(400)
    end
  end

  context 'when using param per_page', type: :request do
    it 'works' do
      populate_with_11_local_companies('48.000001', '3.000001')
      EtablissementV2.reindex

      get '/v1/near_point/?lat=48.000&long=3.000'
      result_hash = body_as_json
      result_hash.extract!(:etablissements)
      expect(result_hash).to match(
        total_results: 11,
        total_pages: 2,
        per_page: 10,
        page: 1
      )

      get '/v1/near_point/?lat=48.000&long=3.000&per_page=12'
      result_hash = body_as_json
      result_hash.extract!(:etablissements)
      expect(result_hash).to match(
        total_results: 11,
        total_pages: 1,
        per_page: 12,
        page: 1
      )

      get '/v1/near_point/?lat=48.000&long=3.000&per_page=5&page=2'
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

  context 'when using param filter activite_principale', type: :request do
    let!(:etablissement_to_not_find) do
      create(
        :etablissement_v2,
        id: 1,
        latitude: '48.000001',
        longitude: '3.000001',
        activite_principale: '6201Z',
        nom_raison_sociale: 'DontFindMe'
      )
    end
    let!(:etablissement_to_find) do
      create(
        :etablissement_v2,
        id: 2,
        latitude: '48.000001',
        longitude: '3.000001',
        activite_principale: '3410E',
        nom_raison_sociale: 'FindMe'
      )
    end
    it 'works' do
      EtablissementV2.reindex

      get '/v1/near_point/?lat=48.000&long=3.000&activite_principale=3410E'
      result_hash = body_as_json
      expect(result_hash[:etablissements].size).to eq(1)
      expect(result_hash[:etablissements].first[:nom_raison_sociale]).to eq('FindMe')
    end
  end

  context 'when using param filter approximate_activity', type: :request do
    let!(:etablissement_to_not_find) do
      create(
        :etablissement_v2,
        id: 1,
        latitude: '48.000001',
        longitude: '3.000001',
        activite_principale: '6201Z',
        nom_raison_sociale: 'DontFindMe'
      )
    end
    let!(:etablissement_to_find) do
      create(
        :etablissement_v2,
        id: 2,
        latitude: '48.000001',
        longitude: '3.000001',
        activite_principale: '3410E',
        nom_raison_sociale: 'FindMe'
      )
    end
    it 'works' do
      EtablissementV2.reindex

      get '/v1/near_point/?lat=48.000&long=3.000&approximate_activity=34'
      result_hash = body_as_json
      expect(result_hash[:etablissements].size).to eq(1)
      expect(result_hash[:etablissements].first[:nom_raison_sociale]).to eq('FindMe')
    end
  end
end

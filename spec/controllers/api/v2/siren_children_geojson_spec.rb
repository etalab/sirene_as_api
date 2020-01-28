require 'rails_helper'

describe API::V2::SirenChildrenGeojsonController do
  context 'When I request a SIREN', type: :request do
    siren = '833057201'

    context 'SIRENE 404' do
      let!(:etablissement) do
        create(
          :etablissement_v2,
          nom_raison_sociale: 'foobarcompany',
          siren: siren,
          siret: '123456',
          is_siege: '1',
          enseigne: 'au chou blanc',
          geo_adresse: '34 rue du bousin',
          longitude: '1',
          latitude: '2'
        )
      end

      it 'returns 404' do
        get '/v2/siren/111111/etablissements_geojson'

        expect(response).to have_http_status(404)
      end
    end

    context 'SIRENE 200' do
      let!(:etablissement) do
        create(
          :etablissement_v2,
          nom_raison_sociale: 'foobarcompany',
          siren: siren,
          siret: '123456',
          is_siege: '1',
          enseigne: 'au chou blanc',
          geo_adresse: '34 rue du bousin',
          longitude: '1',
          latitude: '2'
        )
      end
      let!(:etablissement2) do
        create(
          :etablissement_v2,
          nom_raison_sociale: 'foobarcompany',
          siren: siren,
          siret: '123457',
          is_siege: '0',
          enseigne: 'Seconde enseigne',
          geo_adresse: '38 rue du bousin',
          longitude: '1',
          latitude: '2'
        )
      end
      let!(:etablissement3) do
        create(
          :etablissement_v2,
          nom_raison_sociale: 'foobarcompany',
          siren: siren,
          siret: '123458',
          is_siege: '0',
          enseigne: 'au chou blanc trois',
          geo_adresse: '40 rue du bousin',
          longitude: '1',
          latitude: '2'
        )
      end
      it 'returns 200' do
        get "/v2/siren/#{siren}/etablissements_geojson"

        expect(response).to have_http_status(200)
        result_hash = body_as_json

        expect(result_hash[:siege_social][:properties][:siret]).to eq('123456')
        expect(result_hash[:features].size).to eq(2)
      end
    end
  end
end

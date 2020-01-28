require 'rails_helper'

describe API::V1::SirenController do
  context 'when doing a search that isnt found', type: :request do
    it 'doesnt return anything' do
      siren_not_found = '9999999999999999999999'
      get "/v1/siren/#{siren_not_found}"
      expect(response.body).to look_like_json
      expect(body_as_json).to match(message: 'no results found')
      expect(response).to have_http_status(404)
    end
  end

  context 'when doing a simple search', type: :request do
    siren_found = '123456789'
    siret_father = '12345678900002'
    siret_brother = '12345678900001'
    siret_sister = '12345678900003'
    unrelated_siren = '111111111'
    unrelated_siret = '11111111100001'
    let!(:etablissement_father) do
      create(
        :etablissement_v2,
        nom_raison_sociale: 'foobarcompany_father',
        siren: siren_found,
        siret: siret_father,
        is_siege: '1'
      )
    end

    let!(:etablissement_brother) do
      create(
        :etablissement_v2,
        nom_raison_sociale: 'foobarcompany_brother',
        siren: siren_found,
        siret: siret_brother,
        is_siege: '0'
      )
    end

    let!(:etablissement_sister) do
      create(
        :etablissement_v2,
        nom_raison_sociale: 'foobarcompany_sister',
        siren: siren_found,
        siret: siret_sister,
        is_siege: '0'
      )
    end

    let!(:etablissement_unrelated) do
      create(
        :etablissement_v2,
        nom_raison_sociale: 'unrelated_company',
        siren: unrelated_siren,
        siret: unrelated_siret,
        is_siege: '1'
      )
    end

    it 'return the correct etablissements' do
      EtablissementV2.reindex

      get "/v1/siren/#{siren_found}"

      expect(response.body).to look_like_json
      expect(response).to have_http_status(200)
      result_hash = body_as_json
      result_siege_social = result_hash.extract!(:siege_social)

      expect(result_hash).to match(
        total_results: 3,
        other_etablissements_sirets: [siret_sister, siret_brother],
        numero_tva_intra: 'FR32123456789'
      ).or match(
        total_results: 3,
        other_etablissements_sirets: [siret_brother, siret_sister],
        numero_tva_intra: 'FR32123456789'
      )
      expect(result_siege_social[:siege_social][:siret]).to eq(siret_father)
    end
  end
end

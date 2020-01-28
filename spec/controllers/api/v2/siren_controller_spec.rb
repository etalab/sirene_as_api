require 'rails_helper'

describe API::V2::SirenController do
  context 'When I request a SIREN', type: :request do
    siren = '431483007'
    subject { body_as_json }

    context 'SIRENE 200' do
      let!(:etablissement) do
        create(:etablissement_v2, nom_raison_sociale: 'foobarcompany', siren: siren, is_siege: '1', geo_score: '0.7')
      end

      let!(:etablissement_child) do
        create(:etablissement_v2, nom_raison_sociale: 'foobar_child', siren: siren, siret: '31415', is_siege: '0')
      end

      it 'works' do
        get "/v2/siren/#{siren}"

        # status
        expect(response).to have_http_status(200)
        expect(subject[:sirene][:status]).to eq(200)

        # Sirene data
        expect(subject[:sirene][:data][:siege_social][:nom_raison_sociale])
          .to eq('foobarcompany')
        expect(subject[:sirene][:data][:other_etablissements_sirets].first)
          .to eq('31415')

        # RNM data
        expect(subject[:repertoire_national_metiers][:api_http_link])
          .to eq('https://api-rnm.artisanat.fr/api/entreprise/431483007')

        # Computed data
        expect(subject[:computed][:data][:geo][:geo_score]).to eq('0.7')
        expect(subject[:computed][:data][:numero_tva_intra]).to eq('FR38431483007')
      end
    end

    context 'SIRENE 404' do
      let!(:etablissement) do
        create(:etablissement_v2, nom_raison_sociale: 'foobar_not_found', siren: '1111111', is_siege: '1')
      end

      it 'works' do
        get "/v2/siren/#{siren}"

        # status
        expect(response).to have_http_status(404)

        # Sirene data
        expect(subject[:sirene][:data]).to eq('etablissement not found in SIRENE database')
      end
    end
  end
end

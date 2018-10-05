require 'rails_helper'

describe API::V1::SirenController do
  context 'When I request a SIREN', type: :request do
    siren_rnm_ko = '833057201'
    siren_rnm_ok = '431483007'
    subject { body_as_json }

    context 'RNM 200', vcr: { cassette_name: 'request_RNM_200', allow_playback_repeats: true } do
      context 'SIRENE 200' do
        let!(:etablissement) { create(:etablissement, nom_raison_sociale: 'foobarcompany', siren: siren_rnm_ok, is_siege: '1', geo_score: '0.7') }
        let!(:etablissement_child) { create(:etablissement, nom_raison_sociale: 'foobar_child', siren: siren_rnm_ok, siret: '31415', is_siege: '0') }

        it 'works' do
          get "/v2/siren/#{siren_rnm_ok}"

          # status
          expect(response).to have_http_status(200)
          expect(subject[:sirene][:status]).to eq(200)
          expect(subject[:repertoire_national_metiers][:status]).to eq(200)

          # Sirene data
          expect(subject[:sirene][:data][:siege_social][:nom_raison_sociale]).to eq('foobarcompany')
          expect(subject[:sirene][:data][:other_etablissements_sirets].first).to eq('31415')

          # RNM data
          expect(subject[:repertoire_national_metiers][:data][:NOM]).to eq('LE BONJOUR')

          # Computed data
          expect(subject[:computed][:data][:geo][:geo_score]).to eq('0.7')
          expect(subject[:computed][:data][:numero_tva_intra]).to eq('FR38431483007')
        end
      end

      context 'SIRENE 404' do
        let!(:etablissement) { create(:etablissement, nom_raison_sociale: 'foobar_not_found', siren: '1111111', is_siege: '1') }

        it 'works' do
          get "/v2/siren/#{siren_rnm_ok}"

          # status
          expect(response).to have_http_status(200)
          expect(subject[:sirene][:status]).to eq(404)
          expect(subject[:repertoire_national_metiers][:status]).to eq(200)

          # Sirene data
          expect(subject[:sirene][:data]).to eq('etablissement not found in SIRENE database')

          # RNM data
          expect(subject[:repertoire_national_metiers][:data][:NOM]).to eq('LE BONJOUR')
        end
      end
    end

    # TODO when RNM will returns 404 correctly
    context 'RNM 404', vcr: { cassette_name: 'request_RNM_404', allow_playback_repeats: true } do
      context 'SIRENE 200' do
        subject { body_as_json }
        let!(:etablissement) { create(:etablissement, nom_raison_sociale: 'foobarcompany', siren: siren_rnm_ko, is_siege: '1', geo_score: '0.7') }
        let!(:etablissement_child) { create(:etablissement, nom_raison_sociale: 'foobar_child', siren: siren_rnm_ko, siret: '31415', is_siege: '0') }

        it 'works' do
          get "/v2/siren/#{siren_rnm_ko}"

          # status
          expect(response).to have_http_status(200)
          expect(subject[:sirene][:status]).to eq(200)
          expect(subject[:repertoire_national_metiers][:status]).to eq(200) # TODO replace with 404 when API RNM is ready

          # Sirene data
          expect(subject[:sirene][:data][:siege_social][:nom_raison_sociale]).to eq('foobarcompany')
          expect(subject[:sirene][:data][:other_etablissements_sirets].first).to eq('31415')

          # RNM data
          expect(subject[:repertoire_national_metiers][:data][:NOM]).to eq(nil) # TODO Replace when API RNM is ready

          # Computed data
          expect(subject[:computed][:data][:geo][:geo_score]).to eq('0.7')
          expect(subject[:computed][:data][:numero_tva_intra]).to eq('FR80833057201')
        end
      end

      context 'SIRENE 404' do
        let!(:etablissement) { create(:etablissement, nom_raison_sociale: 'foobarcompany', siren: '111111', is_siege: '1') }
        it 'returns 404'
      end
    end
  end
end

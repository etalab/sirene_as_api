describe SirenController do
  context 'when doing a search that isnt found', :type => :request do
    it 'doesnt return anything' do
      siren_not_found = '9999999999999999999999'
      get "/siren/#{siren_not_found}"
      expect(response.body).to look_like_json
      expect(body_as_json).to match(message: 'no results found')
      expect(response).to have_http_status(404)
    end
  end

  context 'when doing a simple search', :type => :request do
    siren_found = '123456789'
    siret_brother = '12345678900001'
    siret_sister = '12345678900002'
    unrelated_siren = '111111111'
    unrelated_siret = '11111111100001'
    let!(:etablissement_brother){ create(:etablissement, nom_raison_sociale: 'foobarcompany_brother', siren: siren_found, siret: siret_brother) }
    let!(:etablissement_sister){ create(:etablissement, nom_raison_sociale: 'foobarcompany_sister', siren: siren_found, siret: siret_sister) }
    let!(:etablissement_unrelated){ create(:etablissement, nom_raison_sociale: 'unrelated_company', siren: unrelated_siren, siret: unrelated_siret) }

    it 'return the correct list of sirets, in the correct order' do
      Etablissement.reindex

      get "/siren/#{siren_found}"

      expect(response.body).to look_like_json
      expect(response).to have_http_status(200)
      result_hash = body_as_json
      puts 'result_et:: ' + result_hash[:etablissements].to_s
      total_results = result_hash[:total_results]
      siret_results = result_hash[:etablissements]
      expect(total_results).to match(2)
      expect(siret_results).to match(["#{siret_brother}", "#{siret_sister}"])
    end
  end
end

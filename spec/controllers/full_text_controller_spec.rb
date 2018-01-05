require 'rails_helper'

describe FullTextController do
  context 'when doing a search that isnt found', type: :request do
    it 'doesnt return anything' do
      get '/full_text/ghost_company_5678754579828655384'
      expect(response.body).to look_like_json
      expect(body_as_json).to match(message: 'no results found')
      expect(response).to have_http_status(404)
    end
  end

  # Prioritize Etablissements which are Mairies
  context 'when looking for an Etablissement which have a Mairie (commune)', type: :request do
    let!(:etablissement1) { create(:etablissement, id: 1, nom_raison_sociale: 'Commune de Montpellier', enseigne: 'MAIRIE') }
    let!(:etablissement2) { create(:etablissement, id: 2, nom_raison_sociale: 'Commune de Montpellier', enseigne: 'null') }
    let!(:etablissement3) { create(:etablissement, id: 3, nom_raison_sociale: 'Montpellier', enseigne: 'others') }
    let!(:etablissement4) { create(:etablissement, id: 4, nom_raison_sociale: 'Unrelated', enseigne: 'null') }
    it 'prioritize the Mairie Etablissement result' do
      Etablissement.reindex

      get '/full_text/montpellier'

      result_hash = body_as_json
      result_etablissements = result_hash.extract!(:etablissement)
      expect(result_etablissements[:etablissement].size).to equal(3)
      expect(result_etablissements[:etablissement].first[:id]).to equal(1)
    end
  end

  # Per page param
  context 'when specifying the per_page param', type: :request do
    it 'return the right number of results per page' do
      per_page_custom = 15
      per_page_custom.times do
        create(:etablissement, nom_raison_sociale: 'foobarcompany')
      end
      Etablissement.reindex

      get "/full_text/foobarcompany?per_page=#{per_page_custom}"

      expect(response.body).to look_like_json
      result_hash = body_as_json
      result_hash.extract!(:etablissement)
      expect(result_hash).to match(
        total_results: per_page_custom,
        total_pages: 1,
        per_page: per_page_custom,
        page: 1
      )
    end
  end

  # Faceting
  context 'when doing a simple search with no facet', type: :request do
    let!(:etablissement) { create(:etablissement, nom_raison_sociale: 'foobarcompany') }
    it 'return the correct results' do
      Etablissement.reindex

      get '/full_text/foobarcompany'

      expect(response.body).to look_like_json
      result_hash = body_as_json
      result_etablissements = result_hash.extract!(:etablissement)
      expect(result_hash).to match(
        total_results: 1,
        total_pages: 1,
        per_page: 10,
        page: 1
      )
      name_result = result_etablissements[:etablissement][0][:nom_raison_sociale]
      expect(name_result).to match('foobarcompany')
      expect(response).to have_http_status(200)
    end
  end

  context 'when doing a 1 facet search', type: :request do
    let!(:etablissement) { create(:etablissement, nom_raison_sociale: 'foobarcompany', activite_principale: 'APE41') }
    let!(:etablissement2) { create(:etablissement, nom_raison_sociale: 'foobarcompany', activite_principale: 'APE42') }
    it 'return the correct results' do
      Etablissement.reindex

      get '/full_text/foobarcompany?activite_principale=APE42'

      expect(response.body).to look_like_json
      result_hash = body_as_json
      result_etablissements = result_hash.extract!(:etablissement)
      expect(result_hash).to match(
        total_results: 1,
        total_pages: 1,
        per_page: 10,
        page: 1
      )
      name_result = result_etablissements[:etablissement][0][:nom_raison_sociale]
      expect(name_result).to match('foobarcompany')
      expect(response).to have_http_status(200)
    end
  end

  context 'when doing a 2 facet search', type: :request do
   let!(:etablissement) { create(:etablissement, nom_raison_sociale: 'foobarcompany', activite_principale: 'ACTIVITY1', code_postal: '92000') }
   let!(:etablissement2) { create(:etablissement, nom_raison_sociale: 'foobarcompany', activite_principale: 'ACTIVITY2', code_postal: '75000') }
   let!(:etablissement3) { create(:etablissement, nom_raison_sociale: 'foobarcompany', activite_principale: 'ACTIVITY2', code_postal: '34070') }
   it 'return the correct results' do
     Etablissement.reindex

     get '/full_text/foobarcompany?activite_principale=ACTIVITY2&code_postal=34070'

     expect(response.body).to look_like_json
     result_hash = body_as_json
     result_etablissements = result_hash.extract!(:etablissement)
     expect(result_hash).to match(
       total_results: 1,
       total_pages: 1,
       per_page: 10,
       page: 1
     )
     name_result = result_etablissements[:etablissement][0][:nom_raison_sociale]
     expect(name_result).to match('foobarcompany')
     expect(response).to have_http_status(200)
   end
  end

  # Spellchecking
  context 'when a word contains a typo', type: :request do
    let!(:etablissement1) { create(:etablissement, nom_raison_sociale: 'foobarcompany') }
    let!(:etablissement2) { create(:etablissement, nom_raison_sociale: 'samplecompany') }
    let!(:etablissement3) { create(:etablissement, nom_raison_sociale: 'anothercompany') }
    it 'spellcheck correctly and return the correct word' do
      Etablissement.reindex

      get '/full_text/fo0barcompany' # Typo on purpose

      expect(response.body).to look_like_json
      result_hash = body_as_json
      result_spellcheck = result_hash[:etablissement][0][:nom_raison_sociale]
      expect(result_spellcheck).to match('foobarcompany')
      expect(response).to have_http_status(200)
    end
  end

  # Spellchecking collation
  context 'when two close words both contains a typo', type: :request do
    let!(:etablissement) { create(:etablissement, nom_raison_sociale: 'foobar company') }
    let!(:etablissement2) { create(:etablissement, nom_raison_sociale: 'sample company') }
    let!(:etablissement3) { create(:etablissement, nom_raison_sociale: 'another company') }
    it 'spellcheck correctly and return the correct word' do
      Etablissement.reindex

      get '/full_text/fo0bar%20compani' # Typos on purpose

      expect(response.body).to look_like_json
      result_hash = body_as_json
      result_spellcheck = result_hash[:etablissement][0][:nom_raison_sociale]
      expect(result_spellcheck).to match('foobar company')
      expect(response).to have_http_status(200)
    end
  end

  # Filtration of Etablissements out of commercial prospection
  context 'when there are only etablissements in commercial diffusion', type: :request do
    it 'show them in the search results' do
      populate_test_database_with_4_only_diffusion
      Etablissement.reindex

      get '/full_text/foobarcompany'

      result_hash = body_as_json
      result_etablissements = result_hash.extract!(:etablissement)
      number_results = result_etablissements[:etablissement].size

      expect(number_results).to match(4)
    end
  end

  context 'when there are only etablissements out of commercial diffusion', type: :request do
    it 'show nothing' do
      populate_test_database_with_3_no_diffusion
      Etablissement.reindex

      get '/full_text/foobarcompany'

      result_hash = body_as_json
      result_etablissements = result_hash.extract!(:etablissement)
      expect(result_etablissements).to be_empty
    end
  end

  context 'when there is every kind of etablissements', type: :request do
    it 'show no etablissements out of commercial diffusion' do
      populate_test_database_with_4_only_diffusion
      populate_test_database_with_3_no_diffusion
      Etablissement.reindex

      get '/full_text/foobarcompany'

      result_hash = body_as_json
      result_etablissements = result_hash.extract!(:etablissement)
      number_results = result_etablissements[:etablissement].size
      expect(number_results).to eq(4)
    end
  end

  # Params filter is_entrepreneur_individuel
  context 'when doing a search for entrepreneur individuel', type: :request do
    let!(:etablissement) { create(:etablissement, nom_raison_sociale: 'foobarcompany', nature_entrepreneur_individuel: '1') }
    let!(:etablissement2) { create(:etablissement, nom_raison_sociale: 'foobarcompany', nature_entrepreneur_individuel: '6') }
    let!(:etablissement3) { create(:etablissement, nom_raison_sociale: 'foobarcompany', nature_entrepreneur_individuel: '9') }
    let!(:etablissement4) { create(:etablissement, nom_raison_sociale: 'foobarcompany') }
    it 'show the entrepreneurs individuels in results when I want them' do
      Etablissement.reindex

      get '/full_text/foobarcompany?is_entrepreneur_individuel=yes'

      result_hash = body_as_json
      result_etablissements = result_hash.extract!(:etablissement)
      number_results = result_etablissements[:etablissement].size
      expect(number_results).to eq(3)
    end
    it 'doesnt show the entrepreneurs individuels when I dont want them' do
      Etablissement.reindex

      get '/full_text/foobarcompany?is_entrepreneur_individuel=no'

      result_hash = body_as_json
      result_etablissements = result_hash.extract!(:etablissement)
      number_results = result_etablissements[:etablissement].size
      expect(number_results).to eq(1)
    end
  end

  # Order results by score then Etablissement size
  context 'when doing a search for entrepreneur individuel', type: :request do
    let!(:etablissement1) { create(:etablissement, id: 1, nom_raison_sociale: 'foobarcompany', tranche_effectif_salarie_entreprise: '0') }
    let!(:etablissement2) { create(:etablissement, id: 2,nom_raison_sociale: 'foobarcompany', tranche_effectif_salarie_entreprise: '11') }
    let!(:etablissement3) { create(:etablissement, id: 3, nom_raison_sociale: 'foobarcompany2', tranche_effectif_salarie_entreprise: '0') }
    let!(:etablissement4) { create(:etablissement, id: 4, nom_raison_sociale: 'foobarcompany2', tranche_effectif_salarie_entreprise: '11') }
    let!(:etablissement5) { create(:etablissement, id: 5, nom_raison_sociale: 'randomcompany', tranche_effectif_salarie_entreprise: '53') }
    it 'order close matchs by score then by tranche_effectif_salarie_entreprise' do
      Etablissement.reindex

      get '/full_text/foobar*'

      result_hash = body_as_json
      result_etablissements = result_hash.extract!(:etablissement)
      id_from_etablissements = result_etablissements[:etablissement].map { |x| x[:id] }
      expect(id_from_etablissements).to eq([2, 4, 1, 3])
    end
  end
end

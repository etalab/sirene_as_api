require 'rails_helper'

describe FullTextController do
  context 'when doing a search that isnt found', :type => :request do
    it 'doesnt return anything' do
      get '/full_text/ghost_company_5678754579828655384'
      expect(response.body).to look_like_json
      expect(body_as_json).to match(message: 'no results found')
      expect(response).to have_http_status(404)
    end
  end

  context 'when doing a simple search with no facet', :type => :request do
    let!(:etablissement){ create(:etablissement, nom_raison_sociale: 'foobarcompany') }
    it 'return the correct results' do
      Etablissement.reindex

      get '/full_text/foobarcompany'

      expect(response.body).to look_like_json
      result_hash = body_as_json
      result_etablissements = result_hash.extract!(:etablissement)
      expect(result_hash).to match({
        total_results: 1,
        total_pages: 1,
        per_page: 10,
        page: 1,
      })
      name_result = result_etablissements[:etablissement][0][:nom_raison_sociale]
      expect(name_result).to match('foobarcompany')
      expect(response).to have_http_status(200)
    end
  end

  context 'when doing a 1 facet search', :type => :request do
    let!(:etablissement){ create(:etablissement, nom_raison_sociale: 'foobarcompany', activite_principale: 'APE41') }
    let!(:etablissement2){ create(:etablissement, nom_raison_sociale: 'foobarcompany', activite_principale: 'APE42') }
    it 'return the correct results' do
      Etablissement.reindex

      get '/full_text/foobarcompany?activite_principale=APE42'

      expect(response.body).to look_like_json
      result_hash = body_as_json
      result_etablissements = result_hash.extract!(:etablissement)
      expect(result_hash).to match({
        total_results: 1,
        total_pages: 1,
        per_page: 10,
        page: 1,
      })
      name_result = result_etablissements[:etablissement][0][:nom_raison_sociale]
      expect(name_result).to match('foobarcompany')
      expect(response).to have_http_status(200)
    end
  end

  # TODO : APE41 and 42 isnt explicit, should rename them, or create an array with reals APE, same for postal code
  context 'when doing a 2 facet search', :type => :request do
   let!(:etablissement){ create(:etablissement, nom_raison_sociale: 'foobarcompany', activite_principale: 'APE41', code_postal: '123456') }
   let!(:etablissement2){ create(:etablissement, nom_raison_sociale: 'foobarcompany', activite_principale: 'APE42', code_postal: '234567') }
   let!(:etablissement3){ create(:etablissement, nom_raison_sociale: 'foobarcompany', activite_principale: 'APE42', code_postal: '424242') }
   it 'return the correct results' do
     Etablissement.reindex

     get '/full_text/foobarcompany?activite_principale=APE42&code_postal=424242'

     expect(response.body).to look_like_json
     result_hash = body_as_json
     result_etablissements = result_hash.extract!(:etablissement)
     expect(result_hash).to match({
       total_results: 1,
       total_pages: 1,
       per_page: 10,
       page: 1,
     })
     name_result = result_etablissements[:etablissement][0][:nom_raison_sociale]
     expect(name_result).to match('foobarcompany')
     expect(response).to have_http_status(200)
   end
  end

  context 'when a word contains a typo', :type => :request do
   let!(:etablissement){ create(:etablissement, nom_raison_sociale: 'foobarcompany') }
   let!(:etablissement2){ create(:etablissement, nom_raison_sociale: 'samplecompany') }
   let!(:etablissement3){ create(:etablissement, nom_raison_sociale: 'anothercompany') }
   it 'spellcheck correctly and return the correct word' do
     Etablissement.reindex

     get '/full_text/foubarcompany' # Typo here on purpose

     expect(response.body).to look_like_json
     result_hash = body_as_json
     result_spellcheck = result_hash.extract!(:spellcheck_suggestion)
     expect(result_spellcheck).to match('foobarcompany')
     expect(response).to have_http_status(200)
   end
  end
end

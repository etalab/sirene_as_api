require 'rails_helper'

describe FullTextController do
  use_database_cleaner
  # use_solr

  context 'when doing a search that isnt found', :type => :request do
    it 'doesnt return anything' do
      get "/full_text/thiscompanydoesntexist5678754579828655384"
      expect(response.body).to look_like_json
      expect(body_as_json).to match({
        total_results: 0,
        total_pages: 0,
        per_page: 10,
        page: 1,
        etablissement: [],
        })
    end
  end
  context 'when doing a simple search', :type => :request do
    it 'return the correct results' do
      create(:etablissement, nom: "foobarcompany")
      create(:etablissement, nom: "foobarcompany2")
      create(:etablissement, nom: "foobarcompany3")
      create(:etablissement, nom: "foobarcompany4")
      sleep 2
      get "/full_text/:id", :params => { id: 'foobarcompany' }

      expect(response.body).to look_like_json
      expect(body_as_json).to match({
        total_results: 1,
        total_pages: 1,
        per_page: 10,
        page: 1,
        etablissement: 1,
        })
    end
  end

  context 'when doing a 1 facet search' do
    it 'return the correct results'
  end

  context 'when doing a 2 facet search' do
    it 'return the correct results'
  end
end

# system("curl 'localhost:3000/full_text/MA_RECHERCHE'")
# system("curl 'localhost:3000/siret/MON_SIRET'")

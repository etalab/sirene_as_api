require 'rails_helper'

describe SiretController do
  context 'when doing a search that isnt found', :type => :request do
    it 'doesnt return anything' do
      get '/siret/039384845678754579828655384'
      expect(response.body).to look_like_json
      expect(body_as_json).to match(message: 'no results found')
      expect(response).to have_http_status(404)
    end
  end

# TODO sirets more explicit, maybe with a #{siret_not_found}
  context 'when doing a simple search', :type => :request do
    let!(:etablissement){ create(:etablissement, nom_raison_sociale: 'foobarcompany', siret: '666555444') }
    it 'return the correct results' do
      Etablissement.reindex

      get '/siret/666555444'

      expect(response.body).to look_like_json
      expect(response).to have_http_status(200)
      result_hash = body_as_json

      name_etablissement = result_hash[:etablissement][:nom_raison_sociale]
      expect(name_etablissement).to match('foobarcompany')
    end
  end
end

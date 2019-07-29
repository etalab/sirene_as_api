require 'rails_helper'

describe API::V3::EtablissementsController do
  include_context 'api v3 response',       :etablissement, :siret, :enseigne_1

  it_behaves_like 'a scopable controller', :etablissement, :siret, :enseigne_1
  it_behaves_like 'a paginable controller',:etablissement, :siret, :enseigne_1
  it_behaves_like 'a REST API',            :etablissement, :siret, :enseigne_1

  describe 'associations', type: :request do
    let!(:unite_legale) { create(:unite_legale_with_etablissements, etablissements_count: 3) }
    let(:results) { response.parsed_body['etablissements']}

    subject { response }

    before { get "/v3/etablissements" }

    it 'returns his parent unite_legale' do
      # Factorybot returns timestamps as Date format whereas ActiveSerializer returns as json
      expected = adapt_timestamps unite_legale.serializable_hash
      expect(results[0]['unite_legale']).to eq(expected)
    end
  end
end

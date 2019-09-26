require 'rails_helper'

describe API::V3::UnitesLegalesController do
  include_context 'api v3 response',       :unite_legale, :siren, :nom

  it_behaves_like 'a scopable controller', :unite_legale, :siren, :nom
  it_behaves_like 'a paginable controller', :unite_legale, :siren, :nom
  it_behaves_like 'a REST API', :unite_legale, :siren, :nom

  describe 'associations', type: :request do
    let!(:unite_legale)    { create(:unite_legale) }
    let!(:etablissement_1) { create(:etablissement, unite_legale: unite_legale, etablissement_siege: 'true') }
    let!(:etablissement_2) { create(:etablissement, unite_legale: unite_legale, etablissement_siege: 'false') }

    let(:results) { response.parsed_body['unites_legales'] }

    subject { response }

    before { get '/v3/unites_legales' }

    # Parsing as json to replicate serializer formatting for timestamps
    let(:children_1) { JSON.parse etablissement_1.to_json }
    let(:children_2) { JSON.parse etablissement_2.to_json }

    it 'returns its two children etablissements' do
      expect(results[0]['etablissements']).to contain_exactly(children_1, children_2)
    end

    it 'returns the siege etablissement' do
      expect(results[0]['etablissement_siege']).to eq(children_1)
    end
  end
end

require 'rails_helper'

describe API::V3::UnitesLegalesController do
  include_context 'api v3 response',       :unite_legale, :siren, :nom

  it_behaves_like 'a scopable controller', :unite_legale, :siren, :nom
  it_behaves_like 'a paginable controller',:unite_legale, :siren, :nom
  it_behaves_like 'a REST API',            :unite_legale, :siren, :nom

  # Test wont pass on some systems because of milliseconds in timestamps
  # https://github.com/travisjeffery/timecop/issues/97#issuecomment-41294684
  less_accurate_time do
    describe 'associations', type: :request do
      let!(:etablissement_1) { create(:etablissement_with_unite_legale) }
      let!(:etablissement_2) { create(:etablissement_with_unite_legale, parent: etablissement_1.unite_legale) }


      let(:results) { response.parsed_body['unites_legales'] }

      subject { response }

      before { get "/v3/unites_legales" }

      let(:children_1) { adapt_timestamps etablissement_1.serializable_hash }
      let(:children_2) { adapt_timestamps etablissement_2.serializable_hash }

      let(:expected_association) {{ "etablissements" => a_collection_containing_exactly(children_1, children_2) }}
      it 'returns its two children etablissements' do
        expect(results[0]["etablissements"]).to eq(expected_association)
      end
    end
  end
end

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

  context 'when asking for non diffusable' do
    subject { response }

    let(:attributes) { UniteLegale.new.attributes.keys }
    let(:mandatory_fields) { %w[id siren statut_diffusion etablissements etablissement_siege date_dernier_traitement created_at updated_at] }
    let(:mandatory_fields_matcher) { mandatory_fields.map { |f| [f, be_truthy] }.to_h }
    let(:remaining_fields_matcher) do
      remaining_fields = attributes - mandatory_fields
      remaining_fields.map { |f| [f, be_nil] }.to_h
    end

    describe '#index', type: :request do
      let!(:unites_legales) { create_list :unite_legale, 3, :non_diffusable }

      before { get route.to_s }

      it { is_expected.to have_http_status(:ok) }

      it 'has authorized fields' do
        expect(subject.parsed_body[records]).to all include(mandatory_fields_matcher)
      end

      it 'has null in the remaining fields' do
        expect(subject.parsed_body[records]).to all include(remaining_fields_matcher)
      end
    end

    describe '#show', type: :request do
      let!(:unite_legale) { create :unite_legale, :non_diffusable }

      before { get "#{route}/#{unite_legale.siren}" }

      it { is_expected.to have_http_status(:ok) }

      it 'has authorized fields' do
        expect(subject.parsed_body[record]).to include(mandatory_fields_matcher)
      end

      it 'has null in the remaining fields' do
        expect(subject.parsed_body[record]).to include(remaining_fields_matcher)
      end
    end
  end
end

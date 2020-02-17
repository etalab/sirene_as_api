require 'rails_helper'

describe API::V3::EtablissementsController do
  include_context 'api v3 response',       :etablissement, :siret, :enseigne_1

  it_behaves_like 'a scopable controller', :etablissement, :siret, :enseigne_1
  it_behaves_like 'a paginable controller', :etablissement, :siret, :enseigne_1
  it_behaves_like 'a REST API', :etablissement, :siret, :enseigne_1

  describe 'associations', type: :request do
    let!(:unite_legale) { create(:unite_legale_with_2_etablissements) }
    let(:results) { response.parsed_body['etablissements'] }

    subject { response }

    before { get '/v3/etablissements' }

    it 'returns his parent unite_legale' do
      # Parsing as json to replicate serializer formatting for timestamps
      expect(results[0]['unite_legale']).to include(JSON.parse(unite_legale.to_json))
    end
  end

  context 'when asking for non diffusable' do
    subject { response }

    let(:attributes) { Etablissement.new.attributes.keys }
    let(:mandatory_fields) { %w[id siren nic siret statut_diffusion date_dernier_traitement created_at updated_at] }
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
      let(:siret) { unite_legale.etablissements.first.siret }

      before { get "#{route}/#{siret}" }

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

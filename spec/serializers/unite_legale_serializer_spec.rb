require 'rails_helper'

describe API::V3::UniteLegaleSerializer do
  subject { described_class.new(unite_legale).as_json.deep_symbolize_keys }

  context 'statut diffusion O' do
    let(:unite_legale) { create :unite_legale_with_2_etablissements }

    it 'serialize all fields normally' do
      expect(subject).to include(
        denomination: be_a(String),
        etablissement_siege: include(enseigne_1: be_a(String)),
        etablissements: have(2).items
      )
    end
  end

  context 'statut diffusion N' do
    let(:unite_legale) { create :unite_legale, :non_diffusable }

    it 'serialize everything to nil except white list fields' do
      expect(subject).to include(
        id: unite_legale.id,
        denomination: nil,
        siren: unite_legale.siren,
        statut_diffusion: 'N',
        date_dernier_traitement: unite_legale.date_dernier_traitement,
        etablissements: have(1).item,
        etablissement_siege: include(enseigne_1: nil),
        created_at: unite_legale.created_at,
        updated_at: unite_legale.updated_at
      )
    end
  end
end

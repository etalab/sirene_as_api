require 'rails_helper'

describe API::V3::EtablissementSerializer do
  subject { described_class.new(etab).as_json.deep_symbolize_keys }

  context 'statut diffusion O' do
    let(:unite_legale) { create :unite_legale }
    let(:etab) { create :etablissement, unite_legale: unite_legale }

    it 'serialize all fields normally' do
      expect(subject).to include(
        enseigne_1: be_a(String),
        unite_legale: an_object_having_attributes(denomination: be_a(String))
      )
    end
  end

  context 'statut diffusion N' do
    let(:etab) { create :etablissement, :non_diffusable }

    it 'serialize everything to nil except white list fields' do
      expect(subject).to include(
        id: etab.id,
        enseigne_1: nil,
        siret: etab.siret,
        nic: etab.nic,
        siren: etab.siren,
        statut_diffusion: 'N',
        date_dernier_traitement: etab.date_dernier_traitement,
        created_at: etab.created_at,
        updated_at: etab.updated_at
      )
    end
  end
end

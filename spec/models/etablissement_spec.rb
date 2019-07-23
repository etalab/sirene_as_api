require 'rails_helper'

describe Etablissement do
  it { is_expected.to belong_to(:unite_legale).optional }

  it 'has header_mapping' do
    expect(described_class.header_mapping).to include 'statutDiffusionEtablissement' => :statut_diffusion
  end
end

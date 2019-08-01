require 'rails_helper'

describe UniteLegale do
  it { is_expected.to have_many :etablissements }

  it 'has header_mapping' do
    expect(described_class.header_mapping).to include 'statutDiffusionUniteLegale' => :statut_diffusion
  end
end

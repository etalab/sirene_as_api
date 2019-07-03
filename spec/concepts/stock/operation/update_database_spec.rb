require 'rails_helper'

describe Stock::Operation::UpdateDatabase, :trb, vcr: { cassette_name: 'update_database' } do
  subject { described_class.call logger: logger }

  let(:logger) { instance_spy Logger }

  it { is_expected.to be_success }

  it 'calls LoadUniteLegale' do
    expect_to_call_nested_operation(UniteLegale::Operation::Load)
    subject
  end

  it 'calls LoadEtablissements' do
    expect_to_call_nested_operation(Etablissement::Operation::Load)
    subject
  end
end

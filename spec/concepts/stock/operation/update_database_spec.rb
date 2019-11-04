require 'rails_helper'

describe Stock::Operation::UpdateDatabase, :trb, vcr: { cassette_name: 'update_database' } do
  let(:logger) { instance_spy Logger }

  subject { described_class.call logger: logger, options: { safe: false } }

  it { is_expected.to be_success }

  it 'calls AuthorizeImport' do
    expect_to_call_nested_operation(Server::Operation::AuthorizeImport)
    subject
  end

  it 'calls LoadUniteLegale' do
    expect_to_call_nested_operation(Stock::Operation::LoadUniteLegale)
    subject
  end

  it 'calls LoadEtablissements' do
    expect_to_call_nested_operation(Stock::Operation::LoadEtablissement)
    subject
  end
end

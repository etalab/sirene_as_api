require 'rails_helper'

describe Stock::Operation::UpdateDatabase, :trb, vcr: { cassette_name: 'update_database' } do
  subject { described_class.call logger: logger }

  let(:logger) { instance_spy Logger }

  shared_examples 'both imports succeed' do
    it { is_expected.to be_success }

    it 'calls LoadUniteLegale' do
      expect_to_call_nested_operation(Stock::Operation::LoadEtablissement)
      subject
    end

    it 'calls LoadEtablissements' do
      expect_to_call_nested_operation(Stock::Operation::LoadUniteLegale)
      subject
    end
  end

  context 'when database is empty' do
    it_behaves_like 'both imports succeed'
  end

  # issue : https://github.com/etalab/sirene_as_api/issues/229
  # StockEtablissement corrupted for few days import never completed
  context 'when UniteLegale already imported but not Etablissement' do
    before do
      create :stock_unite_legale, :of_july, :completed
      create :stock_etablissement, :of_july, :errored
    end

    it 'log a warning unite legale is ignored' do
      subject
      expect(logger)
        .to have_received(:warn)
        .with('Remote stock not importable (remote month: 07, current (COMPLETED) month: 07)')
    end

    it_behaves_like 'both imports succeed'
  end
end

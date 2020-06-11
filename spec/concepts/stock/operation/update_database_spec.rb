require 'rails_helper'

describe Stock::Operation::UpdateDatabase, :trb do
  subject { described_class.call logger: logger }

  let(:logger) { instance_spy Logger }

  shared_examples 'both imports succeed' do
    it { is_expected.to be_success }

    it 'calls CheckStockAvailability' do
      expect_to_call_nested_operation(Stock::Operation::CheckStockAvailability)
      subject
    end

    it 'calls LoadUniteLegale' do
      expect_to_call_nested_operation(Stock::Operation::LoadEtablissement)
      subject
    end

    it 'calls LoadEtablissements' do
      expect_to_call_nested_operation(Stock::Operation::LoadUniteLegale)
      subject
    end
  end

  context 'when database is empty', vcr: { cassette_name: 'update_empty_database' } do
    it_behaves_like 'both imports succeed'
  end

  # issue : https://github.com/etalab/sirene_as_api/issues/229
  # StockEtablissement corrupted for few days import never completed
  context 'when UniteLegale already imported but not Etablissement', vcr: { cassette_name: 'update_database' } do
    before do
      Timecop.freeze('2020-06-11')
      create :stock_unite_legale, :of_june, :completed, year: '2020'
      create :stock_etablissement, :of_june, :errored, year: '2020'
    end

    it 'log a warning unite legale is ignored' do
      subject
      expect(logger)
        .to have_received(:warn)
        .with('Latest stock available (from month 06) already exists with status COMPLETED')
    end

    it_behaves_like 'both imports succeed'
  end
end

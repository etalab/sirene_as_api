require 'rails_helper'

describe UniteLegale::Operation::Load, vcr: { cassette_name: 'data_gouv_sirene_june_OK' } do
  subject { described_class.call logger: logger }

  let(:logger) { instance_spy Logger }
  let(:stock_model) { StockUniteLegale }
  let(:expected_uri) { 'http://files.data.gouv.fr/insee-sirene/StockUniteLegale_utf8.zip' }
  let(:vcr_record_month) { '07' }

  context 'when a new stock is available' do
    before { create :stock_unite_legale, month: '05', year: '2019', status: 'COMPLETED' }

    it_behaves_like 'stock successfully loaded'

    it 'does not log database empty' do
      subject
      expect(logger)
        .not_to have_received(:info).with('Database empty')
    end
  end

  context 'when no new stock is available' do
    before { create :stock_unite_legale, month: '07', year: '2019', status: 'COMPLETED' }

    it { is_expected.to be_failure }

    it 'logs a warning' do
      subject
      expect(logger)
        .to have_received(:warn)
        .with("Database up to date (found 07, current 07)")
    end

    its([:remote_stock]) { is_expected.not_to be_persisted }

    it 'does not enqueue job' do
      expect { subject }
        .not_to have_enqueued_job ImportStockJob
    end
  end

  context 'when the database is empty' do
    it_behaves_like 'stock successfully loaded'

    it 'logs database empty' do
      subject
      expect(logger)
        .to have_received(:info).with('Database empty')
    end
  end
end

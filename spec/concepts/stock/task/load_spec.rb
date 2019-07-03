require 'rails_helper'

describe Stock::Task::Load do
  subject do
    described_class.call(
      current_stock: current_stock,
      remote_stock: remote_stock,
      logger: logger)
  end

  let(:logger) { instance_spy Logger }
  let(:expected_uri) { 'random/path' }
  let(:stock_model) { Stock }

  context 'when a new stock is available' do
    let!(:current_stock) { create :stock, month: '05', year: '2019', status: 'COMPLETED' }
    let(:remote_stock)  { build :stock, month: vcr_record_month, year: '2019', status: 'PENDING' }
    let(:vcr_record_month) { '06' }

    it_behaves_like 'stock successfully loaded'

    it 'does not log database empty' do
      subject
      expect(logger)
        .not_to have_received(:info).with('Database empty')
    end
  end

  context 'when no new stock is available' do
    let!(:current_stock) { create :stock, month: '07', year: '2019', status: 'COMPLETED' }
    let(:remote_stock)  { build :stock, month: vcr_record_month, year: '2019', status: 'PENDING' }
    let(:vcr_record_month) { '07' }

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

  context 'when database is empty' do
    let(:current_stock) { nil }
    let(:remote_stock)  { build :stock, month: '01', year: '2019', status: 'PENDING' }
    let(:vcr_record_month) { '01' }

    it_behaves_like 'stock successfully loaded'

    it 'logs database empty' do
      subject
      expect(logger)
        .to have_received(:info).with('Database empty')
    end
  end
end

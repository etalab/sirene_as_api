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

  context 'when new stock is importable' do
    let!(:current_stock) { create :stock, :of_june, :completed }
    let(:remote_stock)   { build :stock, :of_july, :pending }

    it { is_expected.to be_success }

    it 'logs import will start' do
      subject
      expect(logger)
        .to have_received(:info)
        .with("New stock found 07, will import...")
    end

    it 'shedule a new ImportStockJob' do
      expect { subject }
        .to have_enqueued_job(ImportStockJob)
        .on_queue('sirene_test_stock')
    end

    it 'persist a new stock to import' do
      expect { subject }.to change(Stock, :count).by(1)
    end

    its([:remote_stock]) { is_expected.to be_persisted }
    its([:remote_stock]) { is_expected.to have_attributes(uri: expected_uri, status: 'PENDING', month: '07', year: '2019') }
  end

  context 'when new stock is not importable' do
    let!(:current_stock) { create :stock, :of_july, :completed }
    let(:remote_stock)   { build :stock, :of_july, :pending }

    it { is_expected.to be_failure }

    it 'logs a warning' do
      subject
      expect(logger)
        .to have_received(:warn)
        .with("Remote stock not importable (remote month: 07, current (COMPLETED) month: 07)")
    end

    its([:remote_stock]) { is_expected.not_to be_persisted }

    it 'does not enqueue job' do
      expect { subject }
        .not_to have_enqueued_job ImportStockJob
    end
  end
end

require 'rails_helper'

describe Stock::Task::PreLoadChecks do
  subject { described_class.call logger: logger }

  let(:logger) { instance_double(Logger).as_null_object }

  describe 'when not stock in database' do
    it { is_expected.to be_success }
    its([:current_stock]) { is_expected.to be_nil }

    it 'logs database empty' do
      expect(logger).to receive(:info).with('Database empty, will import...')
      subject
    end
  end

  describe 'when last stock is COMPLETED' do
    let!(:current_stock) { create :stock, status: 'COMPLETED' }

    it { is_expected.to be_success }
    its([:current_stock]) { is_expected.to eq current_stock }
  end

  describe 'when last stock is ERROR' do
    let!(:current_stock) { create :stock, status: 'ERROR' }

    it { is_expected.to be_success }
    its([:current_stock]) { is_expected.to be_nil }

    it 'deletes the previous stock in ERROR' do
      subject
      expect(Stock.exists?(current_stock.id)).to be false
    end

    it 'logs previous stock deleted' do
      expect(logger).to receive(:info).with('Previous stock in ERROR, will re-import...')
      subject
    end
  end

  describe 'when last stock is PENDING or LOADING' do
    let!(:current_stock) { create :stock, status: 'PENDING' }

    it { is_expected.to be_failure }
    its([:current_stock]) { is_expected.to be_nil }

    it 'logs import running' do
      expect(logger).to receive(:error).with('Current stock is PENDING')
      subject
    end
  end
end

require 'rails_helper'

describe Stock::Task::ImportCSV do
  subject { described_class.call csv: csv, model: model, logger: logger }

  let(:model) do
    Class.new do
      def self.header_mapping
        { test: :hello_world }
      end
    end
  end

  let(:logger) { instance_spy Logger }
  let(:csv) { Rails.root.join 'spec', 'fixtures', 'sample_etablissements_OK.csv' }

  describe 'when file exists' do
    before do
      allow_any_instance_of(Files::Helper::FileImporter)
        .to receive(:bulk_import)
        .and_yield(3)
        .and_yield(4)
    end

    it { is_expected.to be_success }

    it 'calls FileImporter' do
      expect_any_instance_of(Files::Helper::FileImporter)
        .to receive(:bulk_import)
        .with(file: csv, model: model)
      subject
    end
  end

  describe 'when import fails' do
    it { is_expected.to be_failure }

    it 'logs an error' do
      subject
      expect(logger).to have_received(:error)
        .with('Missing Headers in CSV: [:hello_world]')
    end
  end

  describe 'when csv is not found' do
    let(:csv) { Rails.root.join('spec', 'fixtures', 'cant_find_this').to_s }

    it { is_expected.to be_failure }

    it 'logs an error' do
      expect(logger).to receive(:error).with(/File not found.+/)
      subject
    end
  end
end

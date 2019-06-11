require 'rails_helper'

describe Stock::Task::Import do
  subject { described_class.call csv: csv, logger: logger }

  let(:logger) { instance_double(Logger).as_null_object }

  before do
    dbl_bar = instance_double(ProgressBar::Base, increment: nil)
    allow(ProgressBar).to receive(:create).and_return dbl_bar
  end

  describe 'when csv is valid' do
    let(:csv) { Rails.root.join('spec', 'concepts', 'stock', 'sample_stock_v3_OK.csv').to_s }

    it { is_expected.to be_success }

    it 'imports all' do
      expect { subject }.to change(EtablissementV3, :count).by 3
    end

    specify 'data is correct' do
      subject
      expect(EtablissementV3.find_by siret: '00588003400011').to be
    end
  end

  describe 'when csv is invalid' do
    let(:csv) { Rails.root.join('spec', 'concepts', 'stock', 'sample_stock_v3_KO.csv').to_s }

    it { is_expected.to be_failure }

    it 'logs an error' do
      expect(logger).to receive(:error).with(/Import failed, SmarterCSV::HeaderSizeMismatch:/)
      subject
    end
  end

  describe 'when csv is not found' do
    let(:csv) { Rails.root.join('spec', 'concepts', 'stock', 'cant_find_this').to_s }

    it { is_expected.to be_failure }

    it 'logs an error' do
      expect(logger).to receive(:error).with(/File not found.+/)
      subject
    end
  end
end

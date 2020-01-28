require 'rails_helper'

describe Files::Helper::FileImporter do
  subject { described_class.new(logger).bulk_import(file: csv, model: model, &block) }

  let(:logger) { instance_spy Logger }
  let(:model)  { Etablissement }
  let(:block)  { proc {} }
  let(:etab_1) { build :etablissement, siret: '123' }
  let(:etab_2) { build :etablissement, siret: '456' }
  let(:etab_3) { build :etablissement, siret: '789' }

  describe 'when file is valid' do
    before do
      allow_any_instance_of(Files::Helper::CSVReader)
        .to receive(:bulk_processing)
        .and_yield([etab_1, etab_2])
        .and_yield([etab_3])
    end

    let(:csv) { Rails.root.join 'spec', 'fixtures', 'sample_etablissements_OK.csv' }

    it 'calls import on a chunk of models' do
      expect(model).to receive(:import)
        .with([etab_1, etab_2], validate: false)
        .ordered
        .and_call_original

      expect(model).to receive(:import)
        .with([etab_3], validate: false)
        .ordered
        .and_call_original

      subject
    end

    it 'yields imported row count' do
      expect do |b|
        described_class.new(logger).bulk_import(file: csv, model: model, &b)
      end.to yield_successive_args(2, 1)
    end

    it 'imports 3 etablissements' do
      expect { subject }.to change(model, :count).by(3)
    end
  end

  context 'when file headers are invalid' do
    let(:csv) { Rails.root.join 'spec', 'fixtures', 'sample_etablissements_KO_missing_header.csv' }

    it 'logs an error' do
      subject
      expect(logger).to have_received(:error).with('Missing Headers in CSV: [:nic]')
    end

    it 'does not call import on model' do
      expect(model).not_to receive(:import)
      subject
    end

    it 'yields falsey value' do
      expect do |b|
        described_class.new(logger)
          .bulk_import(file: csv, model: model, &b)
      end.to yield_with_args false
    end
  end
end

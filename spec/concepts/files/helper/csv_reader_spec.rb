require 'rails_helper'

describe Files::Helper::CSVReader do
  subject { described_class.new logger }

  let(:block)  { proc {} }
  let(:model)  { Etablissement }
  let(:logger) { instance_spy Logger }

  before do
    allow_any_instance_of(described_class).to receive(:chunk_size).and_return 2
  end

  describe 'when file is valid' do
    let(:file) { Rails.root.join 'spec', 'fixtures', 'sample_etablissements_OK.csv' }

    it 'yields the values' do
      expect do |b|
        subject.bulk_processing(file, model, &b)
      end.to yield_successive_args(
        [
          a_hash_including(siren: '005880034', statut_diffusion: 'O'),
          a_hash_including(siren: '006003560', statut_diffusion: 'O')
        ], [
          a_hash_including(siren: '006004659', statut_diffusion: 'O')
        ]
      )
    end
  end

  context 'when file headers are invalid' do
    let(:file) { Rails.root.join 'spec', 'fixtures', 'sample_etablissements_KO_missing_header.csv' }

    it 'logs an error' do
      subject.bulk_processing(file, model, &block)
      expect(logger).to have_received(:error).with('Missing Headers in CSV: [:nic]')
    end

    it 'yields falsey value' do
      expect { |b| subject.bulk_processing(file, model, &b) }.to yield_with_args false
    end
  end
end

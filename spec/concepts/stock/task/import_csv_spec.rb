require 'rails_helper'

describe Stock::Task::ImportCSV do
  include_context 'mute progress bar'

  subject { described_class.call csv: csv, model: model, logger: logger }

  let(:logger) { instance_spy Logger }

  shared_examples 'importing a valid CSV' do
    it { is_expected.to be_success }

    it 'imports all' do
      expect { subject }.to change(model, :count).by 3
    end

    it 'read the file by chunk' do
      expect(SmarterCSV)
        .to receive(:process)
        .with(csv, include(chunk_size: 2_000))

      subject
    end

    it 'import the data by batch' do
      expect(model).to receive(:import).with(
        Array, [
          include(siren: expected_sirens[0]),
          include(siren: expected_sirens[1]),
          include(siren: expected_sirens[2])
        ],
        validate: false)

      subject
    end
  end

  shared_examples 'not importing invalid CSV' do |invalid_filename:|
    let(:csv) { Rails.root.join('spec', 'fixtures', invalid_filename).to_s }

    it { is_expected.to be_failure }

    it 'logs an error' do
      expect(logger).to receive(:error).with(/Import failed, ArgumentError: Hash key mismatch/)
      subject
    end
  end

  context 'with etablissements' do
    let(:model) { Etablissement }
    let(:csv) { Rails.root.join('spec', 'fixtures', 'sample_etablissements_OK.csv').to_s }
    let(:expected_siret) { '00588003400011' }
    let(:expected_sirens) { ['005880034', '006003560', '006004659'] }

    it_behaves_like 'importing a valid CSV'

    specify 'data is correct' do
      subject
      expect(Etablissement.find_by siret: '00588003400011').to be
    end

    it_behaves_like 'not importing invalid CSV', invalid_filename: 'sample_etablissements_KO.csv'
  end

  context 'with unites legales' do
    let(:model) { UniteLegale }
    let(:csv) { Rails.root.join('spec', 'fixtures', 'sample_unites_legales_OK.csv').to_s }
    let(:expected_sirens) { ['000325175', '001807254', '005410220'] }

    it_behaves_like 'importing a valid CSV'
    it_behaves_like 'not importing invalid CSV', invalid_filename: 'sample_unites_legales_KO.csv'
  end

  describe 'when csv is not found' do
    let(:model) { Stock } # any model, it fails before import
    let(:csv) { Rails.root.join('spec', 'fixtures', 'cant_find_this').to_s }

    it { is_expected.to be_failure }

    it 'logs an error' do
      expect(logger).to receive(:error).with(/File not found.+/)
      subject
    end
  end
end

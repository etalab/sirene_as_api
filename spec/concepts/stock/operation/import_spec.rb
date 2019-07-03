require 'rails_helper'

describe Stock::Operation::Import do
  include_context 'mute progress bar'

  shared_examples 'importing csv' do
    subject { described_class.call stock: stock, logger: logger }

    let(:logger) { instance_spy Logger }

    before do
      # mock nested operation to return
      # the fixture file as the downloaded file
      allow_any_instance_of(Files::Operation::Download)
        .to receive(:download_file)
        .and_wrap_original do |method, ctx, **|
        ctx[:file_path] = mocked_downloaded_file
      end
    end

    describe '#success' do
      it { is_expected.to be_success }

      it 'persists 3 UniteLegale' do
        expect { subject }.to change(model, :count).by 3
      end

      it 'deletes tmp file' do
        expect(expected_tmp_file).not_to exist
      end
    end

    describe 'when Extract fails' do
      before do
        # trick to make a nested operation to fail
        allow_any_instance_of(Stock::Task::ImportCSV)
          .to receive(:file_exists?)
          .and_return false
      end

      it { is_expected.to be_failure }

      it 'does not persist anything' do
        expect { subject }.not_to change(model, :count)
      end

      it 'deletes tmp file' do
        expect(expected_tmp_file).not_to exist
      end
    end
  end

  let(:uri) { 'http://random.lol' }

  context 'importing UniteLegale' do
    let(:stock) { create :stock_unite_legale, uri: uri }
    let(:model) { UniteLegale }

    let(:expected_tmp_file) do
      Rails.root.join 'tmp', 'files', 'sample_unites_legales_OK.csv'
    end

    let(:mocked_downloaded_file) do
      Rails.root.join('spec', 'fixtures', 'sample_unites_legales.csv.zip').to_s
    end

    it_behaves_like 'importing csv'
  end

  context 'importing Etablissement' do
    let(:stock) { create :stock_etablissement, uri: uri }
    let(:model) { Etablissement }

    let(:expected_tmp_file) do
      Rails.root.join 'tmp', 'files', 'sample_etablissements_OK.csv'
    end

    let(:mocked_downloaded_file) do
      Rails.root.join('spec', 'fixtures', 'sample_etablissements.csv.gz').to_s
    end

    it_behaves_like 'importing csv'
  end
end

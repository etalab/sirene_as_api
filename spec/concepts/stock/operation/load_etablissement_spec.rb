require 'rails_helper'

describe Stock::Operation::LoadEtablissement, vcr: { cassette_name: 'data_gouv_geo_sirene_may_OK' } do
  subject { described_class.call logger: logger }

  let(:logger) { instance_spy Logger }
  let(:expected_uri) do
    'https://files.data.gouv.fr/geo-sirene/2020-07/StockEtablissement_utf8_geo.csv.gz'
  end

  context 'when remote stock is importable (newer)' do
    before { create :stock_etablissement, :completed, month: '04' }

    it { is_expected.to be_success }

    it 'logs import will start' do
      subject
      expect(logger)
        .to have_received(:info)
        .with('New stock found 07, will import...')
    end

    it 'shedule a new ImportStockJob' do
      expect { subject }
        .to have_enqueued_job(ImportStockJob)
        .on_queue('sirene_api_test_stock')
    end

    it 'persist a new stock to import' do
      expect { subject }.to change(StockEtablissement, :count).by(1)
    end

    its([:remote_stock]) { is_expected.to be_persisted }
    its([:remote_stock]) do
      is_expected.to have_attributes(uri: expected_uri, status: 'PENDING', month: '07', year: '2020')
    end
  end

  context 'when remote stock is not importable (current stock stuck)' do
    before { create :stock_etablissement, :loading, month: '07', year: '2020' }

    it { is_expected.to be_failure }

    it 'logs an error' do
      subject
      expect(logger)
        .to have_received(:error)
        .with('Current stock is still importing (LOADING)')
    end

    its([:remote_stock]) { is_expected.not_to be_persisted }

    it 'does not enqueue job' do
      expect { subject }
        .not_to have_enqueued_job ImportStockJob
    end
  end

  describe 'Integration: from download to import', :perform_enqueued_jobs do
    let(:stock_model) { StockEtablissement }
    let(:imported_year) { '2020' }
    let(:imported_month) { '07' }
    let(:expected_sirens) { %w[005880034 006003560 006004659] }

    let(:expected_tmp_file) do
      Rails.root.join 'tmp', 'files', 'sample_etablissements.csv'
    end

    let(:downloaded_fixture_file) do
      Rails.root.join('spec', 'fixtures', 'sample_etablissements.csv.gz').to_s
    end

    it_behaves_like 'importing csv'
  end
end

require 'rails_helper'

describe Stock::Task::FetchLatestRemoteStockEtablissement do
  subject { described_class.call logger: logger }

  let(:logger) { instance_spy Logger }

  describe 'valid HTTP interaction', vcr: { cassette_name: 'data_gouv_geo_sirene_may_OK' } do
    let(:latest_remote_stock_file) do
      'https://files.data.gouv.fr/geo-sirene/2020-07/StockEtablissement_utf8_geo.csv.gz'
    end

    it { is_expected.to be_success }

    its([:remote_stock]) { is_expected.to be_a StockEtablissement }

    it 'returns a stock form the uri' do
      expect(subject[:remote_stock]).to have_attributes(
        year: '2020',
        month: '07',
        status: 'PENDING',
        uri: latest_remote_stock_file
      )
    end
  end

  context 'when HTTP interaction fails', vcr: { cassette_name: 'data_gouv_geo_sirene_may_KO' } do
    before do
      allow_any_instance_of(described_class)
        .to receive(:base_uri)
        .and_return('http://example.com')
    end

    it { is_expected.to be_failure }

    its([:remote_stock]) { is_expected.to be_nil }

    it 'logs an error' do
      expect(logger).to receive(:error).with('Error while retrieving remote links: 404 Not Found')
      subject
    end
  end
end

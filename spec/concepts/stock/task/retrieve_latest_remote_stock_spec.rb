require 'rails_helper'

describe Stock::Task::RetrieveLatestRemoteStock do
  subject { described_class.call logger: logger }

  let(:logger) { instance_double(Logger).as_null_object }

  describe 'valid HTTP interaction', vcr: { cassette_name: 'geo_sirene_v3_may_OK' } do
    let(:latest_remote_stock_file) { 'http://data.cquest.org/geo_sirene/v2019/2019-05/StockEtablissement_utf8_geo.csv.gz' }

    it { is_expected.to be_success }

    its([:remote_stock]) { is_expected.to be_a Stock }

    it 'returns a stock form the uri' do
      expect(subject[:remote_stock]).to have_attributes(
        year: '2019',
        month: '05',
        status: 'PENDING',
        uri: latest_remote_stock_file
      )
    end
  end

  context 'when HTTP interaction fails', vcr: { cassette_name: 'geo_sirene_v3_may_KO' } do
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

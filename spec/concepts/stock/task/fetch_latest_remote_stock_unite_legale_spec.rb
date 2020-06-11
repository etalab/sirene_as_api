require 'rails_helper'

describe Stock::Task::FetchLatestRemoteStockUniteLegale do
  subject { described_class.call logger: logger }

  let(:logger) { instance_spy Logger }

  before { Timecop.freeze(Time.zone.local(2019, 7, 15)) }

  describe 'valid HTTP interaction', vcr: { cassette_name: 'data_gouv_sirene_july_OK' } do
    let(:latest_remote_stock_file) { 'https://files.data.gouv.fr/insee-sirene/StockUniteLegale_utf8.zip' }

    it { is_expected.to be_success }

    its([:remote_stock]) { is_expected.to be_a StockUniteLegale }

    it 'returns a stock form the uri' do
      expect(subject[:remote_stock]).to have_attributes(
        year: '2019',
        month: '07',
        status: 'PENDING',
        uri: latest_remote_stock_file
      )
    end
  end

  context 'when HTTP interaction fails', vcr: { cassette_name: 'data_gouv_sirene_july_KO' } do
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

require 'rails_helper'

describe GetLastMonthlyStockLink do
  subject(:context) { described_class.call}

  context 'when file server is down', vcr: { cassette_name: 'geo-sirene_server_KO' } do
    it 'fails' do
      expect(context).to be_a_failure
    end
  end

  # HOTFIX july 19: API was changed to always return march (03) file. cassette_name changed from geo-sirene_march
  # to geo-sirene_post_july
  context 'when in march', vcr: { cassette_name: 'geo-sirene_post_july' } do
    it 'retrieves february stock link' do
      allow(Time).to receive(:now) { Time.new(2018, 3, 31) }

      # last_montly_link = 'http://data.cquest.org/geo_sirene/2018-02/geo_sirene.csv.gz'
      last_montly_link = 'http://data.cquest.org/geo_sirene/2019-03/geo_sirene.csv.gz'
      expect(described_class.call.link).to eq(last_montly_link)
    end
  end

  # context 'when in march but link is not available', vcr: { cassette_name: 'geo-sirene_march_link_not_available' } do
  #   it 'fails' do
  #     allow(Time).to receive(:now) { Time.new(2018, 3, 31) }

  #     expect(context).to be_a_failure
  #   end
  # end

  # context 'When on the 1st of april and no stock link yet', vcr: { cassette_name: 'geo-sirene_1_april_no_stock_yet' } do
  #   it 'retrieves february stock link' do
  #     allow(Time).to receive(:now) { Time.new(2018, 4, 1) }

  #     last_montly_link = 'http://data.cquest.org/geo_sirene/2018-02/geo_sirene.csv.gz'
  #     expect(described_class.call.link).to eq(last_montly_link)
  #   end
  # end

  # context 'when in january', vcr: { cassette_name: 'geo-sirene_january_2018' } do
  #   it 'retrieves the monthly stock from december the previous year' do
  #     allow(Time).to receive(:now) { Time.new(2018, 1, 5) }

  #     last_montly_link = 'http://data.cquest.org/geo_sirene/2017-12/geo_sirene.csv.gz'
  #     expect(described_class.call.link).to eq(last_montly_link)
  #   end
  # end
end

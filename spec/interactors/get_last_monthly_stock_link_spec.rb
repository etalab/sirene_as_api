require 'rails_helper'

describe GetLastMonthlyStockLink do
  context 'when in march', vcr: { cassette_name: 'sirene_file_index_20170330' } do
    it 'retrieves february stock link' do
      allow(Time).to receive(:now) { Time.new(2017, 3, 31) }

      last_montly_link = 'http://files.data.gouv.fr/sirene/sirene_201702_L_M.zip'
      expect(described_class.call.link).to eq(last_montly_link)
    end
  end
end

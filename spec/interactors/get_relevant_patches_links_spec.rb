require 'rails_helper'

describe GetRelevantPatchesLinks do
  context 'when in march & there are LESS than 5 patches since last monthly update,',
    vcr: { cassette_name: 'geo-sirene_file_index_4_links_since_LM' } do

    let!(:etablissement) { create(:etablissement, date_mise_a_jour: '2017-03-02T10:55:43') }

    it 'retrieves the right number of patches' do
      allow(File).to receive(:read) { 'http://data.cquest.org/geo_sirene/2017-02/geo-sirene.csv.gz' }
      allow(Time).to receive(:now) { Time.new(2017, 3, 5) }

      right_number_of_patches = 4
      expect(described_class.call.links.size).to eq(right_number_of_patches)
    end
  end

  context 'when in march & there are MORE than 5 patches since last monthly update
    & there are LESS than 5 patches since last update,',
    vcr: { cassette_name: 'geo-sirene_file_index_20170330_22_links_since_LM' } do

    let!(:etablissement) { create(:etablissement, date_mise_a_jour: '2017-03-28T10:55:43') }

    it 'retrieves 5 patches' do
      allow(File).to receive(:read) { 'http://data.cquest.org/geo_sirene/2017-02/geo-sirene.csv.gz' }
      allow(Time).to receive(:now) { Time.new(2017, 3, 31) }

      right_number_of_patches = 5
      expect(described_class.call.links.size).to eq(right_number_of_patches)
    end
  end

  context 'when in march & there are MORE than 5 patches since last monthly update
    & MORE than 5 since last daily update,',
    vcr: { cassette_name: 'geo-sirene_file_index_20170330_22_links_since_LM' } do

    let!(:etablissement) { create(:etablissement, date_mise_a_jour: '2017-03-15T10:55:43') }

    it 'retrieves the right number of patches' do
      allow(File).to receive(:read) { 'http://data.cquest.org/geo_sirene/2017-02/geo-sirene.csv.gz' }
      allow(Time).to receive(:now) { Time.new(2017, 3, 31) }

      right_number_of_patches = 12
      expect(described_class.call.links.size).to eq(right_number_of_patches)
    end
  end

  context 'when rebuilding database in the middle of month', vcr: { cassette_name: 'geo-sirene_20181215' } do
    let!(:etablissement) { create :etablissement, date_mise_a_jour: '2018-11-30T20:02:32' }

    it 'retrieves all the patches since the begining of the month' do
      allow(File).to receive(:read) { 'http://data.cquest.org/geo_sirene/2018-11/geo_sirene.csv.gz' }
      Timecop.freeze Time.new(2018, 12, 15)

      right_number_of_patches = 10
      expect(described_class.call(rebuilding_database: true).links.size).to eq right_number_of_patches
    end
  end

  context 'when in january and it is the first patches of the new year',
    vcr: { cassette_name: 'geo-sirene_file_index_20190102' } do

    let!(:etablissement) { create :etablissement, date_mise_a_jour: '2018-12-31T20:02:32' }

    it 'retrieves only one patch' do
      allow(File).to receive(:read) { 'http://data.cquest.org/geo_sirene/2018-12/geo_sirene.csv.gz' }
      Timecop.freeze Time.new(2019, 1, 2)

      right_number_of_patches = 1
      expect(described_class.call.links.size).to eq right_number_of_patches
    end
  end
end

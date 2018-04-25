require 'rails_helper'

describe GetRelevantPatchesLinks do
  context 'when in march & there are LESS than 5 patches since last monthly update,',
    vcr: { cassette_name: 'geo-sirene_file_index_3_links_since_LM', allow_playback_repeats: true } do

    let!(:etablissement) { create(:etablissement, date_mise_a_jour: '2017-03-01T10:55:43') }

    it 'retrieves the right number of patches' do
      allow(File).to receive(:read) { 'http://data.cquest.org/geo_sirene/2018-02/geo-sirene.csv.gz' }
      allow(Time).to receive(:now) { Time.new(2017, 3, 5) }

      right_number_of_patches = 3
      expect(described_class.call.links.size).to eq(right_number_of_patches)
    end
  end

  context 'when in march & there are MORE than 5 patches since last monthly update
    & there are LESS than 5 patches since last update,',
    vcr: { cassette_name: 'geo-sirene_file_index_20170330_22_links_since_LM', allow_playback_repeats: true } do

    let!(:etablissement) { create(:etablissement, date_mise_a_jour: '2017-03-26T10:55:43') }

    it 'retrieves 5 patches' do
      allow(File).to receive(:read) { 'http://data.cquest.org/geo_sirene/2018-02/geo-sirene.csv.gz' }
      allow(Time).to receive(:now) { Time.new(2017, 3, 31) }

      right_number_of_patches = 5
      expect(described_class.call.links.size).to eq(right_number_of_patches)
    end
  end

  context 'when in march & there are MORE than 5 patches since last monthly update
    & MORE than 5 since last daily update,',
    vcr: {  cassette_name: 'geo-sirene_file_index_20170330_22_links_since_LM', allow_playback_repeats: true } do

    let!(:etablissement) { create(:etablissement, date_mise_a_jour: '2017-03-15T10:55:43') }

    it 'retrieves the right number of patches' do
      allow(File).to receive(:read) { 'http://data.cquest.org/geo_sirene/2018-02/geo-sirene.csv.gz' }
      allow(Time).to receive(:now) { Time.new(2017, 3, 31) }

      right_number_of_patches = 12
      expect(described_class.call.links.size).to eq(right_number_of_patches)
    end
  end
end

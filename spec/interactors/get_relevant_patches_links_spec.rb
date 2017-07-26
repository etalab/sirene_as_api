require 'rails_helper'

describe GetRelevantPatchesLinks do
  context 'when in march & there are MORE than 5 patches', vcr: {  cassette_name: 'sirene_file_index_20170330', allow_playback_repeats: true } do
    let!(:etablissement) { create(:etablissement, date_mise_a_jour: '2017-03-20T10:55:43') }

    it 'retrieves the right number of patches' do
      right_number_of_patches = 7
      expect(described_class.call.links.size).to eq(right_number_of_patches)
    end
  end

  context 'when in march & there are LESS than 5 patches', vcr: {  cassette_name: 'sirene_file_index_20170330', allow_playback_repeats: true } do
    let!(:etablissement) { create(:etablissement, date_mise_a_jour: '2017-03-27T10:55:43') }

    it 'retrieves at least 5 patches' do
      right_number_of_patches = 5
      expect(described_class.call.links.size).to eq(right_number_of_patches)
    end
  end
end

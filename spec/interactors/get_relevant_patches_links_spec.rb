require 'rails_helper'

describe GetRelevantPatchesLinks do
  context 'when in march & there are MORE than 5 patches', :vcr => { cassette_name: 'sirene_file_index_20170330' } do
    it 'retrieves the right number of patches' do
      right_number_of_patches = 23
      Etablissement = double("Etablissement", :latest_mise_a_jour => "2017-02-24T13:21:13")
      expect(described_class.call.links.size).to eq(right_number_of_patches)
    end
    it 'applies all patches'
  end

  context 'when in march & there are LESS than 5 patches', :vcr => { cassette_name: 'sirene_file_index_20170330' } do
    it 'retrieves the right number of patches' do
      right_number_of_patches = 2
      Etablissement = double("Etablissement", :latest_mise_a_jour => "2017-03-27T10:55:43")
      expect(described_class.call.links.size).to eq(right_number_of_patches)
    end
  end
end

require 'rails_helper'

describe GetLastMonthlyStockLink do
  context 'when in march', :vcr => { cassette_name: 'sirene_file_index_20170330' } do
    it 'retrieves february stock link' do
      last_montly_link = 'http://files.data.gouv.fr/sirene/sirene_201702_L_M.zip'
      expect(described_class.call.link).to eq(last_montly_link)
    end
  end
end

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
      @patch_links = described_class.call.links
      expect(described_class.call.links.size).to eq(right_number_of_patches)
    end

    it 'rollbacks last 5 patches' do
      # puts "Links to patches : #{@patch_links}"

    end

    it 'applies last 5 patches'
  end
end

describe ApplyPatches do
end

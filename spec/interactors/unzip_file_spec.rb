require 'rails_helper'

describe UnzipFile do
  subject(:context) { UnzipFile.call(filepath: 'spec/fixtures/sample_patches/geo-sirene_2017024_E_Q.csv.gz') }

  context 'when called & The file is already there' do
    before do
      File.new('tmp/files/geo-sirene_2017024_E_Q.csv', 'w+')
    end

    it 'pass the adress in context' do
      expect(context.unzipped_files).to eq(['tmp/files/geo-sirene_2017024_E_Q.csv'])
    end
    it 'doesnt write to a new file' do
      expect(File).not_to receive(:new)
      UnzipFile.call(filepath: 'spec/fixtures/sample_patches/geo-sirene_2017024_E_Q.csv.gz')
    end
  end

  context 'when called & The file is not already there' do
    before do
      File.delete('tmp/files/geo-sirene_2017024_E_Q.csv')
    end
    
    it 'pass the adress in context' do
      expect(context.unzipped_files).to eq(['tmp/files/geo-sirene_2017024_E_Q.csv'])
    end
    it 'create a new file' do
      allow(File).to receive(:new).and_return(File.new('spec/fixtures/sample_patches/test_file.csv', 'w+'))
      expect(File).to receive(:new)
      UnzipFile.call(filepath: 'spec/fixtures/sample_patches/geo-sirene_2017024_E_Q.csv.gz')
    end
  end
end

require 'rails_helper'
require 'spec_helper'

describe UnzipFile do
  patch_filepath = 'spec/fixtures/sample_patches/geo-sirene_2017024_E_Q.csv.gz'
  patch_filename = 'geo-sirene_2017024_E_Q_2017_02.csv'
  expected_unzipped_file_path = "tmp/files/#{patch_filename}"

  subject(:context) { UnzipFile.call(filepath: patch_filepath, filename: patch_filename) }

  context 'when called & The file is already there' do
    before do
      File.new(expected_unzipped_file_path, 'w')
    end
    
    it 'pass the adress in context' do
      expect(context.unzipped_files).to eq(["tmp/files/#{patch_filename}"])
    end
    it 'doesnt write to a new file' do
      expect(File).not_to receive(:open)
      expect(IO).not_to receive(:copy_stream)
      UnzipFile.call(filepath: patch_filepath, filename: patch_filename)
    end
  end

  context 'when called & The file is not already there' do
    before do
      File.delete(expected_unzipped_file_path) if File.exist?(expected_unzipped_file_path)
    end
    
    it 'pass the adress in context' do
      expect(context.unzipped_files).to eq([expected_unzipped_file_path])
    end
    it 'create a new file and write inside' do
      expect(IO).to receive(:copy_stream)
      UnzipFile.call(filepath: patch_filepath, filename: patch_filename)
      expect(File.exist?(expected_unzipped_file_path)).to be_truthy
    end
  end
end

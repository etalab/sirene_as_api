require 'rails_helper'

describe UnzipFile do
  include_context 'mute interactors'

  let(:patch_filename) { 'geo-sirene_2017024_E_Q.csv' }
  let(:patch_filepath) { "spec/fixtures/sample_patches/#{patch_filename}.gz" }
  let(:expected_unzipped_file_path) { "spec/fixtures/sample_patches/#{patch_filename}" }

  subject(:context) { described_class.call filepath: patch_filepath }

  after do
    File.delete(expected_unzipped_file_path) if File.exist?(expected_unzipped_file_path)
  end

  context 'when called & The file is already there' do
    before { File.new(expected_unzipped_file_path, 'w') }

    it 'pass the adress in context' do
      expect(context.unzipped_files).to eq([expected_unzipped_file_path])
    end

    it 'doesnt unzip the file' do
      expect(Open3).not_to receive(:capture3)
      expect_any_instance_of(described_class).to receive(:stdout_warn_log).with(/Skipping unzip of file/)
      context
    end
  end

  context 'when called & The file is not already there' do
    before do
      File.delete(expected_unzipped_file_path) if File.exist?(expected_unzipped_file_path)
    end

    it 'passes the adress in context' do
      expect(context.unzipped_files).to eq([expected_unzipped_file_path])
    end

    it 'unzip the file' do
      expect(Open3).to receive(:capture3).and_call_original
      context
      expect(File).to exist(expected_unzipped_file_path)
    end

    context 'when gunzip fails' do
      let(:patch_filepath) { 'tmp/fake_gzip.csv.gz' }

      before { File.new(patch_filepath, 'w') }

      it 'does not pass the adress in context' do
        expect(context.unzipped_files).to be_empty
      end

      it 'does not write to a new file' do
        context
        expect(File).not_to exist('tmp/fake_gzip.csv')
      end

      it 'logs an error' do
        expect_any_instance_of(described_class).to receive(:stdout_error_log).with(/Failed to unzip file \(error:/)
        context
      end
    end
  end
end

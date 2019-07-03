require 'rails_helper'

describe Files::Operation::Extract do
  subject { described_class.call file_path: compressed_file }

  let(:expected_unzipped_file) { Rails.root.join('tmp', 'files', 'example.csv').to_s }

  after { FileUtils.rm_rf(expected_unzipped_file) } # clean extracted file

  shared_examples 'extracting file' do
      it 'is successful' do
        expect(subject).to be_success
      end

      it 'extracts into a file named from the zip' do
        subject
        expect(File.file?(expected_unzipped_file)).to eq(true)
      end

      it 'returns the extracted file path' do
        expect(subject[:extracted_file]).to eq(expected_unzipped_file)
      end
    end

  describe 'gz file' do
    let(:compressed_file) { Rails.root.join('spec', 'fixtures', 'example.csv.gz').to_s }

    it_behaves_like 'extracting file'
  end

  describe 'zip file' do
    let(:compressed_file) { Rails.root.join('spec', 'fixtures', 'example.csv.zip').to_s }

    it_behaves_like 'extracting file'
  end

  context 'when file is not found' do
    let(:compressed_file) { Rails.root.join('tmp', 'files', 'you_will_never_find_me.gz').to_s }

    it { is_expected.to be_failure }

    its([:error]) { is_expected.to match /gzip: .+you_will_never_find_me.gz: No such file or directory/ }
  end
end

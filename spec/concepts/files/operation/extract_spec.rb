require 'rails_helper'

describe Files::Operation::Extract do
  # Archive manually created for tests.
  let(:gzip_file) { Rails.root.join('spec', 'concepts', 'files', 'example.csv.gz').to_s }
  let(:unzipped_file) { Rails.root.join('tmp', 'files', 'example.csv').to_s }

  subject { described_class.call(path: gzip_file) }

  after { FileUtils.rm_rf(unzipped_file) } # clean extracted file

  it 'is successful' do
    expect(subject).to be_success
  end

  it 'extracts into a file named from the zip' do
    subject
    expect(File.file?(unzipped_file)).to eq(true)
  end

  it 'returns the extracted file path' do
    expect(subject[:unzipped_file]).to eq(unzipped_file)
  end

  context 'when file is not found' do
    let(:gzip_file) { Rails.root.join('tmp', 'files', 'you_will_never_find_me.gz').to_s }

    it { is_expected.to be_failure }

    its([:error]) { is_expected.to match /gzip: .+you_will_never_find_me.gz: No such file or directory/ }
  end
end

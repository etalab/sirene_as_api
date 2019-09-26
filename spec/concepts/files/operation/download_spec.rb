require 'rails_helper'

describe Files::Operation::Download do
  subject { described_class.call uri: uri, logger: logger }

  let(:logger) { instance_spy Logger }

  context 'downloads success', vcr: { cassette_name: 'download_success' } do
    after do
      File.delete local_file_path
    end

    let(:url) { 'http://www.ovh.net/files/' }
    let(:filename) { '1Mb.dat' }
    let(:uri) { url + filename }
    let(:local_file_path) { Rails.root.join 'tmp', 'files', filename }

    it { is_expected.to be_success }

    its([:file_path]) { is_expected.to eq local_file_path.to_s }

    it 'downloads the file on disk' do
      expect(File.exist?(subject[:file_path])).to be_truthy
    end
  end

  context 'when download fails', vcr: { cassette_name: 'download_failed' } do
    let(:uri) { 'https://entreprise.api.gouv.fr/not_found.lol' }

    it { is_expected.to be_failure }

    it 'logs an error' do
      expect(logger).to receive(:error).with('Download failed: 404 Not Found')
      subject
    end
  end
end

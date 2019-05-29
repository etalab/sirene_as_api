require 'rails_helper'

describe Files::Operation::Download, real_tcp_requests: true do
  subject { described_class.call uri: uri, logger: logger }

  let(:logger) { instance_double(Logger).as_null_object }

  context 'downloads success' do

    after do
      File.delete Rails.root.join 'tmp', 'files', filename
    end

    let(:url) { 'http://www.ovh.net/files/' }
    let(:filename) { '1Mb.dat' }
    let(:uri) { url + filename }
    let(:local_file_path) { Rails.root.join 'tmp', 'files', filename }

    it { is_expected.to be_success }

    its([:file_path]) { is_expected.to eq local_file_path.to_s }

    it 'downloads the file on disk' do
      expect(File.exists?(subject[:file_path])).to be_truthy
    end
  end

  context 'when download fails' do
    let(:uri) { 'https://entreprise.api.gouv.fr/not_found.lol' }

    it { is_expected.to be_failure }

    it 'logs an error' do
      expect(logger).to receive(:error).with("Download failed: curl: (22) The requested URL returned error: 404 Not Found\n")
      subject
    end
  end
end

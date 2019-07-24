require 'rails_helper'
require 'open-uri'

describe DownloadFile do
  context 'When downloading file' do
    before(:all) do
      Timecop.freeze(Time.utc(2018, 9, 1, 10, 5, 0))
    end

    after(:all) do
      Timecop.return
    end

    let(:link) { 'http://data.gouv.fr/dummy-test.csv.gz' }
    it 'succeed' do
      allow_any_instance_of(described_class).to receive(:open).with(link).and_return('dummy_download')
      # Edit HOTFIX july 19: API is changed to always request march (03) download
      # expect(IO).to receive(:copy_stream).with('dummy_download', './tmp/files/dummy-test_2018_08.csv.gz')
      expect(IO).to receive(:copy_stream).with('dummy_download', './tmp/files/dummy-test_2018_03.csv.gz')

      described_class.call(link: link)
    end
  end
end

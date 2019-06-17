require 'rails_helper'

describe Stock::Task::UpdateIndexes do
  let(:logger) { instance_double(Logger).as_null_object }
  subject { described_class.call logger: logger }

  describe 'when solr is on' do
    pending('need to add unite_legales before testing this')

    it { is_expected.to be_success }

    it 'builds the fulltext index'
    it 'builds the suggester dictionary'
  end

  describe 'when solr is off' do
    before { allow_any_instance_of(Net::Ping::HTTP).to receive(:ping?).and_return(false) }

    it { is_expected.to be_failure }
    it 'logs an error' do
      expect(logger).to receive(:error).with('Error : solr unreacheable. Make sure it is active and accessible.')
      subject
    end
  end
end

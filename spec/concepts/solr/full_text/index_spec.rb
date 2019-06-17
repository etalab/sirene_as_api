require 'rails_helper'

describe Solr::FullText::Index do
  describe 'when building full-text index' do
    pending('need to add unite_legales before testing this')
    let(:logger) { instance_double(Logger).as_null_object }

    subject { described_class.call logger: logger }
    it { is_expected.to be_success }
  end
end

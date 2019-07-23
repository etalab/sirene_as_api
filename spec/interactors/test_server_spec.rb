require 'rails_helper'

describe TestSelfServer do
  include_context 'mute interactors'

  context 'when a success' do
    subject(:context) { described_class.call }
    it 'succeed the context' do
      allow_any_instance_of(described_class).to receive(:execute_test).and_return(
        '{"total_results":62703,"total_pages":6271,"per_page":10,"page":1,"etablissement":[{}]}'
      )
      expect(context).to be_a_success
    end
  end
  context 'when database not full' do
    subject(:context) { described_class.call }
    it 'fails the context' do
      allow_any_instance_of(described_class).to receive(:execute_test).and_return(
        '{"total_results":30703,"total_pages":6271,"per_page":10,"page":1,"etablissement":[{}]}'
      )
      expect(context).to be_a_failure
    end
  end
  context 'when test returns nil' do
    subject(:context) { described_class.call }
    it 'fails the context' do
      allow_any_instance_of(described_class).to receive(:execute_test).and_return(nil)
      expect(context).to be_a_failure
    end
  end
  context 'when test returns an error' do
    subject(:context) { described_class.call }
    it 'fails the context' do
      allow_any_instance_of(described_class).to receive(:execute_test).and_raise('not working')
      expect(context).to be_a_failure
    end
  end
end

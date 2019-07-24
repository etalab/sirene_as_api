require 'rails_helper'
require 'net/http'

describe CheckCurrentService do
  context 'When this machine is in service',
          vcr: { cassette_name: 'OvhAPI_check_current_service' } do
    subject(:context) { described_class.call }
    it 'fails the context' do
      allow_any_instance_of(described_class).to receive(:current_machine_name).and_return('address1')
      allow_any_instance_of(OvhAPI).to receive(:signature).and_return('dummy-sign')

      described_class.call
      expect(context).to be_a_failure
    end
  end

  context 'When this machine is not in service',
          vcr: { cassette_name: 'OvhAPI_check_current_service' } do
    subject(:context) { described_class.call }
    it 'succeed the context' do
      allow_any_instance_of(described_class).to receive(:current_machine_name).and_return('address2')
      allow_any_instance_of(OvhAPI).to receive(:signature).and_return('dummy-sign')

      described_class.call
      expect(context).to be_a_success
    end
  end
end

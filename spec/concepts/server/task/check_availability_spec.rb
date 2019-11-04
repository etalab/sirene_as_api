require 'rails_helper'

# Test config in /config/switch_server.yml
describe Server::Task::CheckAvailability, vcr: { cassette_name: 'OvhAPI_check_current_service_OK' } do
  include_context 'stubbed OVH constants'

  subject { described_class.call logger: logger }
  let(:logger) { instance_spy Logger }

  it 'Calls OVH query' do
    expect_any_instance_of(OvhRequest).to receive(:send_request)
    subject
  end

  it 'Sends the right params' do
    expect(OvhRequest).to receive(:new).with('GET', '/ip/01.01.01.01/').and_call_original
    subject
  end

  describe 'OVH query success' do
    context 'Current machine in use' do
      before do
        allow_any_instance_of(described_class)
          .to receive(:current_machine_name)
          .and_return 'address1'
      end

      it { is_expected.to be_failure }

      it 'logs the failure' do
        expect(logger).to receive(:warn).with 'Current machine in use, not available for update.'
        subject
      end
    end
    context 'Sibling machine in use' do
      before do
        allow_any_instance_of(described_class)
          .to receive(:current_machine_name)
          .and_return 'address2'
      end

      it { is_expected.to be_success }

      it 'logs the success' do
        expect(logger).to receive(:info).with 'Current machine not in use, available for update.'
        subject
      end
    end
  end

  describe 'OVH query failure', vcr: { cassette_name: 'OvhAPI_check_current_service_KO' } do
    it 'logs an error' do
      expect(logger).to receive(:error).with "Request to host API failed, can't fetch current service"
      subject
    end
  end
end

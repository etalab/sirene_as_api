require 'rails_helper'

describe Server::Operation::AuthorizeImport, :trb do
  let(:logger) { instance_spy Logger }

  context 'Safe mode off' do
    subject { described_class.call logger: logger, options: { safe: false } }

    it { is_expected.to be_success }
  end

  context 'Safe mode on' do
    # Those tests also test Nested(Task::CheckAvailability) & OvhRequest
    # It would be better to stub trailblazer's Nested and return OK or KO
    # Impossible at this moment, so we stub the OVH request

    include_context 'stubbed OVH constants'
    subject { described_class.call logger: logger, options: { safe: true } }

    before(:each) do
      allow_any_instance_of(Server::Task::CheckAvailability)
        .to receive(:current_machine_name)
        .and_return 'address2'
    end

    context 'Server available', vcr: { cassette_name: 'OvhAPI_check_current_service_OK' } do
      it { is_expected.to be_success }
    end

    context 'Server unavailable', vcr: { cassette_name: 'OvhAPI_check_current_service_KO' } do
      it { is_expected.to be_failure }
    end
  end
end

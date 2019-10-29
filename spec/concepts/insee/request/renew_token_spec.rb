require 'rails_helper'

describe INSEE::Request::RenewToken, vcr: { cassette_name: 'insee/renew_token' } do
  subject { described_class.call(logger: logger) }

  let(:logger) { instance_spy Logger }

  before { Timecop.freeze }

  context 'when INSEE is UP' do
    its(:success?) { is_expected.to be_truthy }
    its([:token]) { is_expected.to eq 'ab380ad7-5725-33d6-9d57-18a40e209021' }
    its([:expires_in]) { is_expected.to eq 603_438 }
    its([:expiration_date]) { is_expected.to eq(Time.zone.now.to_i + 603_438) }
  end

  context 'when INSEE is DOWN' do
    before { allow_any_instance_of(Net::HTTPOK).to receive(:code).and_return('500') }

    its(:success?) { is_expected.to be_falsey }

    it 'logs an error' do
      subject
      expect(logger).to have_received(:error).with(/Failed to renew INSEE token/)
    end
  end
end

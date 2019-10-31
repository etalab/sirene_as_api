require 'rails_helper'

describe INSEE::Operation::RenewToken do
  subject { described_class.call(logger: logger) }

  let(:logger) { instance_spy Logger }
  let(:mocked_token) { 'this a token' }
  let(:expected_token) { 'ab380ad7-5725-33d6-9d57-18a40e209021' }
  let(:expected_timestamp) { Time.zone.now.to_i + 603_438 }
  let(:file_path) { Rails.root.join('config', 'insee_secrets.yml') }

  before { Timecop.freeze }

  context 'when token file is found' do
    before { create_token(mocked_expiration_timestamp) }
    after { File.delete(file_path) }

    context 'when token is not expired' do
      let(:mocked_expiration_timestamp) { 1.day.since.to_i }

      its(:success?) { is_expected.to eq(true) }
      its([:token]) { is_expected.to eq mocked_token }
      its([:expiration_date]) { is_expected.to eq mocked_expiration_timestamp }
    end

    context 'when token is expired', vcr: { cassette_name: 'insee/renew_token' } do
      let(:mocked_expiration_timestamp) { 1.day.ago.to_i }

      its(:success?) { is_expected.to eq(true) }
      its([:token]) { is_expected.to eq expected_token }
      its([:expiration_date]) { is_expected.to eq expected_timestamp }
    end
  end

  context 'when token file is not found', vcr: { cassette_name: 'insee/renew_token' } do
    after { File.delete(file_path) }

    its(:success?) { is_expected.to eq(true) }
    its([:token]) { is_expected.to eq expected_token }
    its([:expiration_date]) { is_expected.to eq expected_timestamp }
  end

  context 'when renewing token failed', vcr: { cassette_name: 'insee/renew_token' } do
    before { allow_any_instance_of(Net::HTTPOK).to receive(:code).and_return('500') }

    its(:success?) { is_expected.to eq(false) }

    it 'logs an error' do
      subject
      expect(logger).to have_received(:error)
    end
  end

  def create_token(mocked_expiration_timestamp)
    File.open(described_class.new.send(:filename), 'w+') do |file|
      content = <<-YML
        ---
        token: #{mocked_token}
        expiration_date: #{mocked_expiration_timestamp}
      YML

      file.write(content.unindent)
    end
  end
end

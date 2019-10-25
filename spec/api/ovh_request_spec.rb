require 'rails_helper'

describe OvhRequest do
  # Easiest way to check if query is right is testing it against vcr cassette
  it 'sends the right GET query', vcr: { cassette_name: 'OvhAPI_check_current_service' } do
    stub_const('OvhRequest::AK', 'fake_application_key')
    stub_const('OvhRequest::AS', 'fake_secret_key')
    stub_const('OvhRequest::CK', 'fake_consumer_key')

    response = described_class.new('GET', '/ip/01.01.01.01/').send
    expect(response).to be_kind_of(Net::HTTPSuccess)
  end
end

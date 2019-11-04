require 'rails_helper'

describe OvhRequest do
  include_context 'stubbed OVH constants'
  # Easiest way to check if query is right is testing it against vcr cassette
  it 'sends the right GET query', vcr: { cassette_name: 'OvhAPI_check_current_service_OK' } do
    response = described_class.new('GET', '/ip/01.01.01.01/').send_request

    expect(response).to be_kind_of(Net::HTTPSuccess)
  end
end

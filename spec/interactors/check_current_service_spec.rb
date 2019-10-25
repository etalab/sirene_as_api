require 'rails_helper'
require 'ovh_request.rb'
require 'net/http'

describe CheckCurrentService do
  include_context 'mute interactors'

  let(:response){ instance_double(Net::HTTPSuccess, body: response_body)}
  let(:response_body) { {"routedTo": {"serviceName": "address1"}}.to_json }

  subject(:context) { described_class.call }

  it 'fails the context if same address' do
    allow_any_instance_of(described_class).to receive(:current_machine_name).and_return('address1')
    allow_any_instance_of(OvhAPIInteractor).to receive(:call).and_return(response)

    described_class.call
    expect(context).to be_a_failure
  end

  it 'succeed the context if other address' do
    allow_any_instance_of(described_class).to receive(:current_machine_name).and_return('address2')
    allow_any_instance_of(OvhAPIInteractor).to receive(:call).and_return(response)

    described_class.call
    expect(context).to be_a_success
  end
end

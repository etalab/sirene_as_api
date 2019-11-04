require 'ovh_request.rb'

shared_context 'stubbed OVH constants' do
  before do
    stub_const('OvhRequest::AK', 'fake_application_key')
    stub_const('OvhRequest::AS', 'fake_secret_key')
    stub_const('OvhRequest::CK', 'fake_consumer_key')
  end
end

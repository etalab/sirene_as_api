shared_context 'api v3 response' do |model, _field_1, _field_2|
  let(:record) { model.to_s }
  let(:records) { model.to_s.pluralize }

  let(:route) { "/v3/#{records}" }

  let(:results) { response.parsed_body[records] }

  let(:body_message_not_found) { { 'message' => 'no results found' } }
end

shared_context 'api v3 response' do |model, field_1, field_2|
  let!(:instance_1) { create(model, field_1 => '001', field_2 => 'Foo' ) }
  let!(:instance_2) { create(model, field_1 => '002', field_2 => 'Foo' ) }
  let!(:instance_3) { create(model, field_1 => '003', field_2 => 'Bar' ) }

  subject { response }

  let(:records) { model.to_s.pluralize }

  let(:route) { "/v3/#{records}" }

  let(:first_result)  { response.parsed_body[records][0] }
  let(:second_result) { response.parsed_body[records][1] }
  let(:third_result)  { response.parsed_body[records][2] }

  let(:number_of_results) { response.parsed_body[records].size }

  let(:body_404) { {"message"=> "no results found"} }
end

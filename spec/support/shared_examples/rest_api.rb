require 'rails_helper'

shared_examples 'a REST API' do |model, field_1, field_2|
  let!(:instance_1) { create(model, field_1 => '001', field_2 => 'Foo') }
  let!(:instance_2) { create(model, field_1 => '002', field_2 => 'Foo') }
  let!(:instance_3) { create(model, field_1 => '003', field_2 => 'Bar') }

  subject { response }

  describe '#index', type: :request do
    context 'found' do
      before(:each) { get route }

      let(:expected_format) do
        {
          records => a_collection_containing_exactly(
            a_hash_including(field_1.to_s => '001', field_2.to_s => 'Foo'),
            a_hash_including(field_1.to_s => '002', field_2.to_s => 'Foo'),
            a_hash_including(field_1.to_s => '003', field_2.to_s => 'Bar')
          ),
          'meta' => kind_of(Hash)
        }
      end

      it { is_expected.to have_http_status(:ok) }
      its(:parsed_body) { is_expected.to match(expected_format) }
    end

    context 'not found' do
      before do
        [instance_1, instance_2, instance_3].each(&:destroy)
        get route
      end

      it { is_expected.to have_http_status(:not_found) }
      its(:parsed_body) { is_expected.to eq(body_message_not_found) }
    end
  end

  describe '#show', type: :request do
    context 'found' do
      before(:each) { get "#{route}/003" }

      let(:expected_format) { { record => a_hash_including(field_1.to_s => '003') } }

      it { is_expected.to have_http_status(:ok) }
      its(:parsed_body) { is_expected.to match(expected_format) }
    end

    context 'not found' do
      before { get "#{route}/99999" }

      it { is_expected.to have_http_status(:not_found) }
      its(:parsed_body) { is_expected.to eq(body_message_not_found) }
    end
  end
end

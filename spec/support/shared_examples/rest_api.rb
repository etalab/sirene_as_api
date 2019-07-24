require 'rails_helper'

shared_examples 'a REST API' do |model, field_1, field_2|
  describe '#index', type: :request do
    context 'found' do
      before(:each) { get route }

      it 'returns the right data' do
        expect(first_result[field_2.to_s]).to eq('Foo')
        expect(third_result[field_2.to_s]).to eq('Bar')
      end
      its(:status) { is_expected.to eq(200) }
    end

    context 'not found' do
      before do
        [instance_1, instance_2, instance_3].each { |record| record.destroy }
        get route
      end

      its(:status) { is_expected.to eq(404) }
      its(:parsed_body) { is_expected.to eq(body_404) }
    end
  end

  describe '#show', type: :request do
    context 'found' do
      before(:each) { get "#{route}/003" }

      it 'returns one right result' do
        expect(first_result[field_2.to_s]).to eq('Bar')
        expect(second_result).to be_nil
      end

      its(:status) { is_expected.to eq(200) }
    end

    context 'not found' do
      before { get "#{route}/99999" }

      its(:status) { is_expected.to eq(404) }
      its(:parsed_body) { is_expected.to eq(body_404) }
    end
  end
end

shared_examples 'scopable' do |model, field_1, field_2|
  describe 'filtering', type: :request do
    let!(:instance_1) { create(model, field_1 => '001', field_2 => 'Foo') }
    let!(:instance_2) { create(model, field_1 => '002', field_2 => 'Bar') }
    let!(:instance_3) { create(model, field_1 => '003', field_2 => 'Bar') }

    let(:route) { "/v3/#{model.to_s.pluralize}" }

    it 'can filter with 1 field' do
      get "#{route}?#{field_1.to_s}=001"

      response_array = JSON.parse(response.body)

      expect(response_array.size).to eq(1)
      expect(response_array.first[field_2.to_s]).to eq('Foo')
    end

    it 'can filter with multiple fields' do
      get "#{route}?#{field_1.to_s}=001&#{field_2.to_s}=Foo"

      response_array = JSON.parse(response.body)

      expect(response_array.size).to eq(1)
      expect(response_array.first[field_2.to_s]).to eq('Foo')
    end

    it 'can filter and return multiple results' do
      get "#{route}?#{field_2.to_s}=Bar"

      response_array = JSON.parse(response.body)

      expect(response_array.size).to eq(2)
      expect(response_array.first[field_2.to_s]).to eq('Bar')
    end
  end
end

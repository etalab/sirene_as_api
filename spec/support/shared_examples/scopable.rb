shared_examples 'a scopable controller' do |model, field_1, field_2|
  let!(:instance_1) { create(model, field_1 => '001', field_2 => 'Foo') }
  let!(:instance_2) { create(model, field_1 => '002', field_2 => 'Foo') }
  let!(:instance_3) { create(model, field_1 => '003', field_2 => 'Bar') }

  subject { response }

  describe 'filtering', type: :request do
    it 'can filter with 1 field' do
      get "#{route}?#{field_1}=001"

      expect(results.size).to eq(1)
      expect(results[0][field_2.to_s]).to eq('Foo')
    end

    it 'can filter with multiple fields' do
      get "#{route}?#{field_1}=001&#{field_2}=Foo"

      expect(results.size).to eq(1)
      expect(results[0][field_2.to_s]).to eq('Foo')
    end

    it 'can filter and return multiple results' do
      get "#{route}?#{field_2}=Foo"

      expect(results.size).to eq(2)
      expect(results[0][field_2.to_s]).to eq('Foo')
      expect(results[1][field_2.to_s]).to eq('Foo')
    end
  end
end

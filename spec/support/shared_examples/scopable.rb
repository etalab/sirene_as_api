shared_examples 'a scopable controller' do |model, field_1, field_2|
  describe 'filtering', type: :request do
    it 'can filter with 1 field' do
      get "#{route}?#{field_1.to_s}=001"

      expect(number_of_results).to eq(1)
      expect(first_result[field_2.to_s]).to eq('Foo')
    end

    it 'can filter with multiple fields' do
      get "#{route}?#{field_1.to_s}=001&#{field_2.to_s}=Foo"

      expect(number_of_results).to eq(1)
      expect(first_result[field_2.to_s]).to eq('Foo')
    end

    it 'can filter and return multiple results' do
      get "#{route}?#{field_2.to_s}=Foo"

      expect(number_of_results).to eq(2)
      expect(first_result[field_2.to_s]).to eq('Foo')
      expect(second_result[field_2.to_s]).to eq('Foo')
    end
  end
end

shared_examples 'a paginable controller' do |model, field_1, field_2|
  describe 'pagination', type: :request do
    before(:each) { get "#{route}" }

    its(:parsed_body) { is_expected.to have_key('meta') }

    let(:meta) { subject.parsed_body['meta'] }
    it 'have the pagination info in meta' do
      expect(meta).to have_key('total_results')
      expect(meta).to have_key('per_page')
      expect(meta).to have_key('total_pages')
      expect(meta).to have_key('page')
    end

    it 'have correct pagination info' do
      expect(meta['total_results']).to eq(3)
      expect(meta['per_page']).to eq(3)
      expect(meta['total_pages']).to eq(1)
      expect(meta['page']).to eq(1)
    end
  end
end

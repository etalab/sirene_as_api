shared_examples 'a paginable controller' do |model, field_1, field_2|
  describe 'pagination', type: :request do
    let!(:instance_1) { create(model, field_1 => '001', field_2 => 'Foo') }
    let!(:instance_2) { create(model, field_1 => '002', field_2 => 'Foo') }
    let!(:instance_3) { create(model, field_1 => '003', field_2 => 'Bar') }

    subject { response }

    before { get route.to_s }

    let(:meta) { subject.parsed_body['meta'] }

    it 'has correct pagination info' do
      expect(meta['total_results']).to eq(3)
      expect(meta['per_page']).to eq(3)
      expect(meta['total_pages']).to eq(1)
      expect(meta['page']).to eq(1)
    end
  end
end

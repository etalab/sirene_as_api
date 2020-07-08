shared_examples 'importing csv' do
  subject { described_class.call logger: logger }

  include_context 'stubbed download'

  let(:logger) { instance_spy Logger }
  let(:model) { stock_model::RELATED_MODEL }

  describe '#success' do
    it { is_expected.to be_success }

    it 'imports a new stock successfully' do
      subject
      expect(stock_model.current).to have_attributes(
        year: imported_year,
        month: imported_month,
        status: 'COMPLETED'
      )
    end

    it 'persists 3 UniteLegale in temp table' do
      subject
      data = get_raw_data(model.table_name + '_tmp')
      expect(data.count).to eq 3
    end

    it 'deletes tmp file' do
      subject
      expect(expected_tmp_file).not_to exist
    end

    it 'read the file by chunk' do
      expect(SmarterCSV)
        .to receive(:process)
        .with(expected_tmp_file.to_s, a_hash_including(chunk_size: 10_000))
      subject
    end

    it 'import the data by batch' do
      expect(model).to receive(:import).with(
        [
          a_hash_including(siren: expected_sirens[0]),
          a_hash_including(siren: expected_sirens[1]),
          a_hash_including(siren: expected_sirens[2])
        ],
        validate: false
      ).and_call_original

      subject
    end
  end

  describe 'when ImportCSV fails' do
    before do
      # trick to make a nested operation to fail
      allow_any_instance_of(Stock::Task::ImportCSV)
        .to receive(:file_exists?)
        .and_return false
    end

    it { is_expected.to be_success }

    it 'imports a new stock in error' do
      subject
      expect(stock_model.current).to have_attributes(
        year: imported_year,
        month: imported_month,
        status: 'ERROR'
      )
    end

    it 'does not persist anything' do
      expect { subject }.not_to change(model, :count)
    end

    it 'deletes tmp file' do
      subject
      expect(expected_tmp_file).not_to exist
    end
  end
end

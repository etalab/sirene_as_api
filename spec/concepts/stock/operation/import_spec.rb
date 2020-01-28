require 'rails_helper'

describe Stock::Operation::Import, :trb do
  subject { described_class.call stock: stock, logger: logger }

  include_context 'stubbed download'

  let(:stock) { create :stock_etablissement }
  let(:logger) { instance_spy Logger }
  let!(:existing_etab) { create :etablissement }
  let(:downloaded_fixture_file) do
    Rails.root.join('spec', 'fixtures', 'sample_etablissements.csv.gz').to_s
  end

  it 'truncates the table' do
    expect_to_call_nested_operation(Stock::Task::TruncateTable)
    subject
  end

  it 'imports within a temporary model' do
    model = subject[:model]
    expect(model.table_name).to end_with('_tmp')
    expect(model.name).to eq('TmpModelEtablissement')
  end

  it 'imports data in the temporary table' do
    tmp_model = subject[:model]
    expect(tmp_model.count).to eq(3)
  end

  it 'truncates the temporary table before inserting' do
    model = stock.class::RELATED_MODEL

    wrap_with_table_renamed(model) do
      etab = model.create
      expect(model.first).to eq etab
    end

    tmp_model = subject[:model]
    expect(tmp_model.count).to eq(3)
  end

  it 'does not imports data in the regular table' do
    expect { subject }.not_to change(Etablissement, :count)
    existing_etab.reload
    expect(existing_etab).to be_persisted
  end

  it 'deletes extracted files when success' do
    file = Pathname.new subject[:extracted_file]
    expect(file).not_to exist
  end

  it 'deletes extracted files when failure' do
    allow_any_instance_of(described_class).to receive(:csv).and_return(false)
    file = Pathname.new subject[:extracted_file]
    expect(file).not_to exist
  end

  it 'deletes downloaded files when success' do
    file = Pathname.new subject[:file_path]
    expect(file).not_to exist
  end

  it 'deletes downloaded files when failure' do
    allow_any_instance_of(described_class).to receive(:csv).and_return(false)
    file = Pathname.new subject[:file_path]
    expect(file).not_to exist
  end
end

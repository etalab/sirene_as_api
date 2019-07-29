require 'rails_helper'

describe Stock::Operation::Import, :trb do
  subject { described_class.call stock: stock, logger: logger }

  include_context 'mute progress bar'
  include_context 'stubbed download'

  let(:stock) { create :stock_etablissement }
  let(:logger) { instance_spy Logger }
  let!(:existing_etab) { create :etablissement }
  let(:mocked_downloaded_file) do
    Rails.root.join('spec', 'fixtures', 'sample_etablissements.csv.gz').to_s
  end

  it 'truncates the table' do
    expect_to_call_nested_operation(Stock::Task::TruncateTable)
    subject
  end

  it 'drops the indexes' do
    expect_to_call_nested_operation(Stock::Task::DropIndexes)
    subject
  end

  it 'imports data successfully' do
    expect { subject }.to change(Etablissement, :count).by(3-1)
  end
end

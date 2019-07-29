require 'rails_helper'

describe Stock::Operation::Import do
  subject { described_class.call stock: stock, logger: logger }

  include_context 'stubbed download'

  let(:stock) { create :stock_etablissement }
  let(:logger) { instance_spy Logger }
  let!(:existing_etab) { create :etablissement }
  let(:mocked_downloaded_file) do
    Rails.root.join('spec', 'fixtures', 'sample_etablissements.csv.gz').to_s
  end

  it 'truncates the table' do
    expect { Etablissement.find(existing_etab.id) }.not_to raise_error
    subject
    expect { Etablissement.find(existing_etab.id) }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'imports data successfully' do
    expect { subject }.to change(Etablissement, :count).by(3-1)
  end
end

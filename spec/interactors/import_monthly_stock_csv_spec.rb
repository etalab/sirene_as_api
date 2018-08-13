require 'rails_helper'
require 'timecop'

describe ImportMonthlyStockCsv do
  before(:all) do
    Timecop.freeze(Time.utc(2018, 9, 1, 10, 5, 0))
  end

  after(:all) do
    Timecop.return
  end

  context 'when importing file' do
    it 'succeed' do
      expected_query_string = File.read('spec/fixtures/sample_patches/import_monthly_csv_query.txt')
      sample_file = 'spec/fixtures/sample_patches/import_last_monthly_stock_test.csv'

      allow(Etablissement).to receive(:count).and_return(2)
      allow_any_instance_of(described_class).to receive(:clean_database?) { true }
      expect(ActiveRecord::Base).to receive_message_chain(:connection, :execute).with(expected_query_string)
      described_class.call(unzipped_files: [sample_file])
    end
  end
end

# describe ImportMonthlyStockCsv do
#   subject(:context) { described_class.call(unzipped_files: ['spec/fixtures/sample_patches/import_last_monthly_stock_test.csv']) }
#   context 'when database not empty' do
#     it 'fails' do
#       allow(Etablissement).to receive(:count).and_return(0)
#       allow_any_instance_of(described_class).to receive(:clean_database?) { false }
#       expect(context).to be_a_failure
#     end
#   end
# end

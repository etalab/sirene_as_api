require 'rails_helper'

describe StockAndMajFilesRetrieverService do

  subject { described_class }

  before do
    Timecop.freeze(Time.new(2017,2,15,12))
  end

  it 'last_monthly_stock_zip_file_name' do
    expect(subject.last_monthly_stock_zip_file_name).to eq('sirene_201702_L_M.zip')
  end

  describe '#needed_files' do
    it 'when 15th day of month' do
      expect(subject.needed_files.length).to eq(10)
    end
  end
end

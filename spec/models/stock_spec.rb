require 'rails_helper'

describe Stock do
  it { is_expected.to have_db_column(:id).of_type(:integer) }
  it { is_expected.to have_db_column(:year).of_type(:string) }
  it { is_expected.to have_db_column(:month).of_type(:string) }
  it { is_expected.to have_db_column(:status).of_type(:string) }
  it { is_expected.to have_db_column(:uri).of_type(:string) }
  it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
  it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }

  describe '#imported?' do
    it 'returns true when stock COMPLETED' do
      stock = create :stock, status: 'COMPLETED'
      expect(stock).to be_imported
    end

    it 'returns false when stock not COMPLETED' do
      stock = create :stock, status: 'ERROR'
      expect(stock).not_to be_imported
    end
  end

  describe '#current' do
    it 'returns the latest stock' do
      current = create :stock, year: '2019', month: '05'
      create :stock, year: '2019', month: '01'
      create :stock, year: '2018', month: '10'
      expect(described_class.current).to eq current
    end
  end

  describe '#newer?' do
    subject { build :stock, year: '2019', month: '06' }

    let(:last_year_stock) { build :stock, year: '2018', month: '10' }
    let(:last_month_stock) { build :stock, year: '2019', month: '01' }

    specify 'previous year stock is older' do
      expect(subject.newer?(last_year_stock)).to be true
    end

    specify 'previous month stock is older' do
      expect(subject.newer?(last_month_stock)).to be true
    end

    specify 'same stock is not newer' do
      expect(subject.newer?(subject)).to be true
    end
  end
end

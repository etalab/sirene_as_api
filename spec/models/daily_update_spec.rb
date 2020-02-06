require 'rails_helper'

describe DailyUpdate do
  it { is_expected.to have_db_column(:id).of_type(:integer) }
  it { is_expected.to have_db_column(:type).of_type(:string) }
  it { is_expected.to have_db_column(:status).of_type(:string) }
  it { is_expected.to have_db_column(:from).of_type(:datetime) }
  it { is_expected.to have_db_column(:to).of_type(:datetime) }
  it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
  it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }

  it 'returns the latest daily update' do
    create :daily_update, to: Time.new(2020, 1, 29) # same day but created before
    current = create :daily_update, to: Time.new(2020, 1, 29)
    create :daily_update, to: Time.new(2020, 1, 21)
    expect(described_class.current).to eq current
  end

  describe '#status' do
    it 'is completed' do
      daily_update = create :daily_update, :completed
      expect(daily_update).to be_completed
    end

    it 'is completed' do
      daily_update = create :daily_update, :loading
      expect(daily_update).not_to be_completed
    end
  end
end

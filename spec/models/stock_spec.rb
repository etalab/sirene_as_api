require 'rails_helper'

describe Stock do
  it { is_expected.to have_db_column(:id).of_type(:integer) }
  it { is_expected.to have_db_column(:type).of_type(:string) }
  it { is_expected.to have_db_column(:year).of_type(:string) }
  it { is_expected.to have_db_column(:month).of_type(:string) }
  it { is_expected.to have_db_column(:status).of_type(:string) }
  it { is_expected.to have_db_column(:uri).of_type(:string) }
  it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
  it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }

  describe '#imported?' do
    it 'returns true when stock COMPLETED' do
      stock = create :stock, :completed
      expect(stock).to be_imported
    end

    it 'returns false when stock not COMPLETED' do
      stock = create :stock, :errored
      expect(stock).not_to be_imported
    end
  end

  describe '#current' do
    it 'returns the latest stock' do
      current = create :stock, :of_july, :completed
      create :stock, :of_last_year, :completed
      create :stock, :of_june, :completed
      expect(described_class.current).to eq current
    end

    it 'returns the latest stock even in ERROR state' do
      create :stock, :of_june, :completed
      current = create :stock, :of_july, :errored
      expect(described_class.current).to eq current
    end

    it 'returns the latest COMPLETED stock' do
      create :stock, :of_july, :errored
      current = create :stock, :of_july, :completed
      create :stock, :of_june, :completed
      expect(described_class.current).to eq current
    end
  end

  describe '#importable?' do
    subject { build :stock, :of_july }

    # truth table
    # database empty : always import
    # importable? | remote stock newer ? | current stock errored ?
    #           0 |                    0 |                       0
    #           1 |                    0 |                       1
    #           1 |                    1 |                       0
    #           1 |                    1 |                       1
    # should not import ONLY when remote stock not newer
    # and current stock completed
    #
    # /!\ current stock stuck in LOADING/PENDING not handled
    # another problem would be somewhere else
    #
    context 'no' do
      it 'is not importable, remote stock not newer & current stock not errored (0|0)' do
        create :stock, :of_july, status: 'anything'
        expect(subject).not_to be_importable
      end
    end

    context 'yes' do
      it 'is importable with an empty database' do
        expect(subject).to be_importable
      end

      it 'is importable, remote stock not newer & current stock errored (0|1)' do
        create :stock, :of_july, :errored
        expect(subject).to be_importable
      end

      it 'is importable, remote stock newer & current stock not errored (1|0)' do
        create :stock, :of_june, :completed
        expect(subject).to be_importable
      end

      it 'is importable, remote stock newer & current stock errored (1|1)' do
        create :stock, :of_june, :errored
        expect(subject).to be_importable
      end
    end
  end

  describe '#newer?' do
    subject { build :stock, :of_july }

    it 'is newer than previous year stock' do
      expect(subject.newer?(build(:stock, :of_last_year))).to be true
    end

    it 'is newer than previous month stock' do
      expect(subject.newer?(build(:stock, :of_june))).to be true
    end

    it 'is older than same stock' do
      expect(subject.newer?(build(:stock, :of_july))).to be false
    end

    it 'is older than next month stock' do
      expect(subject.newer?(build(:stock, :of_august))).to be false
    end
  end
end

require 'rails_helper'

describe DailyUpdate do
  it { is_expected.to have_db_column(:id).of_type(:integer) }
  it { is_expected.to have_db_column(:model_name_to_update).of_type(:string) }
  it { is_expected.to have_db_column(:status).of_type(:string) }
  it { is_expected.to have_db_column(:from).of_type(:datetime) }
  it { is_expected.to have_db_column(:to).of_type(:datetime) }
  it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
  it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }

  describe '#model_to_update' do
    context 'with unite legale' do
      subject { described_class.new(model_name_to_update: 'unite_legale') }

      its(:model_to_update) { is_expected.to be UniteLegale }
      its(:logger_for_import) { is_expected.to be_a Logger }

      it 'has a valid log filename' do
        expect(Logger).to receive(:new)
          .with(%r{log\/daily_update_unite_legale.log})
        subject.logger_for_import
      end
    end

    context 'with etablissement' do
      subject { described_class.new(model_name_to_update: 'etablissement') }

      its(:model_to_update) { is_expected.to be Etablissement }
      its(:logger_for_import) { is_expected.to be_a Logger }

      it 'has a valid log filename' do
        expect(Logger).to receive(:new)
          .with(%r{log\/daily_update_etablissement.log})
        subject.logger_for_import
      end
    end
  end
end

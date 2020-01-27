require 'rails_helper'

describe DailyUpdateUniteLegale do
  subject { build :daily_update_unite_legale }

  its(:related_model) { is_expected.to be UniteLegale }
  its(:related_model_name) { is_expected.to be :unite_legale }
  its(:logger_for_import) { is_expected.to be_a Logger }

  it 'has a valid log filename' do
    expect(Logger).to receive(:new)
      .with(%r{log\/daily_update_unite_legale.log})
    subject.logger_for_import
  end
end

require 'rails_helper'

describe DailyUpdateUniteLegale do
  subject { build :daily_update_unite_legale }

  its(:related_model) { is_expected.to be UniteLegale }
  its(:business_key) { is_expected.to eq :siren }
  its(:insee_results_body_key) { is_expected.to eq :unitesLegales }
  its(:insee_resource_suffix) { is_expected.to eq 'siren/' }
  its(:adapter_task) { is_expected.to be INSEE::Task::AdaptUniteLegale }
  its(:logger_for_import) { is_expected.to be_a Logger }

  it 'has a valid log filename' do
    expect(Logger).to receive(:new)
      .with(%r{log/daily_update_unite_legale.log})
    subject.logger_for_import
  end
end

require 'rails_helper'

describe DailyUpdateUniteLegaleNonDiffusable, type: :model do
  subject { build :daily_update_unite_legale_non_diffusable }

  its(:related_model) { is_expected.to be UniteLegale }
  its(:business_key) { is_expected.to eq :siren }
  its(:insee_results_body_key) { is_expected.to eq :unitesLegalesNonDiffusibles }
  its(:insee_resource_suffix) { is_expected.to eq 'siren/nonDiffusibles' }
  its(:adapter_task) { is_expected.to be INSEE::Task::AdaptUniteLegale }
  its(:logger_for_import) { is_expected.to be_a Logger }

  it 'has a valid log filename' do
    expect(Logger).to receive(:new)
      .with(%r{log/daily_update_unite_legale_non_diffusable.log})
    subject.logger_for_import
  end
end

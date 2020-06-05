require 'rails_helper'

describe DailyUpdateEtablissementNonDiffusable, type: :model do
  subject { build :daily_update_etablissement_non_diffusable }

  its(:related_model) { is_expected.to be Etablissement }
  its(:business_key) { is_expected.to eq :siret }
  its(:insee_results_body_key) { is_expected.to eq :etablissementsNonDiffusibles }
  its(:insee_resource_suffix) { is_expected.to eq 'siret/nonDiffusibles' }
  its(:adapter_task) { is_expected.to be INSEE::Task::AdaptEtablissement }
  its(:logger_for_import) { is_expected.to be_a Logger }

  it 'has a valid log filename' do
    expect(Logger).to receive(:new)
      .with(%r{log/daily_update_etablissement_non_diffusable.log})
    subject.logger_for_import
  end
end

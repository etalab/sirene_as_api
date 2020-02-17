require 'rails_helper'

describe Stock::Task::UpdateNonDiffusable do
  subject { described_class.call }

  it 'persists daily update unite legale non diffusable' do
    expect(subject[:du_unite_legale_nd]).to be_persisted
  end

  it 'schedules DailyUpdateJob for unite legale non diffusable' do
    id = subject[:du_unite_legale_nd].id
    expect(DailyUpdateModelJob)
      .to have_been_enqueued
      .with(id)
      .on_queue('sirene_api_test_auto_updates')
  end

  it 'creates a valid daily update unite legale non diffusable' do
    du = subject[:du_unite_legale_nd]
    expect(du).to have_attributes(
      type: 'DailyUpdateUniteLegaleNonDiffusable',
      status: 'PENDING',
      update_type: 'full'
    )
  end

  it 'persists daily update etablissement non diffusable' do
    expect(subject[:du_etablissement_nd]).to be_persisted
  end

  it 'schedules DailyUpdateJob for etablissement non diffusable' do
    id = subject[:du_etablissement_nd].id
    expect(DailyUpdateModelJob)
      .to have_been_enqueued
      .with(id)
      .on_queue('sirene_api_test_auto_updates')
  end

  it 'creates a valid daily update etablissement non diffusable' do
    du = subject[:du_etablissement_nd]
    expect(du).to have_attributes(
      type: 'DailyUpdateEtablissementNonDiffusable',
      status: 'PENDING',
      update_type: 'full'
    )
  end
end

require 'rails_helper'

describe DailyUpdate::Operation::UpdateDatabase, :trb do
  subject { described_class.call logger: logger }

  let(:logger) { instance_spy Logger }
  let(:froze_time) { Time.zone.local(2020, 1, 19, 15, 0, 0) }
  let(:beginning_of_month) { Time.zone.local(2020, 1, 1) }

  before { Timecop.freeze(froze_time) }

  context 'when stock import is completed' do
    let!(:stock_unite_legale) { create :stock_unite_legale, :completed }
    let!(:stock_etablissement) { create :stock_etablissement, :completed }

    it { is_expected.to be_success }

    it 'perists daily update unite legale' do
      expect(subject[:du_unite_legale]).to be_persisted
    end

    it 'schedules DailyUpdateJob for unite legale' do
      id = subject[:du_unite_legale].id
      expect(DailyUpdateModelJob)
        .to have_been_enqueued
        .with(id)
        .on_queue('sirene_api_test_auto_updates')
    end

    it 'creates a valid unite legale daily update' do
      du = subject[:du_unite_legale]
      expect(du).to have_attributes(
        type: 'DailyUpdateUniteLegale',
        status: 'PENDING',
        from: beginning_of_month,
        to: froze_time
      )
    end

    it 'persists daily update etablissement' do
      expect(subject[:du_etablissement]).to be_persisted
    end

    it 'schedules DailyUpdateJob for etablissement' do
      id = subject[:du_etablissement].id
      expect(DailyUpdateModelJob)
        .to have_been_enqueued
        .with(id)
        .on_queue('sirene_api_test_auto_updates')
    end

    it 'creates a valid etablissement daily update' do
      du = subject[:du_etablissement]
      expect(du).to have_attributes(
        type: 'DailyUpdateEtablissement',
        status: 'PENDING',
        from: beginning_of_month,
        to: froze_time
      )
    end

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
        from: beginning_of_month,
        to: froze_time
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
        from: beginning_of_month,
        to: froze_time
      )
    end
  end

  context 'when stock import is not completed' do
    let!(:stock_unite_legale) { create :stock_unite_legale, :completed }
    let!(:stock_etablissement) { create :stock_etablissement, :pending }

    it { is_expected.to be_failure }

    it 'does not enqueue any job' do
      expect { subject }.not_to have_enqueued_job(DailyUpdateModelJob)
    end
  end
end

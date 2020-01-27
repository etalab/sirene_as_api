require 'rails_helper'

describe DailyUpdate::Operation::UpdateDatabase, :trb do
  subject { described_class.call logger: logger }

  let(:logger) { instance_spy Logger }

  before { Timecop.freeze(Time.new(2020, 1, 19, 15, 0, 0)) }

  context 'when stock import is completed' do
    let!(:stock_unite_legale) { create :stock_unite_legale, :completed }
    let!(:stock_etablissement) { create :stock_etablissement, :completed }

    it { is_expected.to be_success }

    its([:du_unite_legale]) { is_expected.to be_persisted }

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
        model_name_to_update: 'unite_legale',
        status: 'PENDING',
        from: Time.new(2020, 1, 1),
        to: Time.new(2020, 1, 19, 15, 0, 0)
      )
    end

    its([:du_etablissement]) { is_expected.to be_persisted }

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
        model_name_to_update: 'etablissement',
        status: 'PENDING',
        from: Time.new(2020, 1, 1),
        to: Time.new(2020, 1, 19, 15, 0, 0)
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

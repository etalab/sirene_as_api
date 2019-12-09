require 'rails_helper'

describe DailyUpdate::Operation::UpdateDatabase, :trb do
  subject { described_class.call logger: logger }

  let(:logger) { instance_spy Logger }

  context 'when stock import is completed' do
    let!(:stock_unite_legale) { create :stock_unite_legale, :completed }
    let!(:stock_etablissement) { create :stock_etablissement, :completed }

    it { is_expected.to be_success }

    it 'schedules DailyUpdateJob for unite legale' do
      expect { subject }
        .to have_enqueued_job(DailyUpdateModelJob)
        .with('unite_legale')
    end

    it 'schedules DailyUpdateJob for etablissement' do
      expect { subject }
        .to have_enqueued_job(DailyUpdateModelJob)
        .with('etablissement')
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

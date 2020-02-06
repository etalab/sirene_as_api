require 'rails_helper'

describe DailyUpdate::Operation::PostUpdate, :trb do
  subject { described_class.call logger: logger }

  let(:logger) { instance_spy Logger }

  context 'when all daily updates are done' do
    before do
      create :daily_update_unite_legale, :completed
      create :daily_update_etablissement, :completed
    end

    it { is_expected.to be_success }

    it 'logs post update starts' do
      subject
      expect(logger).to have_received(:info)
        .with('PostUpdate starts')
    end

    it 'logs post update done' do
      subject
      expect(logger).to have_received(:info)
        .with('PostUpdate done')
    end

    it 'call CreateAssociations' do
      expect_to_call_nested_operation(DailyUpdate::Task::CreateAssociations)
      subject
    end
  end

  context 'when one daily update is running' do
    before do
      create :daily_update_unite_legale, :loading
      create :daily_update_etablissement, :completed
    end

    it { is_expected.to be_failure }

    it 'logs post update starts' do
      subject
      expect(logger).to have_received(:info)
        .with('PostUpdate starts')
    end

    it 'logs post update fails' do
      subject
      expect(logger).to have_received(:error)
        .with('PostUpdate failed, an update is still running')
    end

    it 'does not call CreateAssociations' do
      expect_not_to_call_nested_operation(DailyUpdate::Task::CreateAssociations)
      subject
    end
  end
end

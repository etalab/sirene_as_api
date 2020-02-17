require 'rails_helper'

describe DailyUpdateModelJob, :trb do
  subject { described_class.perform_now daily_update.id }

  let(:daily_update) { create :daily_update_unite_legale }
  let(:import_logger) { instance_spy Logger }

  before do
    allow_any_instance_of(DailyUpdate)
      .to receive(:logger_for_import)
      .and_return(import_logger)
  end

  context 'when the import is a success' do
    before do
      allow(DailyUpdate::Operation::Update)
        .to receive(:call)
        .and_return(trb_result_success)
      allow(DailyUpdate::Operation::PostUpdate)
        .to receive(:call)
        .and_return(trb_result_success)
    end

    it 'set status to COMPLETED' do
      subject
      daily_update.reload
      expect(daily_update.status).to eq 'COMPLETED'
    end

    it 'calls the update operation' do
      expect(DailyUpdate::Operation::Update)
        .to receive(:call)
        .with(daily_update: daily_update, logger: import_logger)
      subject
    end

    it 'calls the post update operation' do
      expect(DailyUpdate::Operation::PostUpdate)
        .to receive(:call)
      subject
    end
  end

  context 'when the import is a failure' do
    before do
      allow(DailyUpdate::Operation::Update)
        .to receive(:call)
        .and_wrap_original do
          create :unite_legale, siren: 'GHOST'
          trb_result_failure
        end
    end

    it 'set status to ERROR' do
      subject
      daily_update.reload
      expect(daily_update.status).to eq 'ERROR'
    end

    it 'rollback the operation' do
      subject
      unites_legales = UniteLegale.where(siren: 'GHOST')
      expect(unites_legales).to be_empty
    end

    it 'does not call post update operation' do
      expect(DailyUpdate::Operation::PostUpdate)
        .not_to receive(:call)
      subject
    end
  end
end

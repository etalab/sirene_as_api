require 'rails_helper'

describe DailyUpdate::Operation::PostUpdate, :trb do
  subject { described_class.call logger: logger }

  let(:logger) { instance_spy Logger }

  context 'when there are not daily update yet' do
    it { is_expected.to be_success }
  end

  context 'when all daily updates are done' do
    before do
      create :daily_update_unite_legale, :completed
      create :daily_update_etablissement, :completed
      create :daily_update_unite_legale_non_diffusable, :completed
      create :daily_update_etablissement_non_diffusable, :completed
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
    shared_examples 'an update is still running' do
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

    context 'update unite legale still running' do
      before do
        create :daily_update_unite_legale, :loading
        create :daily_update_etablissement, :completed
        create :daily_update_unite_legale_non_diffusable, :completed
        create :daily_update_etablissement_non_diffusable, :completed
      end

      it_behaves_like 'an update is still running'
    end

    context 'update etablissement still running' do
      before do
        create :daily_update_unite_legale, :completed
        create :daily_update_etablissement, :loading
        create :daily_update_unite_legale_non_diffusable, :completed
        create :daily_update_etablissement_non_diffusable, :completed
      end

      it_behaves_like 'an update is still running'
    end

    context 'update unite legale non diffusable still running' do
      before do
        create :daily_update_unite_legale, :completed
        create :daily_update_etablissement, :completed
        create :daily_update_unite_legale_non_diffusable, :loading
        create :daily_update_etablissement_non_diffusable, :completed
      end

      it_behaves_like 'an update is still running'
    end

    context 'update etablissement non diffusable still running' do
      before do
        create :daily_update_unite_legale, :completed
        create :daily_update_etablissement, :completed
        create :daily_update_unite_legale_non_diffusable, :completed
        create :daily_update_etablissement_non_diffusable, :loading
      end

      it_behaves_like 'an update is still running'
    end
  end
end

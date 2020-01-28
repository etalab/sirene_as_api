require 'rails_helper'

describe DailyUpdate::Task::CurrentStockCompleted do
  subject { described_class.call logger: logger }

  let(:logger) { instance_spy Logger }

  context 'when current stock is completed' do
    let!(:stock_unite_legale) { create :stock_unite_legale, :completed }
    let!(:stock_etablissement) { create :stock_etablissement, :completed }

    it { is_expected.to be_success }
  end

  shared_examples 'not ready for daily update' do
    it { is_expected.to be_failure }

    it 'logs an error' do
      subject
      expect(logger).to have_received(:error)
        .with(/Stock .+ not completed \((LOADING|PENDING|ERROR|NOT FOUND)\), skipping daily update/)
    end
  end

  context 'when stock unite legale is not completed' do
    let!(:stock_unite_legale) { create :stock_unite_legale, :errored }
    let!(:stock_etablissement) { create :stock_etablissement, :completed }

    it_behaves_like 'not ready for daily update'
  end

  context 'when stock etablissement is not completed' do
    let!(:stock_unite_legale) { create :stock_unite_legale, :completed }
    let!(:stock_etablissement) { create :stock_etablissement, :loading }

    it_behaves_like 'not ready for daily update'
  end

  context 'when not stock has been imported' do
    it_behaves_like 'not ready for daily update'
  end
end

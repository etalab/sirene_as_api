require 'rails_helper'

describe DailyUpdate::Operation::Update, :trb do
  subject { described_class.call model: model, logger: logger }

  let(:logger) { instance_spy Logger }

  before { Timecop.freeze Time.new(2019, 12, 4) }

  context 'when updating UniteLegale' do
    let(:model) { UniteLegale }

    it { is_expected.to be_success }

    it 'logs the period to import' do
      subject
      expect(logger).to have_received(:info)
        .with('Importing from 2019-12-01 to 2019-12-04')
    end

    it 'fetch updates' do
      expect_to_call_nested_operation(INSEE::Operation::FetchUpdates)
      subject
    end

    it 'adapt INSEE reponse to be updatable' do
      expect_to_call_nested_operation(DailyUpdate::Task::AdaptApiResults)
      subject
    end

    it 'update or create entities' do
      expect_to_call_nested_operation(DailyUpdate::Task::Supersede)
      subject
    end
  end
end

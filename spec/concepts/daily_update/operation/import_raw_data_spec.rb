require 'rails_helper'

describe INSEE::Operation::ImportRawData, :trb do
  subject { described_class.call api_results: api_results, daily_update: daily_update, logger: logger }

  let(:logger) { instance_spy Logger }
  let(:daily_update) { create :daily_update_unite_legale }
  let(:fixture_file) { 'spec/fixtures/samples_insee/api_results.json' }
  let(:api_results) { JSON.parse(File.read(fixture_file), symbolize_names: true) }

  context 'when updating some UniteLegale' do
    it { is_expected.to be_success }

    it 'adapt INSEE reponse to be updatable' do
      expect_to_call_nested_operation(INSEE::Task::AdaptApiResults)
      subject
    end

    it 'update or create entities' do
      expect_to_call_nested_operation(INSEE::Task::Supersede).exactly(20).times
      subject
    end

    context 'when a supersede fails' do
      before do
        allow(INSEE::Task::Supersede)
          .to receive(:call)
          .and_return(trb_result_failure_with(data: { siren: 'XXXXXXXXX' }))
      end

      it 'continues updatings' do
        expect(subject).to be_success
      end
    end
  end
end
